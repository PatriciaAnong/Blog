resource helm_release wp {

  count = terraform.workspace != "default" ? 1 : 0

  name       = "wp"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "wordpress"

  cleanup_on_fail = true
  force_update    = true
  recreate_pods   = false
  reset_values    = true

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

}

resource kubernetes_ingress ingress {

  count = terraform.workspace != "default" ? 1 : 0

  metadata {
    name = "ingress"

    labels = merge(
      tomap({ "name" = local.namespace }),
      var.tags
    )

    annotations = {
      "cert-manager.io/cluster-issuer" = "letsencrypt-${var.environment}"

      "kubernetes.io/ingress.class" = "nginx"

    }
  }

  spec {
    backend {
      service_name = "${helm_release.wp[count.index].metadata[0].name}-${helm_release.wp[count.index].metadata[0].chart}"

      service_port = 80
    }

    rule {
      host = "${helm_release.wp[count.index].metadata[0].name}-${var.environment}.com"
      http {
        path {
          backend {
            service_name = "${helm_release.wp[count.index].metadata[0].name}-${helm_release.wp[count.index].metadata[0].chart}"
            service_port = 80
          }
          path = "/"
        }
      }
    }

    tls {
      hosts = ["${helm_release.wp[count.index].metadata[0].name}-${var.environment}.com"]

      secret_name = "${helm_release.wp[count.index].metadata[0].name}-${var.environment}-ssl-cert"
    }
  }
}
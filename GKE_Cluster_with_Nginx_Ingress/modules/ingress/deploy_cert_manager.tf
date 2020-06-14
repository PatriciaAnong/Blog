resource helm_release issuer {
  count = terraform.workspace != "default" ? 1 : 0
  depends_on = [ helm_release.cert-manager ]

  name      = "certs"
  namespace = local.namespace
  chart     = "${path.module}/certs"

  force_update    = true
  cleanup_on_fail = true
  recreate_pods   = false
  reset_values    = false

  create_namespace = true

  values = [local.helm_chart_values]
}

resource helm_release cert-manager {
  count = terraform.workspace != "default" ? 1 : 0

  name       = "cert-manager"
  namespace  = local.namespace
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"

  force_update     = false
  create_namespace = true

  set {
    name  = "installCRDs"
    value = true
  }

}
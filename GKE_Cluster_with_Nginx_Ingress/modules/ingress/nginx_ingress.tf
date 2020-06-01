resource helm_release ingress {

  count = terraform.workspace != "default" ? 1 : 0

  name       = "nginx"

  repository = "https://kubernetes-charts.storage.googleapis.com"

  chart      = "nginx-ingress"

  version = ""
  force_update = true

  cleanup_on_fail = true

  set {
    name  = "rbac.create"
    value = true
  }

  set {
    name  = "podSecurityPolicy.enabled"
    value = true
  }

  set {
    name  = "controller.publishService.enabled"
    value = true
  }

}
locals {

  sa_name = "dns-sa-${var.name_prefix}-${var.environment}"

  namespace = "certs-manager"

  template_vars = {
    project = var.project,

    env = var.environment,

    name = "letsencrypt-${var.environment}",

    email = "devops@patricia-anong.com",

    namespace = local.namespace,

    dns_secret_name = kubernetes_secret.dns_sa_credentials[0].metadata[0].name,

  }

  helm_chart_values = templatefile(
    "${path.module}/certs/values.yaml.tpl",
    local.template_vars
  )

}
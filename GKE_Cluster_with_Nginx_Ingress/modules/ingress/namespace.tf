resource kubernetes_namespace certs {
  count = terraform.workspace != "default" ? 1 : 0

  metadata {
    annotations = {
      name = local.namespace
    }

    labels = merge(
      tomap({ "name" = local.namespace }),
      var.tags
    )
    name = local.namespace
  }
}
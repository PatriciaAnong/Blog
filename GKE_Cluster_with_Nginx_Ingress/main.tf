module gke {

  source      = "./modules/gke"
  project     = var.project
  region      = var.region
  enable_apis = var.enable_apis
  environment = local.env
  name_prefix = var.name_prefix
  tags        = [lower(local.common_tags["iac"]), lower(local.common_tags["environment"]), lower(local.common_tags["owner"])]

  master_authorized_networks_config = var.master_authorized_networks_config

  shielded_instance_config = var.shielded_instance_config

}

module ingress {
  source      = "./modules/ingress"
  project     = var.project
  region      = var.region
  environment = local.env
  name_prefix = var.name_prefix
  tags        = local.common_tags
}
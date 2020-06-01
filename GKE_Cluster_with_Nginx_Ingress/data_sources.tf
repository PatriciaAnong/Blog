locals {
  env = terraform.workspace
  common_tags = {
    iac         = "deployed-via-terraform"
    environment = local.env
    owner       = "patricia-anong"
  }
}

provider "google" {
  credentials = "${file("creds.json")}"
  project     = var.project
  region      = "us-east1"
}

module "instance" {
  source       = "./modules/instance"
  namespace    = var.namespace
  name         = var.name
  environment  = var.environment
  machine_type = var.machine_type
  enabled      = var.enabled
}

module "bucket" {
  source                = "./modules/storage"
  namespace             = var.namespace
  name                  = var.name
  environment           = var.environment
  encryption            = var.encryption
  enabled               = var.enabled
  matches_storage_class = var.matches_storage_class
}




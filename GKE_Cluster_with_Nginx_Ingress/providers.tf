provider google {
  project     = var.project
  region      = var.region
  credentials = file("creds.json")
}


provider google-beta {
  project     = var.project
  region      = var.region
  credentials = file("creds.json")
}

# The Kubernetes Provider
provider kubernetes {
  host                   = module.gke.endpoint[0]
  client_certificate     = module.gke.client_certificate
  client_key             = module.gke.client_key
  cluster_ca_certificate = module.gke.cluster_ca_certificate
}

# The Helm provider
provider helm {
  kubernetes {
    host                   = module.gke.endpoint[0]
    client_certificate     = module.gke.client_certificate
    client_key             = module.gke.client_key
    cluster_ca_certificate = module.gke.cluster_ca_certificate
  }
}

# The Null Provider
provider null {
}
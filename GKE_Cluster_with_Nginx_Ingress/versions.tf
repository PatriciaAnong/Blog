terraform {
  required_version = "~> 0.12.25"
  required_providers {
    google      = "~> 3.23.0"
    google-beta = "~> 3.23.0"
    random      = "~> 2.2"
    kubernetes  = "~> 1.11"
    helm        = "~> 1.2"
  }
}
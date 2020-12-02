project     = "panong-blog-gke"
region      = "us-east1"
environment = "dev"
name_prefix = "devops-rules"

master_authorized_networks_config = [
  {
    cidr_blocks = [
      {
        cidr_block   = "86.75.30.9/32"
        display_name = "Jenny"
      },
    ]
  },
]

shielded_instance_config = {
  enable_secure_boot          = true
  enable_integrity_monitoring = true
}

enable_apis = {
  kubernetes     = "container.googleapis.com"
  iam            = "iam.googleapis.com"
  cloud_resource = "cloudresourcemanager.googleapis.com"
}
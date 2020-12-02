resource google_project_service project {
  for_each = terraform.workspace != "default" ? var.enable_apis : {}
  project = var.project
  service = each.value

  disable_dependent_services = true
}

// Wait for the API to be enabled before proceeding
resource null_resource wait {
  count = terraform.workspace != "default" ? 1 : 0

  depends_on = [
    var.enable_apis
  ]

  provisioner local-exec {
    command = "sleep 90"
  }

}

resource google_container_cluster k8s {
  count = terraform.workspace != "default" ? 1 : 0
  depends_on = [ google_project_service.project ]

  name     = local.gke_name
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  resource_labels = zipmap(["iac", "environment", "owner"], var.tags)

  master_auth {
    username = var.basic_auth_username
    password = var.basic_auth_password

    client_certificate_config {
      issue_client_certificate = var.enable_client_certificate_authentication
    }
  }

  dynamic master_authorized_networks_config {
    for_each = var.master_authorized_networks_config
    content {
      dynamic "cidr_blocks" {
        for_each = lookup(master_authorized_networks_config.value, "cidr_blocks", [])
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = lookup(cidr_blocks.value, "display_name", null)
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      node_config,
    ]
  }

}

resource google_container_node_pool node_pool {
  count = terraform.workspace != "default" ? 1 : 0

  provider = google-beta

  name     = local.gke_node_name
  location = var.region

  cluster = google_container_cluster.k8s[count.index].name

  initial_node_count = "1"

  autoscaling {
    min_node_count = "1"
    max_node_count = "5"
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    image_type   = "COS"
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = merge({
      name = local.gke_node_name
      }, zipmap(["iac", "environment", "owner"], var.tags)
    )

    tags = concat(
      [
        local.gke_name,
        local.gke_node_name,
      ],
      var.tags
    )

    disk_size_gb = "30"
    disk_type    = "pd-standard"
    preemptible  = false

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]

    shielded_instance_config {
      enable_secure_boot = var.shielded_instance_config["enable_secure_boot"]

      enable_integrity_monitoring = var.shielded_instance_config["enable_integrity_monitoring"]
    }

  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}
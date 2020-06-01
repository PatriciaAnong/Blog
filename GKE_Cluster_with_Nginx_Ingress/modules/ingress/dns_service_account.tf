# DNS Service Account
resource google_service_account service_account {
  count = terraform.workspace != "default" ? 1 : 0

  account_id   = local.sa_name
  display_name = "DNS Service Account managed by Terraform"

}

resource google_project_iam_member service_account_roles {

  count = terraform.workspace != "default" ? 1 : 0

  role = "roles/dns.admin"

  member = "serviceAccount:${google_service_account.service_account[0].email}"
}

## Create Service Account key and Store as Kubernetes Secret
resource google_service_account_key dns_sa_key {

  count = terraform.workspace != "default" ? 1 : 0

  service_account_id = google_service_account.service_account[count.index].name

}

resource kubernetes_secret dns_sa_credentials {

  count = terraform.workspace != "default" ? 1 : 0

  metadata {
    name = "clouddns-sa-key"

    labels = merge(
      tomap({ "name" = "clouddns-sa-key" }),
      var.tags
    )
  }

  data = {
    "credentials.json" = base64decode(google_service_account_key.dns_sa_key[count.index].private_key)
  }

}
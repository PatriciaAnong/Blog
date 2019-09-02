resource "google_storage_bucket" "inspec_files" {
  count         = var.enabled == true ? 1 : 0
  name          = "inspec-files-bucket"
  location      = var.location
  force_destroy = true
  storage_class = var.storage_class
  project       = "inspecplaygroundgcp"

  lifecycle_rule {
    action {
      type          = var.action_type
      storage_class = var.action_storage_class
    }

    condition {
      age                   = var.age
      with_state            = var.with_state
      matches_storage_class = var.matches_storage_class
      num_newer_versions    = var.num_newer_versions
    }
  }

  versioning {
    enabled = var.versioning_enabled
  }

  encryption {
    default_kms_key_name = var.encryption == "" ? "" : "${var.kms_key_name}"
  }
}

resource "null_resource" "UploadFilesToBucket" {
  depends_on = [ google_storage_bucket.inspec_files ]
  count      = var.enabled == true ? 1 : 0
  provisioner "local-exec" {
    command = "gsutil cp -r . gs://inspec-files-bucket"
  }
}

// resource "google_storage_bucket_object" "" {
//   depends_on = [ google_storage_bucket.inspec_files ]
//   count      = var.enabled == true ? 1 : 0
//   name       = "script.sh"
//   source     = "gcp.rb"
//   bucket     = google_storage_bucket.inspec_files
// }

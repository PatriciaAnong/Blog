variable project {
  description = "The project ID to host the cluster in"
  type        = string
}

variable region {
  description = "The region to host the cluster in"
  type        = string
}

variable environment {
  description = "Environment in which to deploy"
  type        = string
}

variable name_prefix {
  description = "Company or Application Name appended to full name of a resource"
  type        = string
}

variable master_authorized_networks_config {
  description = "The desired configuration options for master authorized networks. Omit the nested cidr_blocks attribute to disallow external access (except the cluster node IPs, which GKE automatically whitelists)."
}

variable basic_auth_username {
  description = "The username used for basic auth; set both this and `basic_auth_password` to \"\" to disable basic auth."
  type        = string
  default     = ""
}

variable basic_auth_password {
  description = "The password used for basic auth; set both this and `basic_auth_username` to \"\" to disable basic auth."
  type        = string
  default     = ""
}

variable enable_client_certificate_authentication {
  description = "Whether to enable authentication by x509 certificates. With ABAC disabled, these certificates are effectively useless."
  type        = bool
  default     = false
}

variable shielded_instance_config {
  description = "Enables monitoring and attestation of the boot integrity of the instance."
}

variable tags {
  description = "Tags to be applied to the deployed resources"
  type        = list(string)
}
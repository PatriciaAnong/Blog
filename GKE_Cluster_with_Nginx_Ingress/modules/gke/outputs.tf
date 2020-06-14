output name {
  description = "The name of the cluster master."
  value       = google_container_cluster.k8s[*].name
}

output endpoint {
  description = "The IP address of the cluster master."
  value       = google_container_cluster.k8s[*].endpoint
  depends_on = [
    google_container_cluster.k8s,
    google_container_node_pool.node_pool,
  ]
  sensitive = true
}

output client_certificate {
  description = "Public certificate used by clients to authenticate to the cluster endpoint."
  value       = base64decode(join(",", google_container_cluster.k8s[*].master_auth[0].client_certificate))
  sensitive   = true
}

output client_key {
  description = "Private key used by clients to authenticate to the cluster endpoint."
  value       = base64decode(join(",", google_container_cluster.k8s[*].master_auth[0].client_key))
  sensitive   = true
}

output cluster_ca_certificate {
  description = "The public certificate that is the root of trust for the cluster."
  value       = base64decode(join(",", google_container_cluster.k8s[*].master_auth[0].cluster_ca_certificate))
  sensitive   = true
}
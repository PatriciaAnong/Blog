output cluster_name {
  value = module.gke.name
}

output cluster_endpoint {
  sensitive   = true
  value       = module.gke.endpoint
}

output client_certificate {
  value       = module.gke.client_certificate
}

output client_key {
  value       = module.gke.client_key
}

output cluster_ca_certificate {
  value       = module.gke.cluster_ca_certificate
}
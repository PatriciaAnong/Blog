locals {

  gke_name = "gke-${var.name_prefix}-${var.environment}-${var.region}"

  gke_node_name = "gke-node-${var.name_prefix}-${var.environment}-${var.region}"

}
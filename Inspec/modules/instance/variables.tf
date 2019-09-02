# Shared
variable "namespace" {
  type        = string
  default     = ""
  description = "Namespace, e.g. organization name"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment, e.g. dev, test, prod"
}

variable "name" {
  type        = string
  default     = ""
  description = "Name, e.g. jenkins"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "project" {
  type        = string
  default     = ""
  description = "The project in which the resource will be created. If left blank, the provider project is used."
}

# Compute
variable "machine_type" {
  type        = string
  description = "Machine Type, e.g n1-standard-1"
}

variable "zone" {
  type        = string
  default     = "us-east1-b"
  description = "Zone to create compute resource"
}

variable "image" {
  type        = string
  default     = "ubuntu-1804-lts"
  description = "OS Image for Compute Resource"
}

variable "network" {
  type        = string
  default     = "default"
  description = "Network for Compute Resource"
}

variable "http_source_ips" {
  type        = list(string)
  default     = [ "127.0.0.0/32" ]
  description = "The IPs that can reach the compute resource via ."
}

variable "https_source_ips" {
  type        = list(string)
  default     = [ "127.0.0.0/32" ]
  description = "The IPs that can reach the compute resource via https."
}

variable "scopes" {
  type        = list(string)
  default     = [ "compute-rw", "storage-rw" ]
  description = "The scopes of the service account associated with the compute resources."
}
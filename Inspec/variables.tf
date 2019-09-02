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

# Storage
variable "force_destroy" {
  type        = bool
  default     = false
  description = "When deleting a bucket, this boolean option will delete all contained objects."
}

variable "storage_class" {
  type        = string
  default     = "MULTI_REGIONAL"
  description = "The Storage Class of the new bucket. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE."
}

variable "kms_key_name" {
  type        = string
  default     = ""
  description = "A KMS key that will be used to encrypt objects inserted into this bucket"
}

variable "encryption" {
  type        = bool
  default     = false
  description = "Is the Bucket encrypted?"
}

variable "location" {
  type        = string
  default     = "US"
  description = "Bucket Location/Region"
}

# lifecycle_rule condition block
variable "age" {
  type        = number
  default     = 10
  description = "Minimum age of an object in days to satisfy this condition."
}

variable "with_state" {
  default     = "ANY"
  type        = string
  description = "Relevant only for versioned objects. Supported options: LIVE, ARCHIVED, ANY. Match to live and/or archived objects. Unversioned buckets have only live objects."
}

variable "matches_storage_class" {
  type        = list(string)
  default     = []
  description = "Storage Class of objects. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD, DURABLE_REDUCED_AVAILABILITY."
}

variable "num_newer_versions" {
  type        = number
  default     = 10
  description = "Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition."
}

# lifecycle_rule action block
variable "action_type" {
  type        = string
  default     = "SetStorageClass"
  description = "The type of the action of this Lifecycle Rule. Supported values include: Delete and SetStorageClass."
}

variable "action_storage_class" {
  type        = string
  default     = "MULTI_REGIONAL"
  description = "The target Storage Class of objects affected by this Lifecycle Rule. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE."
}

# versioning block
variable "versioning_enabled" {
  type        = bool
  default     = true
  description = "While set to true, versioning is fully enabled for this bucket."
}
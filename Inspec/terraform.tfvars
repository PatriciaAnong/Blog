# Compute
machine_type = "n1-standard-1"

zone= "us-east1-b"

image = "ubuntu-1804-lts"

network = "default"

http_source_ips = [ "127.0.0.0/32" ]

https_source_ips = [ "127.0.0.0/32" ]

scopes = [ "compute-rw", "storage-rw" ]
# Shared
namespace = "inspec"

environment = "test"

name = "panong"

enabled = true

# Storage
location = "US"

project = "inspecplaygroundgcp"

force_destroy = true

storage_class = "MULTI_REGIONAL"

kms_key_name = ""

encryption = false

# lifecycle_rule condition block
age = 10

with_state = "ANY"

matches_storage_class = [ "MULTI_REGIONAL", "DURABLE_REDUCED_AVAILABILITY" ]

num_newer_versions = 10

# lifecycle_rule action block
action_type = "SetStorageClass"

action_storage_class = "MULTI_REGIONAL"

# versioning block
versioning_enabled = true
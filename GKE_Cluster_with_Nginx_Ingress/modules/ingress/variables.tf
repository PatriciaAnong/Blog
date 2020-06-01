variable project {
  description = "The project ID to host the cluster in"
  type        = string
}

variable region {
  description = "The location (region or zone) to host the cluster in"
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

variable tags {
  description = "Tags to be applied to the deployed resources"
  type        = map(string)
}
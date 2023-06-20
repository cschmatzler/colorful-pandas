variable "cluster_name" {
  description = "The cluster's name"
  type        = string
}

variable "base_domain" {
  description = "The base domain of the cluster, not including any subdomains"
  type        = string
}

variable "control_plane_nodepool" {
  description = "The nodes to use as control plane"
  type = object({
    count    = optional(number, 3)
    type     = string
    location = string
    image_id = string
  })
}

variable "control_plane_config" {
  description = "The Talos control-plane configuration"
  type        = string
  sensitive   = true
}

variable "worker_nodepools" {
  description = "The nodepools to use as workers"
  type = list(object({
    name     = string
    count    = optional(number, 3)
    type     = string
    location = string
    image_id = string
  }))
}

variable "worker_config" {
  description = "The Talos worker configuration"
  type        = string
  sensitive   = true
}

variable "node_type" {
  description = "The Hetzner Cloud node type"
  type        = string
  default     = "cax11"
}

variable "node_location" {
  description = "The Hetzner Cloud node location"
  type        = string
  default     = "fsn1"
}

variable "placement_group_id" {
  description = "The Hetzner Cloud placement group ID"
  type        = number
  nullable    = true
}

variable "network_id" {
  description = "The Hetzner Cloud private network ID"
  type        = number
}

variable "subnet_id" {
  description = "The Hetzner Cloud private subnetwork ID"
  type        = string
}

variable "rdns_domain" {
  description = "The base domain to use for rDNS"
  type        = string
}

variable "image_id" {
  description = "The Hetzner Cloud snapshot image ID"
  type        = string
}

variable "user_data" {
  description = "The cloud-init user data to use for the node"
  type        = string
}

variable "labels" {
  description = "The labels to add to the server"
  type        = map(any)
  nullable    = true
}

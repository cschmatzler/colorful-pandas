variable "hcloud_token" {
  description = "The Hetzner Cloud API Token"
  type        = string
  sensitive   = true
}

variable "cloudflare_token" {
  description = "The Cloudflare API Token"
  type        = string
  sensitive   = true
}


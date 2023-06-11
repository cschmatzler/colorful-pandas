variable "terraform_cloud_token" {
  description = "Terraform Cloud API Token"
  type        = string
  sensitive   = true
}

variable "github_oauth_token" {
  description = "GitHub OAuth Token"
  type        = string
  sensitive   = true
}

variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  type        = string
  sensitive   = true
}

variable "cloudflare_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "neon_token" {
  description = "Neon API Token"
  type        = string
  sensitive   = true
}

variable "sops_age_key" {
  description = "SOPS age key"
  type        = string
  sensitive   = true
}

variable "sops_age_recipients" {
  description = "SOPS age recipients"
  type        = string
  sensitive   = true
}


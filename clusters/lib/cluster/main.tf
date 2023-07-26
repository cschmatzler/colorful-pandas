terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.41.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.11.0"
    }
  }
}

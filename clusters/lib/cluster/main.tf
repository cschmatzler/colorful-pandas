terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.60.0"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.40.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.8.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.4.0"
    }
  }
}

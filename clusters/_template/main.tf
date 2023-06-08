terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.39.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.6.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
  }

  backend "s3" {
    endpoint = "https://s3.eu-central-2.wasabisys.com"
    region   = "eu-central-2"
    bucket   = "colorful-pandas-tfstate"
    # TODO: Add key
    key              = "cluster-{NAME}.tfstate"
    force_path_style = true
    # Required since Wasabi's STS system is only running in their `us-east-1` region.
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

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

provider "hcloud" {
  token = var.hcloud_token
}

provider "cloudflare" {
  api_token = var.cloudflare_token
}

module "cluster" {
  source = "../../modules/cluster"
  # TODO: Add name
  cluster_name = "{NAME}"
  base_domain  = "colorful-pandas.com"
  control_plane_nodepool = {
    type     = "cax11"
    location = "fsn1"
    image_id = 113863656
  }
  control_plane_config = data.sops_file.control_plane_config.raw

  worker_nodepools = tolist([
    {
      name     = "worker-cax11"
      count    = 2
      type     = "cax11"
      location = "fsn1"
      image_id = 113863656
    }
  ])
  worker_config = data.sops_file.worker_config.raw
}

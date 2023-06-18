terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.39.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.8.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
  }

  cloud {
    organization = "Colorful-Pandas"

    workspaces {
      name = "cluster-prod"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "cloudflare" {
  api_token = var.cloudflare_token
}

module "cluster" {
  source       = "../lib/cluster"
  cluster_name = "prod"
  base_domain  = "colorful-pandas.com"

  control_plane_nodepool = {
    type     = "cax11"
    location = "fsn1"
    image_id = 114060350
  }
  control_plane_config = data.sops_file.control_plane_config.raw

  worker_nodepools = tolist([
    {
      name     = "worker-cax11"
      count    = 2
      type     = "cax11"
      location = "fsn1"
      image_id = 114060350
    }
  ])
  worker_config = data.sops_file.worker_config.raw
}

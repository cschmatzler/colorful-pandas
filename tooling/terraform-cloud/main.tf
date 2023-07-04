terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.46.0"
    }
  }

  backend "s3" {
    endpoint         = "https://s3.eu-central-2.wasabisys.com"
    region           = "eu-central-2"
    bucket           = "colorful-pandas-tfstate"
    key              = "terraform-cloud.tfstate"
    force_path_style = true
    # Required since Wasabi's STS system is only running in their `us-east-1` region.
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "tfe" {
  token = var.terraform_cloud_token
}

resource "tfe_organization" "colorful_pandas" {
  name                    = "Colorful-Pandas"
  email                   = "christoph@medium.place"
  cost_estimation_enabled = false
}

resource "tfe_project" "colorful_pandas" {
  organization = tfe_organization.colorful_pandas.name
  name         = "Colorful Pandas"
}

resource "tfe_oauth_client" "github" {
  organization     = tfe_organization.colorful_pandas.name
  service_provider = "github"
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_oauth_token
}




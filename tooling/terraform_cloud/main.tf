terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.45.0"
    }
  }

  backend "s3" {
    endpoint         = "https://s3.eu-central-2.wasabisys.com"
    region           = "eu-central-2"
    bucket           = "colorful-pandas-tfstate"
    key              = "terraform_cloud.tfstate"
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

resource "tfe_variable_set" "api_tokens" {
  organization = tfe_organization.colorful_pandas.name
  name         = "API Tokens"
}

resource "tfe_variable" "hcloud_token" {
  variable_set_id = tfe_variable_set.api_tokens.id
  category        = "terraform"
  key             = "hcloud_token"
  value           = var.hcloud_token
  sensitive       = true
}

resource "tfe_variable" "cloudflare_token" {
  variable_set_id = tfe_variable_set.api_tokens.id
  category        = "terraform"
  key             = "cloudflare_token"
  value           = var.cloudflare_token
  sensitive       = true
}

resource "tfe_variable_set" "sops" {
  organization = tfe_organization.colorful_pandas.name
  name         = "SOPS"
}

resource "tfe_variable" "sops_age_key" {
  variable_set_id = tfe_variable_set.sops.id
  category        = "env"
  key             = "SOPS_AGE_KEY"
  value           = var.sops_age_key
  sensitive       = true
}

resource "tfe_variable" "sops_age_recipients" {
  variable_set_id = tfe_variable_set.sops.id
  category        = "env"
  key             = "SOPS_AGE_RECIPIENTS"
  value           = var.sops_age_recipients
  sensitive       = true
}

resource "tfe_workspace" "cluster_prod" {
  organization       = tfe_organization.colorful_pandas.name
  project_id         = tfe_project.colorful_pandas.id
  name               = "cluster-prod"
  auto_apply         = true
  allow_destroy_plan = false
  working_directory  = "clusters/prod.colorful-pandas.com"
  vcs_repo {
    identifier     = "cschmatzler/colorful-pandas"
    branch         = "main"
    oauth_token_id = tfe_oauth_client.github.oauth_token_id
  }
}

resource "tfe_workspace_variable_set" "cluster_prod_api_tokens" {
  workspace_id    = tfe_workspace.cluster_prod.id
  variable_set_id = tfe_variable_set.api_tokens.id
}

resource "tfe_workspace_variable_set" "cluster_prod_sops" {
  workspace_id    = tfe_workspace.cluster_prod.id
  variable_set_id = tfe_variable_set.sops.id
}

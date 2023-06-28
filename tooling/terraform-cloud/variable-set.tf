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

resource "tfe_variable" "neon_token" {
  variable_set_id = tfe_variable_set.api_tokens.id
  category        = "terraform"
  key             = "neon_token"
  value           = var.neon_token
  sensitive       = true
}

resource "tfe_variable" "grafana_cloud_token" {
  variable_set_id = tfe_variable_set.api_tokens.id
  category        = "terraform"
  key             = "grafana_cloud_token"
  value           = var.grafana_cloud_token
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

resource "tfe_workspace" "cluster_prod" {
  organization       = tfe_organization.colorful_pandas.name
  project_id         = tfe_project.colorful_pandas.id
  name               = "cluster-prod"
  auto_apply         = true
  allow_destroy_plan = false
  terraform_version = "1.5.0"
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

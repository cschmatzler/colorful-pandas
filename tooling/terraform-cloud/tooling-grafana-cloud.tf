resource "tfe_workspace" "grafana_cloud" {
  organization       = tfe_organization.colorful_pandas.name
  project_id         = tfe_project.colorful_pandas.id
  name               = "tooling-grafana-cloud"
  auto_apply         = true
  allow_destroy_plan = false
  terraform_version  = "1.5.4"
  working_directory  = "tooling/grafana-cloud"
  vcs_repo {
    identifier     = "cschmatzler/colorful-pandas"
    branch         = "main"
    oauth_token_id = tfe_oauth_client.github.oauth_token_id
  }
}

resource "tfe_workspace_variable_set" "grafana_cloud_api_tokens" {
  workspace_id    = tfe_workspace.grafana_cloud.id
  variable_set_id = tfe_variable_set.api_tokens.id
}

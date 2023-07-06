terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "2.0.0"
    }
  }

  cloud {
    organization = "Colorful-Pandas"

    workspaces {
      name = "tooling-grafana-cloud"
    }
  }
}

provider "grafana" {
  url = "https://pandaden.grafana.net/"
  auth = var.grafana_cloud_token
}

resource "grafana_dashboard" "kubelet" {
  config_json = file("dashboards/kubelet.json")
}

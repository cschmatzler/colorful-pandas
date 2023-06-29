terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "1.42.0"
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
  cloud_api_key = var.grafana_cloud_token
}

resource "grafana_dashboard" "kubelet" {
  config_json = file("dashboards/kubelet.json")
}

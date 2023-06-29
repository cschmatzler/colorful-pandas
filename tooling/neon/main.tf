terraform {
  required_providers {
    neon = {
      source  = "terraform-community-providers/neon"
      version = "0.1.2"
    }
  }

  cloud {
    organization = "Colorful-Pandas"

    workspaces {
      name = "tooling-neon"
    }
  }
}

provider "neon" {
  token = var.neon_token
}

resource "neon_project" "colorful_pandas" {
  name      = "Colorful Pandas"
  region_id = "aws-eu-central-1"
}

resource "neon_role" "colorful_pandas" {
  name       = "colorful_pandas"
  project_id = neon_project.colorful_pandas.id
  branch_id  = neon_project.colorful_pandas.branch.id
}

resource "neon_database" "colorful_pandas" {
  name       = "colorful_pandas"
  project_id = neon_project.colorful_pandas.id
  branch_id  = neon_project.colorful_pandas.branch.id
  owner_name = neon_role.colorful_pandas.name
}

# List all commands
default:
  just --list

# Setup development environment
setup-dev:
  cd colorful-pandas && \
  mix local.rebar --if-missing && \
  mix local.hex --if-missing && \
  mix deps.get && \
  mix deps.compile

# Format all the things
fmt:
  cd colorful-pandas && mix format
  terraform fmt -recursive .

# Run the development server
run-dev-server:
  cd colorful-pandas && \
  DB_URL="op://Colorful Pandas/Neon main/url" \
  GITHUB_CLIENT_ID="op://Colorful Pandas - Local/GitHub OAuth/username" \
  GITHUB_CLIENT_SECRET="op://Colorful Pandas - Local/GitHub OAuth/credential" \
  GOOGLE_CLIENT_ID="op://Colorful Pandas - Local/Google OAuth/username" \
  GOOGLE_CLIENT_SECRET="op://Colorful Pandas - Local/Google OAuth/credential" \
  op run -- \
    fish -c 'mix ecto.migrate && iex -S mix phx.server'

run-dev-server-with-telemetry user:
  cd colorful-pandas && \
  ENABLE_TELEMETRY="true" \
  DB_URL="op://Colorful Pandas/Neon main/url" \
  HONEYCOMB_API_KEY="op://Colorful Pandas/honeycomb-local/credential" \
  HONEYCOMB_DATASET="colorful-pandas-{{ user }}" \
  GITHUB_CLIENT_ID="op://Colorful Pandas/GitHub OAuth/username" \
  GITHUB_CLIENT_SECRET="op://Colorful Pandas/GitHub OAuth/credential" \
  op run -- \
    sh -c 'mix ecto.migrate && mix phx.server'


# Build an image of the specified Talos version
build-talos version:
  HCLOUD_TOKEN="op://Colorful Pandas/Hetzner Cloud/credential" \
  op run -- \
    packer build -var talos_version={{ version }} modules/talos/

# Encrypts a cluster's sensitive files
encrypt-cluster-config cluster_name:
  SOPS_AGE_KEY="op://Colorful Pandas/SOPS/SOPS_AGE_KEY" \
  SOPS_AGE_RECIPIENTS="op://Colorful Pandas/SOPS/SOPS_AGE_RECIPIENTS" \
  op run -- sh -c \
    "sops -e clusters/{{ cluster_name }}/talos/secrets.yaml > clusters/{{ cluster_name }}/talos/secrets.sops.yaml && \
    sops -e clusters/{{ cluster_name }}/talos/talosconfig > clusters/{{ cluster_name }}/talos/talosconfig.sops && \
    sops -e clusters/{{ cluster_name }}/talos/controlplane.yaml > clusters/{{ cluster_name }}/talos/controlplane.sops.yaml && \
    sops -e clusters/{{ cluster_name }}/talos/worker.yaml > clusters/{{ cluster_name }}/talos/worker.sops.yaml"

# Apply the configuration for external tooling
apply-terraform-cloud:
  AWS_ACCESS_KEY_ID="op://Colorful Pandas/Terraform S3/username" \
  AWS_SECRET_ACCESS_KEY="op://Colorful Pandas/Terraform S3/credential" \
  op run -- \
    terraform -chdir=tooling/terraform-cloud/ init -upgrade

  AWS_ACCESS_KEY_ID="op://Colorful Pandas/Terraform S3/username" \
  AWS_SECRET_ACCESS_KEY="op://Colorful Pandas/Terraform S3/credential" \
  TF_VAR_terraform_cloud_token="op://Colorful Pandas/Terraform Cloud/credential" \
  TF_VAR_github_oauth_token="op://Colorful Pandas/GitHub Terraform Cloud PAT/credential" \
  TF_VAR_sops_age_key="op://Colorful Pandas/SOPS/SOPS_AGE_KEY" \
  TF_VAR_sops_age_recipients="op://Colorful Pandas/SOPS/SOPS_AGE_RECIPIENTS" \
  TF_VAR_hcloud_token="op://Colorful Pandas/Hetzner Cloud/credential" \
  TF_VAR_cloudflare_token="op://Colorful Pandas/Cloudflare/credential" \
  TF_VAR_neon_token="op://Colorful Pandas/Neon/credential" \
  TF_VAR_grafana_cloud_token="op://Colorful Pandas/Grafana Cloud/credential" \
  op run -- \
    terraform -chdir=tooling/terraform-cloud/ apply

# List all commands
default:
  just --list

setup-dev:
  cd service && \
  mix local.rebar --if-missing && \
  mix local.hex --if-missing && \
  mix deps.get && \
  mix deps.compile

run-dev-server:
  cd service && \
  mix phx.server

# Build an image of the specified Talos version
build-talos version:
  HCLOUD_TOKEN="op://Colorful Pandas/Hetzner Cloud/credential" \
  op run -- \
    packer build -var talos_version={{ version }} modules/talos/

# Apply the configuration for external tooling
apply-terraform-cloud:
  AWS_ACCESS_KEY_ID="op://Colorful Pandas/Terraform S3/username" \
  AWS_SECRET_ACCESS_KEY="op://Colorful Pandas/Terraform S3/credential" \
  TF_VAR_terraform_cloud_token="op://Colorful Pandas/Terraform Cloud/credential" \
  TF_VAR_github_oauth_token="op://Colorful Pandas/GitHub OAuth/credential" \
  TF_VAR_sops_age_key="op://Colorful Pandas/SOPS/SOPS_AGE_KEY" \
  TF_VAR_sops_age_recipients="op://Colorful Pandas/SOPS/SOPS_AGE_RECIPIENTS" \
  TF_VAR_hcloud_token="op://Colorful Pandas/Hetzner Cloud/credential" \
  TF_VAR_cloudflare_token="op://Colorful Pandas/Cloudflare/credential" \
  op run -- \
    terraform -chdir=tooling/terraform_cloud/ apply

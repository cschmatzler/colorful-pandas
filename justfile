# List all commands
default:
  just --list

# Build an image of the specified Talos version
build-talos version:
  HCLOUD_TOKEN="op://Colorful Pandas/Hetzner Cloud/credential" \
  op run -- \
    packer build -var talos_version={{ version }} clusters/_modules/infra/talos

# Apply the infrastructure configuration of the specified cluster
apply-cluster cluster:
  SOPS_AGE_KEY="op://Colorful Pandas/SOPS/SOPS_AGE_KEY" \
  SOPS_AGE_RECIPIENTS="op://Colorful Pandas/SOPS/SOPS_AGE_RECIPIENTS" \
  TF_VAR_hcloud_token="op://Colorful Pandas/Hetzner Cloud/credential" \
  TF_VAR_cloudflare_token="op://Colorful Pandas/Cloudflare/credential" \
  op run -- \
    terraform -chdir=clusters/{{ cluster }}/ apply

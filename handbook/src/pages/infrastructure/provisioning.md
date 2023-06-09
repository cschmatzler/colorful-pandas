---
title: Provisioning
pageTitle: Provisioning - Infrastructure - Colorful Pandas 
description: How we provision infrastructure.
---

Use Terraform to provision and configure infrastructure and tools where possible. Terraform runs in Terraform Cloud, 
which is itself provisioned through Terraform. Terraform Cloud also manages all state, except for the its own 
configuration.

## Manually provisioned resources

### Terraform Cloud state

Terraform stores the state for Terraform Cloud's provisioning inside a manually managed bucket in Wasabi. Terraform 
can't provision this, as it would need to store that state somewhere, which creates a chicken and egg problem. As
such, we manage the `colorful-pandas-tfstate` bucket in the `eu-central-2` region and its corresponding policy and user
manually. We store the user's access key and secret inside 1Password at the `op://Colorful Pandas/Terraform S3`
path.

### Terraform Cloud

Apply changes to Terraform Cloud manually. Since this has the potential to break all other provisioning, it's not set
to apply automatically. You can apply the configuration by running `just apply-terraform-cloud`.

### Packer images

Hetzner Cloud's Packer plugin doesn't store images in an HashiCorp Cloud Platform compatible format, preventing the use
of that offering for running Packer and storing its images. This is why building Packer images is also a manual
process. You can build a new Talos image by running `just build-talos {version}` where the version needs to be 
`v`-prefixed (for example `v1.4.5`).

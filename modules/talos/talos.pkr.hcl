packer {
  required_plugins {
    hcloud = {
      version = "1.0.5"
      source  = "github.com/hashicorp/hcloud"
    }
  }
}

variable "hcloud_token" {
  type      = string
  sensitive = true
  # Reuse the token from Terraform
  default   = "${env("TF_VAR_hcloud_token")}"
}

variable "talos_version" {
  type    = string
}

locals {
  image = "https://github.com/siderolabs/talos/releases/download/${var.talos_version}/hcloud-arm64.raw.xz"
}

source "hcloud" "talos" {
  token        = var.hcloud_token
  location     = "fsn1"
  server_type  = "cax11"
  image        = "debian-11"
  rescue       = "linux64"
  ssh_username = "root"

  snapshot_name = "talos ${var.talos_version}"
  snapshot_labels = {
    os      = "talos",
    version = "${var.talos_version}"
  }
}

build {
  sources = ["source.hcloud.talos"]

  provisioner "shell" {
    inline = [
      "apt-get install -y wget",
      "wget -O /tmp/talos.raw.xz ${local.image}",
      "xz -d -c /tmp/talos.raw.xz | dd of=/dev/sda && sync",
      "partprobe /dev/sda",
      "sfdisk --delete /dev/sda 5",
      "sfdisk --delete /dev/sda 6",
      "gdisk -l /dev/sda"
    ]
  }
}

data "sops_file" "control_plane_config" {
  source_file = "talos/controlplane.yaml.sops"
  input_type  = "yaml"
}

data "sops_file" "worker_config" {
  source_file = "talos/worker.yaml.sops"
  input_type  = "yaml"
}

data "sops_file" "control_plane_config" {
  source_file = "talos/controlplane.sops.yaml"
  input_type  = "yaml"
}

data "sops_file" "worker_config" {
  source_file = "talos/worker.sops.yaml"
  input_type  = "yaml"
}

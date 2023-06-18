resource "hcloud_placement_group" "control_plane" {
  name = "${local.cluster_domain}-control-plane"
  type = "spread"
}

module "control_plane" {
  source = "../node"
  count  = var.control_plane_nodepool.count

  node_type          = var.control_plane_nodepool.type
  node_location      = var.control_plane_nodepool.location
  placement_group_id = hcloud_placement_group.control_plane.id
  image_id           = var.control_plane_nodepool.image_id

  user_data = var.control_plane_config

  network_id  = hcloud_network.cluster.id
  subnet_id   = hcloud_network_subnet.cluster.id
  rdns_domain = local.cluster_domain

  labels = {
    "cluster"     = local.cluster_domain,
    "provisioner" = "terraform",
    "role"        = "control-plane"
  }
}

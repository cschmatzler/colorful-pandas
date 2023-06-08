resource "hcloud_placement_group" "worker" {
  count = ceil(local.worker_count / 10)

  name = "${local.cluster_domain}-worker-${count.index + 1}"
  type = "spread"
}

module "worker" {
  source   = "../node"
  for_each = local.worker_nodes

  node_type          = each.value.type
  node_location      = each.value.location
  placement_group_id = element(hcloud_placement_group.worker.*.id, ceil(each.value.index / 10))
  image_id           = each.value.image_id

  user_data = var.worker_config

  network_id  = hcloud_network.cluster.id
  subnet_id   = hcloud_network_subnet.cluster.id
  rdns_domain = local.cluster_domain

  labels = {
    "provisioner" = "terraform",
    "role"        = "worker"
  }
}

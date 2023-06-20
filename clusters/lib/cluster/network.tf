resource "hcloud_network" "cluster" {
  name     = local.cluster_domain
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "cluster" {
  network_id   = hcloud_network.cluster.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = cidrsubnet(hcloud_network.cluster.ip_range, 8, 1)
}

resource "hcloud_load_balancer" "control_plane" {
  name               = local.cluster_domain
  load_balancer_type = "lb11"
  location           = "fsn1"
}

resource "hcloud_load_balancer_network" "control_plane" {
  load_balancer_id = hcloud_load_balancer.control_plane.id
  network_id       = hcloud_network.cluster.id
}

resource "hcloud_load_balancer_service" "kubernetes" {
  load_balancer_id = hcloud_load_balancer.control_plane.id
  protocol         = "tcp"
  listen_port      = 6443
  destination_port = 6443
}

resource "hcloud_load_balancer_service" "talos" {
  load_balancer_id = hcloud_load_balancer.control_plane.id
  protocol         = "tcp"
  listen_port      = 50000
  destination_port = 50000
}

resource "hcloud_load_balancer_target" "control_plane" {
  count = var.control_plane_nodepool.count

  type             = "server"
  load_balancer_id = hcloud_load_balancer.control_plane.id
  server_id        = module.control_plane[count.index].node_id
}

resource "hcloud_firewall" "firewall" {
  name = local.cluster_domain

  rule {
    description = "Control Plane"
    direction   = "in"
    protocol    = "tcp"
    port        = 6443
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    description = "Talos API"
    direction   = "in"
    protocol    = "tcp"
    port        = 50000
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    description = "Outgoing traffic/TCP"
    direction   = "out"
    protocol    = "tcp"
    port        = "any"
    destination_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    description = "Outgoing traffic/UDP"
    direction   = "out"
    protocol    = "udp"
    port        = "any"
    destination_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_firewall_attachment" "cluster_nodes" {
  firewall_id = hcloud_firewall.firewall.id
  server_ids  = concat(module.control_plane.*.node_id, flatten([for nodepool in module.worker : nodepool.*.node_id]))
}

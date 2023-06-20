resource "cloudflare_record" "control_plane_v4" {
  zone_id = data.cloudflare_zone.domain.id
  type    = "A"
  name    = "cluster.${var.cluster_name}"
  ttl     = 3600
  value   = hcloud_load_balancer.control_plane.ipv4
}

resource "cloudflare_record" "control_plane_v6" {
  zone_id = data.cloudflare_zone.domain.id
  type    = "AAAA"
  name    = "cluster.${var.cluster_name}"
  value   = hcloud_load_balancer.control_plane.ipv6
  ttl     = 3600
}

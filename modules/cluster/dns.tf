resource "cloudflare_record" "control_plane_v4" {
  zone_id = data.cloudflare_zone.domain.id
  type    = "A"
  ttl     = 3600
  name    = "cluster.${var.cluster_name}"
  value   = hcloud_load_balancer.control_plane.ipv4
}

resource "cloudflare_record" "control_plane_v6" {
  zone_id = data.cloudflare_zone.domain.id
  type    = "AAAA"
  ttl     = 3600
  name    = "cluster.${var.cluster_name}"
  value   = hcloud_load_balancer.control_plane.ipv6
}

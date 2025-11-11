
resource "google_dns_record_set" "prometheus" {
  name         = "prometheus.quobyte-demo.com."
  managed_zone = "quobyte-demo-shard-1"
  type         = "A"
  ttl          = 300
  rrdatas = google_compute_instance.trending.*.network_interface.0.access_config.0.nat_ip
}

resource "google_dns_record_set" "prometheus2" {
  name         = "trending0.quobyte-demo.com."
  managed_zone = "quobyte-demo-shard-1"
  type         = "A"
  ttl          = 300
  rrdatas = google_compute_instance.trending.*.network_interface.0.access_config.0.nat_ip
}


resource "google_dns_record_set" "grafana" {
  name         = "grafana.quobyte-demo.com."
  managed_zone = "quobyte-demo-shard-1"
  type         = "A"
  ttl          = 300
  rrdatas = google_compute_instance.trending.*.network_interface.0.access_config.0.nat_ip
}




resource "google_dns_record_set" "root" {
  name         = "${var.dns_domain}"
  managed_zone = var.dns_zone
  type         = "A"
  ttl          = 300
  rrdatas = [google_compute_instance.core.0.network_interface.0.access_config.0.nat_ip]
}

resource "google_dns_record_set" "registry" {
  count        = var.number_coreserver
  name         = "registry${count.index}.${var.dns_domain}"
  managed_zone = var.dns_zone
  type         = "A"
  ttl          = 300
  rrdatas = [google_compute_instance.core[count.index].network_interface.1.network_ip]
}

resource "google_dns_record_set" "registry-frontend" {
  count        = var.number_coreserver
  name         = "registry-frontend${count.index}.${var.dns_domain}"
  managed_zone = var.dns_zone
  type         = "A"
  ttl          = 300
  rrdatas = [google_compute_instance.core[count.index].network_interface.2.network_ip]
}

resource "google_dns_record_set" "console" {
  name         = "console.${var.dns_domain}"
  managed_zone = var.dns_zone
  type         = "A"
  ttl          = 300
  rrdatas = google_compute_instance.core.*.network_interface.0.access_config.0.nat_ip
}


resource "google_dns_record_set" "api" {
  name         = "api.${var.dns_domain}"
  managed_zone = var.dns_zone
  type         = "A"
  ttl          = 300
  rrdatas = google_compute_instance.core.*.network_interface.0.access_config.0.nat_ip
}

resource "google_dns_record_set" "s3base" {
  name         = "s3.${var.dns_domain}"
  managed_zone = var.dns_zone
  type         = "A"
  ttl          = 300
  rrdatas = [google_compute_instance.core.0.network_interface.0.access_config.0.nat_ip]
}

resource "google_dns_record_set" "s3buckets" {
  name         = "*.s3.${var.dns_domain}"
  managed_zone = var.dns_zone
  type         = "A"
  ttl          = 300
  rrdatas = [google_compute_instance.core.0.network_interface.0.access_config.0.nat_ip]
}

resource "google_dns_record_set" "registry-srv" {
  name = "_quobyte._tcp.quobyte-demo.com."
  type = "SRV"
  ttl  = 60
  managed_zone = var.dns_zone
  rrdatas = [
    "0 0 7861 ${google_dns_record_set.registry[0].name}",
    "0 0 7861 ${google_dns_record_set.registry[1].name}",
    "0 0 7861 ${google_dns_record_set.registry[2].name}"
  ]
}

resource "google_dns_record_set" "registry-frontend-srv" {
  name = "_quobyte._tcp.frontend.quobyte-demo.com."
  type = "SRV"
  ttl  = 60
  managed_zone = var.dns_zone
  rrdatas = [
    "0 0 7861 ${google_dns_record_set.registry-frontend[0].name}",
    "0 0 7861 ${google_dns_record_set.registry-frontend[1].name}",
    "0 0 7861 ${google_dns_record_set.registry-frontend[2].name}"
  ]
}

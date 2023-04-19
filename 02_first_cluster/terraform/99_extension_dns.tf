
resource "google_dns_record_set" "root" {
  name         = google_dns_managed_zone.quobyte.dns_name
  managed_zone = google_dns_managed_zone.quobyte.name
  type         = "A"
  ttl          = 300
  rrdatas = [google_compute_instance.core.0.network_interface.0.access_config.0.nat_ip]
}

resource "google_dns_record_set" "registry" {
  count        = var.number_coreserver
  name         = "registry${count.index}.${google_dns_managed_zone.quobyte.dns_name}"
  managed_zone = google_dns_managed_zone.quobyte.name
  type         = "A"
  ttl          = 300
  rrdatas = [google_compute_instance.core[count.index].network_interface.0.network_ip]
}

resource "google_dns_record_set" "console" {
  name         = "console.${google_dns_managed_zone.quobyte.dns_name}"
  managed_zone = google_dns_managed_zone.quobyte.name
  type         = "A"
  ttl          = 300
  rrdatas = google_compute_instance.core.*.network_interface.0.access_config.0.nat_ip
}


resource "google_dns_record_set" "api" {
  name         = "api.${google_dns_managed_zone.quobyte.dns_name}"
  managed_zone = google_dns_managed_zone.quobyte.name
  type         = "A"
  ttl          = 300
  rrdatas = google_compute_instance.core.*.network_interface.0.access_config.0.nat_ip
}

resource "google_dns_record_set" "s3base" {
  name         = "s3.${google_dns_managed_zone.quobyte.dns_name}"
  managed_zone = google_dns_managed_zone.quobyte.name
  type         = "A"
  ttl          = 300
  rrdatas = [google_compute_instance.core.0.network_interface.0.access_config.0.nat_ip]
}

resource "google_dns_record_set" "s3buckets" {
  name         = "*.s3.${google_dns_managed_zone.quobyte.dns_name}"
  managed_zone = google_dns_managed_zone.quobyte.name
  type         = "A"
  ttl          = 300
  rrdatas = [google_compute_instance.core.0.network_interface.0.access_config.0.nat_ip]
}

resource "google_dns_record_set" "soa" {
  name         = "quobyte-demo.com."
  managed_zone = google_dns_managed_zone.quobyte.name
  type         = "SOA"
  ttl          = 21600  
  rrdatas = ["ns-cloud-d1.googledomains.com. cloud-dns-hostmaster.google.com. 1 21600 3600 259200 300"]
}

resource "google_dns_record_set" "ns" {
  name         = "quobyte-demo.com."
  managed_zone = google_dns_managed_zone.quobyte.name
  type         = "NS"
  ttl          = 21600  
  rrdatas = [
    "ns-cloud-d1.googledomains.com.",
    "ns-cloud-d2.googledomains.com.",
    "ns-cloud-d3.googledomains.com.",
    "ns-cloud-d4.googledomains.com."
  ]
}

resource "google_dns_managed_zone" "quobyte" {
  description = "Presales Demo Domain"
  name     = "dynamic-quobyte-demo-new"
  dns_name = "quobyte-demo.com."
  force_destroy = true
}

resource "google_dns_record_set" "registry-srv" {
  name = "_quobyte._tcp.quobyte-demo.com"
  type = "SRV"
  ttl  = 60
  managed_zone = google_dns_managed_zone.quobyte.name
  rrdatas = [
    "0 0 7861 ${google_dns_record_set.registry[0].name}",
    "0 0 7861 ${google_dns_record_set.registry[1].name}",
    "0 0 7861 ${google_dns_record_set.registry[2].name}"
  ]
}

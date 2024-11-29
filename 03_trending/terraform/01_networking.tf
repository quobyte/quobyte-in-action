resource "google_compute_firewall" "monitoring-rules" {
  project     = var.gcloud_project 
  name        = "quobyte-monitoring-firewall"
  network     = "default"
  description = "Open TCP ports used by Prometheus and Grafana"

  allow {
    protocol  = "tcp"
    ports     = ["3000", "9090"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "metrics-rules-backend" {
  project     = var.gcloud_project 
  name        = "quobyte-metrics-firewall-backend"
  network     = "quobyte-demo-backend" 
  description = "Open TCP ports used by Prometheus"

  allow {
    protocol  = "tcp"
    ports     = ["7870-7876", "55000-55100"]
  }

  source_ranges = ["10.138.0.0/20", "192.168.1.0/24", "172.16.0.0/16"]
}

resource "google_compute_firewall" "metrics-rules-frontend" {
  project     = var.gcloud_project 
  name        = "quobyte-metrics-firewall-frontend"
  network     = "quobyte-demo-frontend" 
  description = "Open TCP ports used by Prometheus"

  allow {
    protocol  = "tcp"
    ports     = ["7870-7876", "55000-55100"]
  }

  source_ranges = ["10.138.0.0/20", "192.168.1.0/24", "172.16.0.0/16"]
}


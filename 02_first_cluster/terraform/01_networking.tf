// Create dedicated networks (Networks must be distinct for NICs attached to a VM)
resource "google_compute_network" "quobyte_backend" {
  project     = var.gcloud_project 
  name        = "quobyte-demo-backend"
  auto_create_subnetworks = false
}

resource "google_compute_network" "quobyte_frontend" {
  project     = var.gcloud_project 
  name        = "quobyte-demo-frontend"
  auto_create_subnetworks = false
}

// create dedicated frontend/ backend subnets

resource "google_compute_subnetwork" "frontend-subnet" {
  name          = "frontend-subnet"
  ip_cidr_range = "172.16.0.0/16"
  network     = google_compute_network.quobyte_frontend.name
}

resource "google_compute_subnetwork" "backend-subnet" {
  name          = "backend-subnet"
  ip_cidr_range = "192.168.1.0/24"
  network     = google_compute_network.quobyte_backend.name
}

resource "google_compute_firewall" "frontend-rules" {
  project     = var.gcloud_project 
  name        = "quobyte-frontend-firewall"
  network     = google_compute_network.quobyte_frontend.name
  description = "Open TCP ports used by Quoybyte services"

  allow {
    protocol  = "tcp"
    ports     = ["7860-7866", "7870-7874", "55000-55010"]
  }

  allow {
    protocol  = "udp"
    ports     = ["7860-7866", "7870-7874"]
  }

  source_ranges = [google_compute_subnetwork.frontend-subnet.ip_cidr_range, google_compute_subnetwork.backend-subnet.ip_cidr_range, "10.0.0.0/8"]
}
resource "google_compute_firewall" "backend-rules" {
  project     = var.gcloud_project 
  name        = "quobyte-backend-firewall"
  network     = google_compute_network.quobyte_backend.name
  description = "Open TCP ports used by Quoybyte services"

  allow {
    protocol  = "tcp"
    ports     = ["7860-7866", "7870-7876"]
  }

  allow {
    protocol  = "udp"
    ports     = ["7860-7866", "7870-7876"]
  }


  source_ranges = [google_compute_subnetwork.backend-subnet.ip_cidr_range, google_compute_subnetwork.frontend-subnet.ip_cidr_range]
}
resource "google_compute_firewall" "webconsole-rules" {
  project     = var.gcloud_project 
  name        = "quobyte-webconsole-firewall"
  network     = "default"
  description = "Open TCP ports used by Quoybyte webconsole"

  allow {
    protocol  = "tcp"
    ports     = ["8080", "80", "7860-7866", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

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

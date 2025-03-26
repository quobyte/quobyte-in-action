// Configure Google Cloud provider
provider "google" {
 credentials = file(var.gcloud_credentials)
 project     = var.gcloud_project 
 region      = var.cluster_region 
}

// List available zones in chosen region
data "google_compute_zones" "available" {
  region = var.cluster_region
}

locals {
  //cluster_zone = data.google_compute_zones.available.names[0]
  cluster_zone = "europe-west4-b"
}

// core cluster
resource "google_compute_instance" "core" {
 count        = var.number_coreserver
 name         = "${var.cluster_name}-coreserver${count.index}"
 machine_type = var.flavor_coreserver 
 zone         = local.cluster_zone
 allow_stopping_for_update = true
 scheduling { 
   provisioning_model = "SPOT"
   preemptible = true
   automatic_restart = false
 }
 lifecycle {
    ignore_changes = [attached_disk]
 }

 boot_disk {
   initialize_params {
     image = var.image_coreserver 
   }
 }

// one metadata device 
 scratch_disk {
  interface = "NVME"
 }

// one fast data devices 
 scratch_disk {
  interface = "NVME"
 }

 depends_on = [
  google_compute_subnetwork.frontend-subnet,
  google_compute_subnetwork.backend-subnet
 ]

 metadata = {
   "ssh-keys" = <<EOT
   deploy:${file(var.public_ssh_key)}
EOT
 }

 // install necessary software
 metadata_startup_script = (var.image_coreserver == "centos-cloud/centos-7" || var.image_coreserver == "centos-cloud/centos-8" || var.image_coreserver == "rhel-cloud/rhel-8" || var.image_coreserver == "rhel-cloud/rhel-7" ? local.startupscript_core_rpmflavor : local.startupscript_core_debflavor)
 
 network_interface {
   network = "default"
   access_config {
     // Include this section to give the VM an external ip address
   }
 }
 network_interface {
   subnetwork = "backend-subnet"
 }
 network_interface {
   subnetwork = "frontend-subnet"
 }
}

// dataserver scaleout
resource "google_compute_instance" "dataserver" {
 count        = var.number_dataserver
 name         = "${var.cluster_name}-dataserver${count.index}"
 machine_type = var.flavor_dataserver 
 zone  = local.cluster_zone
 allow_stopping_for_update = true
 scheduling { 
   provisioning_model = "SPOT"
   preemptible = true
   automatic_restart = false
 }
 lifecycle {
    ignore_changes = [attached_disk]
 }

 boot_disk {
   initialize_params {
     image = var.image_dataserver 
   }
 }

// fast nvme storage tier
 scratch_disk {
  interface = "NVME"
 }

 scratch_disk {
  interface = "NVME"
 }

 metadata = {
   "ssh-keys" = <<EOT
   deploy:${file(var.public_ssh_key)}
EOT
 }

 depends_on = [
  google_compute_subnetwork.frontend-subnet,
  google_compute_subnetwork.backend-subnet
 ]

 // install necessary software
 metadata_startup_script = (var.image_coreserver == "centos-cloud/centos-7" || var.image_coreserver == "centos-cloud/centos-8" || var.image_coreserver == "rhel-cloud/rhel-8" || var.image_coreserver == "rhel-cloud/rhel-7" ? var.startupscript_other_rpmflavor : var.startupscript_other_debflavor)

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
 network_interface {
   subnetwork = "backend-subnet"
 }
 network_interface {
   subnetwork = "frontend-subnet"
 }
}


// some stateless clients
resource "google_compute_instance" "client" {
 count        = var.number_clientserver
 name         = "${var.cluster_name}-client${count.index}"
 machine_type = var.flavor_clientserver
 zone         = local.cluster_zone
 allow_stopping_for_update = true
 scheduling { 
   provisioning_model = "SPOT"
   preemptible = true
   automatic_restart = false
 }

 boot_disk {
   initialize_params {
     image = var.image_clientserver 
   }
 }

 scratch_disk {
  interface = "NVME"
 }

 scratch_disk {
  interface = "NVME"
 }

 metadata = {
   "ssh-keys" = <<EOT
   deploy:${file(var.public_ssh_key)}
EOT
 }

// install needed software 
 metadata_startup_script = (var.image_coreserver == "centos-cloud/centos-7" || var.image_coreserver == "centos-cloud/centos-8" || var.image_coreserver == "rhel-cloud/rhel-8" || var.image_coreserver == "rhel-cloud/rhel-7" ? local.startupscript_core_rpmflavor : local.startupscript_core_debflavor)

 network_interface {
   network = "default"
   access_config {
     // Include this section to give the VM an external ip address
   }
 }
 network_interface {
   subnetwork = "frontend-subnet"
 }
 depends_on = [
  google_compute_subnetwork.frontend-subnet
 ]
}

// output section
output "bastion-ip" {
 value = google_compute_instance.core.0.network_interface.0.access_config.0.nat_ip
}
output "internal_core_ips" {
 value = google_compute_instance.core.*.network_interface.0.network_ip
}
output "internal_dataserver_ips" {
 value = google_compute_instance.dataserver.*.network_interface.0.network_ip
}

output "internal_client_ips" {
 value = google_compute_instance.client.*.network_interface.0.network_ip
}



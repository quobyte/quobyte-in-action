// Configure Google Cloud provider
provider "google" {
 credentials = file("~/accessfiles/CREDENTIALS_FILE.json")
 project     = var.gcloud_project 
 region      = var.cluster_region 
}

// core cluster
resource "google_compute_instance" "core" {
 count        = var.number_coreserver
 name         = "${var.cluster_name}-coreserver${count.index}"
 machine_type = var.flavor_coreserver 
 zone         = var.cluster_region
 allow_stopping_for_update = true
 lifecycle {
    ignore_changes = [attached_disk]
 }

 boot_disk {
   initialize_params {
     image = var.image_coreserver 
   }
 }

 attached_disk {
  source     = "projects/${var.gcloud_project}/zones/${var.cluster_region}/disks/${var.cluster_name}-coredatadisk-${count.index}"
 } 

 attached_disk {
  source     = "projects/${var.gcloud_project}/zones/${var.cluster_region}/disks/${var.cluster_name}-metadata-disk-${count.index}"
 } 

 metadata = {
   ssh-keys = "deploy:${file("~/.ssh/id_rsa.pub")}"
 }

 // install necessary software
 metadata_startup_script = "apt-get update; apt-get install -y wget ansible git python; ansible-galaxy collection install ansible.posix; git clone --branch deploy-3.0  --single-branch https://github.com/quobyte/ansible-deploy.git /home/deploy/ansible-deploy"
 
 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}

// dataserver scaleout
resource "google_compute_instance" "dataserver" {
 count        = var.number_dataserver
 name         = "${var.cluster_name}-dataserver${count.index}"
 machine_type = var.flavor_dataserver 
 zone         = var.cluster_region
 allow_stopping_for_update = true
 lifecycle {
    ignore_changes = [attached_disk]
 }

 boot_disk {
   initialize_params {
     image = var.image_dataserver 
   }
 }

 attached_disk {
  source     = "projects/${var.gcloud_project}/zones/${var.cluster_region}/disks/${var.cluster_name}-datadisk-${count.index}-a"
 } 

 attached_disk {
  source     = "projects/${var.gcloud_project}/zones/${var.cluster_region}/disks/${var.cluster_name}-datadisk-${count.index}-b"
 } 

 metadata = {
   ssh-keys = "deploy:${file("~/.ssh/id_rsa.pub")}"
 }

 // install necessary software
 metadata_startup_script = "apt-get update; apt-get install -y wget curl"

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}


// some clients
resource "google_compute_instance" "client" {
 count        = var.number_clientserver
 name         = "${var.cluster_name}-client${count.index}"
 machine_type = var.flavor_clientserver
 zone         = var.cluster_region
 allow_stopping_for_update = true

 boot_disk {
   initialize_params {
     image = var.image_clientserver 
   }
 }

 metadata = {
   ssh-keys = "deploy:${file("~/.ssh/id_rsa.pub")}"
 }

// install needed software 
 metadata_startup_script = "apt-get update; apt-get install -y wget"

 network_interface {
   network = "default"

 }
}

// create necessary disks
resource "google_compute_disk" "coreserver-data" {
   count = var.number_coreserver
   name  = "${var.cluster_name}-coredatadisk-${count.index}"
   size  = var.datadisk_size 
   type  = var.disk-type_dataserver-a 
   zone  = var.cluster_region
}

resource "google_compute_disk" "dataserver-data-a" {
   count = var.number_dataserver
   name  = "${var.cluster_name}-datadisk-${count.index}-a"
   size  = var.datadisk_hdd_size 
   type  = var.disk-type_dataserver-b 
   zone  = var.cluster_region
}

resource "google_compute_disk" "dataserver-data-b" {
   count = var.number_dataserver
   name  = "${var.cluster_name}-datadisk-${count.index}-b"
   size  = var.datadisk_size 
   type  = "pd-ssd"
   zone  = var.cluster_region
}

resource "google_compute_disk" "coreserver-metadata" {
  count = var.number_coreserver
  name  = "${var.cluster_name}-metadata-disk-${count.index}"
  size  = 50
  type  = "pd-ssd"
  zone  = var.cluster_region
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



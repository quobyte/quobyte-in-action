// Configure Google Cloud provider
provider "google" {
 credentials = file(var.gcloud_credentials)
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
  source     = "projects/${var.gcloud_project}/zones/${var.cluster_region}/disks/${var.cluster_name}-metadatadisk-${count.index}-a"
 } 

 attached_disk {
  source     = "projects/${var.gcloud_project}/zones/${var.cluster_region}/disks/${var.cluster_name}-coredatadisk-${count.index}-a"
 } 

 attached_disk {
  source     = "projects/${var.gcloud_project}/zones/${var.cluster_region}/disks/${var.cluster_name}-coredatadisk-${count.index}-b"
 } 

 attached_disk {
  source     = "projects/${var.gcloud_project}/zones/${var.cluster_region}/disks/${var.cluster_name}-coredatadisk-${count.index}-c"
 } 


 depends_on = [
  google_compute_disk.coreserver-metadata-a,
  google_compute_disk.coreserver-data-a,
  google_compute_disk.coreserver-data-b,
  google_compute_disk.coreserver-data-c
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
   subnetwork = "backendnetwork"
 }
 network_interface {
   subnetwork = "frontend"
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

 attached_disk {
  source     = "projects/${var.gcloud_project}/zones/${var.cluster_region}/disks/${var.cluster_name}-datadisk-${count.index}-c"
 } 


 metadata = {
   "ssh-keys" = <<EOT
   deploy:${file(var.public_ssh_key)}
EOT
 }

 depends_on = [
  google_compute_disk.dataserver-data-a,
  google_compute_disk.dataserver-data-b,
  google_compute_disk.dataserver-data-c
 ]

 // install necessary software
 metadata_startup_script = (var.image_coreserver == "centos-cloud/centos-7" || var.image_coreserver == "centos-cloud/centos-8" || var.image_coreserver == "rhel-cloud/rhel-8" || var.image_coreserver == "rhel-cloud/rhel-7" ? local.startupscript_core_rpmflavor : local.startupscript_core_debflavor)

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
 network_interface {
   subnetwork = "backendnetwork"
 }
 network_interface {
   subnetwork = "frontend"
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
   subnetwork = "frontend"
 }
}

// create necessary disks
resource "google_compute_disk" "coreserver-data-a" {
   count = var.number_coreserver
   name  = "${var.cluster_name}-coredatadisk-${count.index}-a"
   size  = var.datadisk_size-ssd
   type  = var.disk-type_dataserver-ssd 
   zone  = var.cluster_region
}

resource "google_compute_disk" "coreserver-data-b" {
   count = var.number_coreserver
   name  = "${var.cluster_name}-coredatadisk-${count.index}-b"
   size  = var.datadisk_size-hdd
   type  = var.disk-type_dataserver-hdd
   zone  = var.cluster_region
}

resource "google_compute_disk" "coreserver-data-c" {
   count = var.number_coreserver
   name  = "${var.cluster_name}-coredatadisk-${count.index}-c"
   size  = var.datadisk_size-hdd
   type  = var.disk-type_dataserver-hdd
   zone  = var.cluster_region
}


resource "google_compute_disk" "dataserver-data-a" {
   count = var.number_dataserver
   name  = "${var.cluster_name}-datadisk-${count.index}-a"
   size  = var.datadisk_size-ssd
   type  = "pd-ssd"
   zone  = var.cluster_region
}

resource "google_compute_disk" "dataserver-data-b" {
   count = var.number_dataserver
   name  = "${var.cluster_name}-datadisk-${count.index}-b"
   size  = var.datadisk_size-hdd
   type  = var.disk-type_dataserver-hdd 
   zone  = var.cluster_region
}

resource "google_compute_disk" "dataserver-data-c" {
   count = var.number_dataserver
   name  = "${var.cluster_name}-datadisk-${count.index}-c"
   size  = var.datadisk_size-hdd
   type  = var.disk-type_dataserver-hdd 
   zone  = var.cluster_region
}


resource "google_compute_disk" "coreserver-metadata-a" {
  count = var.number_coreserver
  name  = "${var.cluster_name}-metadatadisk-${count.index}-a"
  size  = 50
  type  = var.disk-type_dataserver-ssd 
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



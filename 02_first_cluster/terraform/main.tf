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
  cluster_zone = data.google_compute_zones.available.names[0]
}

// core cluster
resource "google_compute_instance" "core" {
 count        = var.number_coreserver
 name         = "${var.cluster_name}-coreserver${count.index}"
 machine_type = var.flavor_coreserver 
 zone         = local.cluster_zone
 allow_stopping_for_update = true
 lifecycle {
    ignore_changes = [attached_disk]
 }

 boot_disk {
   initialize_params {
     image = var.image_coreserver 
   }
 }

// fast nvme storage tier
 scratch_disk {
  interface = "NVME"
 }

 attached_disk {
  source = google_compute_disk.coreserver-metadata-a[count.index].name
 } 

 attached_disk {
  source = google_compute_disk.coreserver-data-a[count.index].name 
 } 

 attached_disk {
  source = google_compute_disk.coreserver-data-b[count.index].name 
 } 

 attached_disk {
  source = google_compute_disk.coreserver-data-c[count.index].name 
 } 

 depends_on = [
  google_compute_disk.coreserver-metadata-a,
  google_compute_disk.coreserver-data-a,
  google_compute_disk.coreserver-data-b,
  google_compute_disk.coreserver-data-c,
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
 zone         = data.google_compute_zones.available.names[0]
 allow_stopping_for_update = true
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

 attached_disk {
  source     = google_compute_disk.dataserver-data-a[count.index].name
 } 

 attached_disk {
  source     = google_compute_disk.dataserver-data-b[count.index].name
 } 

 attached_disk {
  source     = google_compute_disk.dataserver-data-c[count.index].name
 } 

 metadata = {
   "ssh-keys" = <<EOT
   deploy:${file(var.public_ssh_key)}
EOT
 }

 depends_on = [
  google_compute_disk.dataserver-data-a,
  google_compute_disk.dataserver-data-b,
  google_compute_disk.dataserver-data-c,
  google_compute_subnetwork.frontend-subnet,
  google_compute_subnetwork.backend-subnet
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
   subnetwork = "backend-subnet"
 }
 network_interface {
   subnetwork = "frontend-subnet"
 }
}


// some clients
resource "google_compute_instance" "client" {
 count        = var.number_clientserver
 name         = "${var.cluster_name}-client${count.index}"
 machine_type = var.flavor_clientserver
 zone         = data.google_compute_zones.available.names[0]
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
   subnetwork = "frontend-subnet"
 }
 depends_on = [
  google_compute_subnetwork.frontend-subnet
 ]
}

// create necessary disks
resource "google_compute_disk" "coreserver-data-a" {
   count = var.number_coreserver
   name  = "${var.cluster_name}-coredatadisk-${count.index}-a"
   size  = var.datadisk_size-ssd
   type  = var.disk-type_dataserver-ssd 
   zone  = local.cluster_zone
}

resource "google_compute_disk" "coreserver-data-b" {
   count = var.number_coreserver
   name  = "${var.cluster_name}-coredatadisk-${count.index}-b"
   size  = var.datadisk_size-hdd
   type  = var.disk-type_dataserver-hdd
   zone  = local.cluster_zone
}

resource "google_compute_disk" "coreserver-data-c" {
   count = var.number_coreserver
   name  = "${var.cluster_name}-coredatadisk-${count.index}-c"
   size  = var.datadisk_size-hdd
   type  = var.disk-type_dataserver-hdd
   zone  = local.cluster_zone
}


resource "google_compute_disk" "dataserver-data-a" {
   count = var.number_dataserver
   name  = "${var.cluster_name}-datadisk-${count.index}-a"
   size  = var.datadisk_size-ssd
   type  = "pd-ssd"
   zone  = local.cluster_zone
}

resource "google_compute_disk" "dataserver-data-b" {
   count = var.number_dataserver
   name  = "${var.cluster_name}-datadisk-${count.index}-b"
   size  = var.datadisk_size-hdd
   type  = var.disk-type_dataserver-hdd 
   zone  = local.cluster_zone
}

resource "google_compute_disk" "dataserver-data-c" {
   count = var.number_dataserver
   name  = "${var.cluster_name}-datadisk-${count.index}-c"
   size  = var.datadisk_size-hdd
   type  = var.disk-type_dataserver-hdd 
   zone  = local.cluster_zone
}


resource "google_compute_disk" "coreserver-metadata-a" {
  count = var.number_coreserver
  name  = "${var.cluster_name}-metadatadisk-${count.index}-a"
  size  = 50
  type  = var.disk-type_dataserver-ssd 
  zone  = local.cluster_zone
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



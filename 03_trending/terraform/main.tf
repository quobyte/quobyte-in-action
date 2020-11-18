// Configure Google Cloud provider
provider "google" {
 credentials = file("~/accessfiles/CREDENTIALS_FILE.json")
 project     = var.gcloud_project 
 region      = var.cluster_region 
}

// prometheus  instance 
resource "google_compute_instance" "trending" {
 count        = 1
 name         = "${var.cluster_name}-trending"
 machine_type = var.flavor_trendingserver 
 zone         = var.cluster_region
 allow_stopping_for_update = true
 lifecycle {
    ignore_changes = [attached_disk]
 }

 boot_disk {
   initialize_params {
     image = var.image_trendingserver 
   }
 }

 attached_disk {
  source     = "projects/${var.gcloud_project}/zones/${var.cluster_region}/disks/${var.cluster_name}-trendingdisk"
 } 

 metadata = {
   ssh-keys = "deploy:${file("~/.ssh/id_rsa.pub")}"
 }

 // install necessary software
 metadata_startup_script = "apt-get update; apt-get install -y ansible"
 
 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}
// create necessary disks
resource "google_compute_disk" "coreserver-data" {
   name  = "${var.cluster_name}-trendingdisk"
   size  = var.trendingdisk_size 
   type  = var.disk-type_trendingserver 
   zone  = var.cluster_region
}

// output section
output "bastion-ip" {
 value = google_compute_instance.trending.0.network_interface.0.access_config.0.nat_ip
}


// Configure the Google Cloud provider
provider "google" {
 credentials = file("~/accessfiles/CREDENTIALS_FILE.json")
 project     = var.gcloud_project 
 region      = var.cluster_region 
}

// single machine 
resource "google_compute_instance" "quobyte-lab" {
 count        = var.number_labserver 
 name         = "${var.cluster_name}-quobyte-lab-${count.index}"
 machine_type = var.flavor_labserver 
 zone         = var.cluster_region
 allow_stopping_for_update = true
 lifecycle {
    ignore_changes = [attached_disk]
 }

 boot_disk {
   initialize_params {
     image = var.image_labserver 
   }
 }

// insert SSH key for a user "deploy"
 metadata = {
   ssh-keys = "deploy:${file("~/.ssh/id_rsa.pub")}"
 }

// Make sure the right software is installed. 
 metadata_startup_script = "apt-get update; apt-get install -y wget ansible git; ansible-galaxy collection install ansible.posix; git clone https://github.com/jan379/ansible-deploy.git /home/deploy/ansible-deploy; chown -R deploy: /home/deploy/"

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}

// output of our ip to login to
output "lab-ip" {
 value = google_compute_instance.quobyte-lab.0.network_interface.0.access_config.0.nat_ip
}


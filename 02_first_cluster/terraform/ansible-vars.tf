### The Ansible vars file
resource "local_file" "AnsibleVars" {
 content = templatefile("templates/ansible-vars.tmpl",
 {
  //registry_entry = join(",", google_compute_instance.core.*.network_interface.0.network_ip) 
  registry_entry = var.dns_domain
  registry_frontend_entry = "frontend.${var.dns_domain}" 
  s3_endpoint_url = "s3.${var.dns_domain}" 
  metadata_device = "${var.metadata_device}" 
  api_ip = google_compute_instance.core.0.network_interface.1.network_ip 
  cluster_name = var.cluster_name 
  backend_subnet = google_compute_subnetwork.backend-subnet.ip_cidr_range
  frontend_subnet = google_compute_subnetwork.frontend-subnet.ip_cidr_range
  default_subnet = "10.0.0.0/8" 
 }
 )
 filename = "provisioning/ansible-vars"
 file_permission = "0644"
 provisioner "local-exec" {
   command = "until scp provisioning/ansible-vars deploy@${google_compute_instance.core.0.network_interface.0.access_config.0.nat_ip}: ; do sleep 1; done"
 }
}

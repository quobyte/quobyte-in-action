### The Ansible vars file
resource "local_file" "AnsibleVars" {
 content = templatefile("templates/ansible-vars.tmpl",
 {
  registry_ips = join(",", google_compute_instance.core.*.network_interface.0.network_ip) 
  cluster_name = var.cluster_name 
  net_cidr = var.net_cidr 
 }
 )
 filename = "provisioning/ansible-vars"
 file_permission = "0644"
 provisioner "local-exec" {
   command = "until scp provisioning/ansible-vars deploy@${google_compute_instance.core.0.network_interface.0.access_config.0.nat_ip}: ; do sleep 1; done"
 }
}

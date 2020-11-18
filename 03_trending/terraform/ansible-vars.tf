### The Ansible vars file
resource "local_file" "AnsibleVars" {
 content = templatefile("templates/ansible-vars.tmpl",
 {
  first_registry_ip = var.registry_ip 
  cluster_name = var.cluster_name 
 }
 )
 filename = "provisioning/vars/trendingserver-vars.yaml"
 file_permission = "0644"
 provisioner "local-exec" {
   command = "scp -r provisioning/ deploy@${google_compute_instance.trending.0.network_interface.0.access_config.0.nat_ip}:"
 }
}

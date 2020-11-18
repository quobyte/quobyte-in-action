### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
 content = templatefile("templates/inventory.tmpl",
 {
  trendingserver_ip = join("\n", google_compute_instance.trending.*.network_interface.0.network_ip) 
 }
 )
 filename = "provisioning/ansible-inventory"
 file_permission = "0644"
 provisioner "local-exec" {
   command = "scp -r provisioning/ deploy@${google_compute_instance.trending.0.network_interface.0.access_config.0.nat_ip}:"
 }
}

### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
 content = templatefile("templates/inventory.tmpl",
 {
  coreserver_ip = join("\n", google_compute_instance.core.*.network_interface.0.network_ip) 
  dataserver_ip = join("\n", google_compute_instance.dataserver.*.network_interface.0.network_ip)
  client_ip = join("\n", google_compute_instance.client.*.network_interface.0.network_ip)
 }
 )
 filename = "provisioning/ansible-inventory"
 file_permission = "0644"
 provisioner "local-exec" {
   command = "until scp provisioning/ansible-inventory deploy@${google_compute_instance.core.0.network_interface.0.access_config.0.nat_ip}: ; do sleep 1 ; done"
 }
}

### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
 content = templatefile("templates/inventory.tmpl",
 {
  number_dataserver = var.number_dataserver
  number_coreserver = var.number_coreserver
  number_clientserver = var.number_clientserver
  coreserver_ip = join(":\n      ", google_compute_instance.core.*.network_interface.0.network_ip) 
  coreserver_ips = google_compute_instance.core.*.network_interface.0.network_ip 
  dataserver_ip = join(":\n      ", google_compute_instance.dataserver.*.network_interface.0.network_ip)
  client_ip = join(":\n      ", google_compute_instance.client.*.network_interface.0.network_ip)
 }
 )
 filename = "provisioning/ansible-inventory.yaml"
 file_permission = "0644"
 provisioner "local-exec" {
   command = "until scp provisioning/ansible-inventory.yaml deploy@${google_compute_instance.core.0.network_interface.0.access_config.0.nat_ip}: ; do sleep 1 ; done"
 }
}

### A simple file containing every server node 
resource "local_file" "ShellInventory" {
 content = templatefile("templates/servers.tmpl",
 {
  number_dataserver = var.number_dataserver
  number_coreserver = var.number_coreserver
  coreserver_ip = join("\n", google_compute_instance.core.*.network_interface.0.network_ip) 
  dataserver_ip = join("\n", google_compute_instance.dataserver.*.network_interface.0.network_ip)
 }
 )
 filename = "provisioning/servers.txt"
 file_permission = "0644"
 provisioner "local-exec" {
   command = "until scp provisioning/servers.txt deploy@${google_compute_instance.core.0.network_interface.0.access_config.0.nat_ip}: ; do sleep 2 ; done"
 }
}
### A simple file containing every client node 
resource "local_file" "ShellInventoryClient" {
 content = templatefile("templates/clients.tmpl",
 {
  number_clientserver = var.number_clientserver
  client_ip = join("\n", google_compute_instance.client.*.network_interface.0.network_ip) 
 }
 )
 filename = "provisioning/clients.txt"
 file_permission = "0644"
 provisioner "local-exec" {
   command = "until scp provisioning/clients.txt deploy@${google_compute_instance.core.0.network_interface.0.access_config.0.nat_ip}: ; do sleep 2 ; done"
 }
}

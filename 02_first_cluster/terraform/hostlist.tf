### A simple file containing every server nod 
resource "local_file" "ShellInventory" {
 content = templatefile("templates/hostlist.tmpl",
 {
  number_dataserver = var.number_dataserver
  number_coreserver = var.number_coreserver
  coreserver_ip = join(":\n      ", google_compute_instance.core.*.network_interface.0.network_ip) 
  coreserver_ips = google_compute_instance.core.*.network_interface.0.network_ip 
  dataserver_ip = join(":\n      ", google_compute_instance.dataserver.*.network_interface.0.network_ip)
  client_ip = join(":\n      ", google_compute_instance.client.*.network_interface.0.network_ip)
 }
 )
 filename = "provisioning/nodes.txt"
 file_permission = "0644"
 provisioner "local-exec" {
   command = "until scp provisioning/nodes.txt deploy@${google_compute_instance.core.0.network_interface.0.access_config.0.nat_ip}: ; do sleep 2 ; done"
 }
}

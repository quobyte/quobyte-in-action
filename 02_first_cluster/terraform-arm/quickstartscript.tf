### A quickstart script 
resource "local_file" "quickstart" {
 source = "templates/quickstart.sh"
 filename = "quickstart.sh"
 file_permission = "0750"
 provisioner "local-exec" {
   command = "until scp templates/quickstart.sh deploy@${google_compute_instance.core.0.network_interface.0.access_config.0.nat_ip}: ; do sleep 1; done"
 }
}

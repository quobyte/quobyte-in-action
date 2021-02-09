terraform {
  required_providers {
    metal = {
      source = "equinix/metal"
      # version = "1.0.0"
    }
  }
}

# Configure the Equinix Metal Provider.
#provider "metal" {
#  auth_token = "xyz" # auth token can be set using the shell variable "PACKET_AUTH_TOKEN"
#}

locals {
  project_id = var.equinix_project_id 
}

resource "metal_device" "storage" {
  count        = 3
  hostname         = "qb${count.index}"
  plan             = "s3.xlarge.x86"
  facilities       = ["am6"]
  ##operating_system = "ubuntu_20_04"
  operating_system = "centos_8"
  billing_cycle    = "hourly"
  project_id       = local.project_id
}



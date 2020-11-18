
// Set up some cloud provider details
variable "gcloud_project" {
  type = string
  default = "quobyte-eng"
}

variable "cluster_region" {
  type = string
  default = "us-west1-a"
}

// configure cluster scope variables
variable "cluster_name" {
  type = string
  default = "bigpool"
}

variable "number_labserver" {
  type = number
  default = 1
}

variable "flavor_labserver" {
  type = string
  default = "e2-standard-4"
}

variable "image_labserver" {
  type = string
  default = "ubuntu-os-cloud/ubuntu-2004-lts"
}


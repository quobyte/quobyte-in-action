// Set up some cloud provider details
variable "gcloud_project" {
  type = string
  default = "quobyte-presales"
}

variable "cluster_region" {
  type = string
  default = "europe-west4-b"
}

variable "net_cidr" {
  type = string
  default = "10.0.0.0/8"
}

// configure cluster scope variables
variable "cluster_name" {
  type = string
  default = "quobyte"
}

variable "disk-type_trendingserver" {
  type = string
  default = "pd-ssd"
}

variable "flavor_trendingserver" {
  type = string
  default = "e2-standard-4"
}


variable "image_trendingserver" {
  type = string
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
  //default = "debian-cloud/debian-11"
}

variable "trendingdisk_size" {
  type = number
  default = 50 
}

variable "registry_ip" {
  type = string
  default = "registry0.quobyte-demo.com"
}



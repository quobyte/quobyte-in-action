// Set up some cloud provider details
variable "gcloud_project" {
  type = string
  default = "quobyte-eng"
}

variable "cluster_region" {
  type = string
  default = "us-west1-a"
}

variable "net_cidr" {
  type = string
  default = "10.0.0.0/8"
}

// configure cluster scope variables
variable "cluster_name" {
  type = string
  default = "smallpool"
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
  default = "ubuntu-os-cloud/ubuntu-2004-lts"
}

variable "trendingdisk_size" {
  type = number
  default = 50 
}

variable "registry_ip" {
  type = string
  default = "10.138.15.213"
}



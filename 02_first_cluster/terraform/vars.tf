
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

variable "image_coreserver" {
  type = string
  default = "ubuntu-os-cloud/ubuntu-2004-lts"
}

variable "number_coreserver" {
  type = number
  default = 4
}

variable "disk-type_coreserver" {
  type = string
  default = "pd-ssd"
}

variable "flavor_coreserver" {
  type = string
  default = "e2-standard-4"
}


variable "image_dataserver" {
  type = string
  default = "ubuntu-os-cloud/ubuntu-2004-lts"
}

variable "datadisk_size" {
  type = number
  default = 50 
}

variable "datadisk_hdd_size" {
  type = number
  default = 1000
}

variable "disk-type_dataserver-a" {
  type = string
  default = "pd-ssd"
}

variable "disk-type_dataserver-b" {
  type = string
  default = "pd-standard"
}

variable "number_dataserver" {
  type = number
  default = 5
}

variable "flavor_dataserver" {
  type = string
  default = "e2-standard-4"
}

variable "number_clientserver" {
  type = number
  default = 1
}

variable "flavor_clientserver" {
  type = string
  default = "e2-standard-4"
}

variable "image_clientserver" {
  type = string
  default = "ubuntu-os-cloud/ubuntu-2004-lts"
}



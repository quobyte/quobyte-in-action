
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
  default = "smallscale"
}

variable "image_coreserver" {
  type = string
  //default = "ubuntu-os-cloud/ubuntu-2004-lts"
  //default = "debian-cloud/debian-10"
  default = "centos-cloud/centos-8"
}

variable "number_coreserver" {
  type = number
  default = 3
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
  //default = "ubuntu-os-cloud/ubuntu-2004-lts"
  //default = "debian-cloud/debian-10"
  default = "centos-cloud/centos-8"
}

variable "datadisk_size-a" {
  type = number
  default = 100 
}

variable "datadisk_size-b" {
  type = number
  default = 100
}

variable "disk-type_dataserver-a" {
  type = string
  default = "pd-ssd"
  //default = "pd-standard"
}

variable "disk-type_dataserver-b" {
  type = string
  default = "pd-standard"
  //default = "pd-ssd"
}

variable "number_dataserver" {
  type = number
  default = 3
}

variable "flavor_dataserver" {
  type = string
  default = "e2-standard-4"
}

variable "number_clientserver" {
  type = number
  default = 0
}

variable "flavor_clientserver" {
  type = string
  default = "e2-standard-4"
}

variable "image_clientserver" {
  type = string
  //default = "ubuntu-os-cloud/ubuntu-2004-lts"
  //default = "debian-cloud/debian-10"
  default = "centos-cloud/centos-8"
}

variable "startupscript_core_rpmflavor" {
  type = string
  default = "yum install epel-release -y; yum update -y ; yum install -y wget ansible git python2; git clone --branch deploy-3.0  --single-branch https://github.com/quobyte/ansible-deploy.git /home/deploy/ansible-deploy"
}

variable "startupscript_core_debflavor" {
  type = string
  default = "apt-get update; apt-get install -y wget ansible git python; git clone --branch deploy-3.0  --single-branch https://github.com/quobyte/ansible-deploy.git /home/deploy/ansible-deploy"
}

variable "startupscript_other_debflavor" {
  type = string
  default = "apt-get update; apt-get install -y wget curl python"
}

variable "startupscript_other_rpmflavor" {
  type = string
  default = "yum update -y; yum install -y wget curl python2"
}

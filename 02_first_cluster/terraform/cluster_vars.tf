// Within this file all variables are defined to adjust 
// Quobyte cluster settings.

// configure cluster scope variables
variable "cluster_name" {
  type = string
  default = "quobyte"
}
}

// We can control number of clients, core servers (to provision core services) and
// the number of dataservers. The latter is meant to deploy only Quobyte data 
// services.

variable "number_coreserver" {
  type = number
  default = 3

variable "number_clientserver" {
  type = number
  default = 2
}

variable "number_dataserver" {
  type = number
  default = 3 
}

// Defining flavors decides
// 1: If servers can run local attached NVMe (and how many)
// 2: Which network throughput they get
// 3: And of course which CPU/ memory.

variable "flavor_coreserver" {
  type = string
  //default = "e2-standard-4"
  # n1- has NVMe as an option
  default = "n1-standard-8"
}

variable "flavor_clientserver" {
  type = string
  default = "e2-standard-4"
  # h3 has 200 Gbit/s + NVMe
  //default = "h3-standard-88"
}

variable "flavor_dataserver" {
  type = string
  # n1- has NVMe as an option
  default = "n1-standard-8"
  //default = "n2-standard-32"
  //default = "n2-standard-64"
}

variable "image_coreserver" {
  type = string
  //default = "ubuntu-os-cloud/ubuntu-2204-lts"
  //default = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
  //default = "ubuntu-os-cloud/ubuntu-minimal-2404-lts-amd64"
  //default = "debian-cloud/debian-11"
  //default = "debian-cloud/debian-12"
  default = "debian-cloud/debian-13"
  //default = "rocky-linux-cloud/rocky-linux-9-optimized-gcp"
  //default = "suse-cloud/sles-12"
  //default = "suse-cloud/sles-15"
}

variable "image_dataserver" {
  type = string
  //default = "ubuntu-os-cloud/ubuntu-2204-lts"
  //default = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
  //default = "ubuntu-os-cloud/ubuntu-minimal-2404-lts-amd64"
  //default = "debian-cloud/debian-11"
  //default = "debian-cloud/debian-12"
  default = "debian-cloud/debian-13"
  //default = "rocky-linux-cloud/rocky-linux-9-optimized-gcp"
  //default = "suse-cloud/sles-12"
  //default = "suse-cloud/sles-15"
}

variable "image_clientserver" {
  type = string
  //default = "ubuntu-os-cloud/ubuntu-2204-lts"
  //default = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
  //default = "ubuntu-os-cloud/ubuntu-minimal-2404-lts-amd64"
  //default = "debian-cloud/debian-11"
  //default = "debian-cloud/debian-12"
  default = "debian-cloud/debian-13"
  //default = "rocky-linux-cloud/rocky-linux-9-optimized-gcp"
  //default = "suse-cloud/sles-12"
  //default = "suse-cloud/sles-15"
}

// If using spot instances "preeptible" needs to be set to "true" and vice versa
variable "provisioning_model" {
  type = string
  //default = "SPOT"
  default = "STANDARD"
}

variable "preemptible" {
  type = bool
  //default = true 
  default = false 
}

variable "metadata_device" {
  type = string
  default = "/dev/nvme0n1"
}

variable "disk-type_coreserver" {
  type = string
  default = "pd-ssd"
}


variable "datadisk_size-ssd" {
  type = number
  default = 300 
}

variable "datadisk_size-hdd" {
  type = number
  default = 300
}

variable "disk-type_dataserver-ssd" {
  type = string
  default = "pd-ssd"
}

variable "disk-type_dataserver-hdd" {
  type = string
  default = "pd-standard"
}

variable "git_repository" {
  type = string
  default = "https://github.com/quobyte/quobyte-ansible.git"
}

locals {
  startupscript_core_suse12 = "SUSEConnect -p PackageHub/12.5/x86_64; zypper install -y git ansible wget; git clone ${var.git_repository} /home/deploy/quobyte-ansible; chown -R deploy: /home/deploy/quobyte-ansible"
  startupscript_core_suse15 = "SUSEConnect -p PackageHub/15.3/x86_64; zypper install -y git ansible wget; git clone https://github.com/quobyte/quobyte-ansible.git /home/deploy/quobyte-ansible; chown -R deploy: /home/deploy/quobyte-ansible"
  startupscript_core_rhel = "dnf install -y git ansible-core; ansible-galaxy collection install community.general; git clone ${var.git_repository} /home/deploy/quobyte-ansible; chown -R deploy: /home/deploy/quobyte-ansible"
  startupscript_core_rpmflavor = "yum install epel-release -y; yum update -y ; yum install -y wget ansible-python3 git python3; git clone ${var.git_repository} /home/deploy/quobyte-ansible; chown -R deploy: /home/deploy/quobyte-ansible"
  startupscript_core_debflavor = "apt-get update; apt-get install -y ansible git; git clone ${var.git_repository} /home/deploy/quobyte-ansible; chown -R deploy: /home/deploy/quobyte-ansible"
}

variable "startupscript_other_debflavor" {
  type = string
  default = "apt-get update; apt-get install -y wget curl python3"
}

variable "startupscript_other_rpmflavor" {
  type = string
  default = "yum update -y; yum install -y wget curl python3 ansible-core"
}

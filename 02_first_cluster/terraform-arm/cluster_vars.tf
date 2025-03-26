// Within this file all variables are defined to adjust 
// Quobyte cluster settings.

variable "net_cidr" {
  type = string
  default = "10.0.0.0/8"
}

// configure cluster scope variables
variable "cluster_name" {
  type = string
  default = "quobyte"
}

variable "git_repository" {
  type = string
  default = "https://github.com/quobyte/quobyte-ansible.git"
}
variable "image_coreserver" {
  type = string
  //default = "ubuntu-os-cloud/ubuntu-1804-lts"
  //default = "ubuntu-os-cloud/ubuntu-2204-lts"
  //default = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
  //default = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-2404-noble-amd64-v20250117"
  //default = "ubuntu-os-cloud/ubuntu-minimal-2404-lts-amd64"
  //default = "rocky-linux-cloud/rocky-linux-9"
  // default = "rocky-linux-cloud/rocky-linux-9-optimized-gcp"
  default = "rocky-linux-9-optimized-gcp-arm64-v20250311"
  //default = "debian-cloud/debian-11"
  //default = "centos-cloud/centos-7"
  //default = "rhel-cloud/rhel-7"
  //default = "rhel-cloud/rhel-8"
  //default = "suse-cloud/sles-12"
  //default = "suse-cloud/sles-15"
}

variable "metadata_device" {
  type = string
  default = "nvme0n1"
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
  //default = "e2-standard-4"
  //default = "n1-standard-8"
  ## ARM based 64GB RAM + local SSD
  default = "c4a-highmem-8-lssd"
}


variable "image_dataserver" {
  type = string
  //default = "ubuntu-os-cloud/ubuntu-2004-lts"
  //default = "ubuntu-os-cloud/ubuntu-2204-lts"
  //default = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
  //default = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-2404-noble-amd64-v20250117"
  //default = "ubuntu-os-cloud/ubuntu-minimal-2404-lts-amd64"
  //default = "rocky-linux-cloud/rocky-linux-9"
  //default = "rocky-linux-cloud/rocky-linux-9-optimized-gcp"
  default = "rocky-linux-9-optimized-gcp-arm64-v20250311"
  //default = "suse-cloud/sles-15"
  //default = "debian-cloud/debian-11"
  //default = "debian-cloud/debian-10"
  //default = "centos-cloud/centos-7"
  //default = "rhel-cloud/rhel-7"
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

variable "number_dataserver" {
  type = number
  default = 6 
}

variable "flavor_dataserver" {
  type = string
  //default = "e2-standard-4"
  //default = "n1-standard-8"
  ## ARM based 64GB RAM + local SSD
  default = "c4a-highmem-8-lssd"
  ## high throughput for nvme
  //default = "n2-standard-32"
  //default = "n2-standard-64"
}

variable "number_clientserver" {
  type = number
  default = 2
}

variable "flavor_clientserver" {
  type = string
  // default = "e2-standard-4"
  //default = "n1-standard-8"
  # h3 has 200 Gbit/s
  //default = "h3-standard-88"
  ## ARM
  default = "c4a-highmem-8-lssd"
}

variable "image_clientserver" {
  type = string
  //default = "ubuntu-os-cloud/ubuntu-2204-lts"
  //default = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
  //default = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-2404-noble-amd64-v20250117"
  //default = "rocky-linux-cloud/rocky-linux-9"
  //default = "rocky-linux-cloud/rocky-linux-9-optimized-gcp"
  default = "rocky-linux-9-optimized-gcp-arm64-v20250311"
  //default = "suse-cloud/sles-15"
  //default = "debian-cloud/debian-11"
  //default = "suse-cloud/sles-12"
  //default = "debian-cloud/debian-10"
  //default = "centos-cloud/centos-8"
  //default = "centos-cloud/centos-7"
  //default = "rhel-cloud/rhel-8"
  //default = "rhel-cloud/rhel-7"
}

locals {
  startupscript_core_suse12 = "SUSEConnect -p PackageHub/12.5/x86_64; zypper install -y git ansible wget; git clone ${var.git_repository} /home/deploy/quobyte-ansible; chown -R deploy: /home/deploy/quobyte-ansible"
  startupscript_core_suse15 = "SUSEConnect -p PackageHub/15.3/x86_64; zypper install -y git ansible wget; git clone https://github.com/quobyte/quobyte-ansible.git /home/deploy/quobyte-ansible; chown -R deploy: /home/deploy/quobyte-ansible"
  startupscript_core_rhel = "dnf install -y git; git clone ${var.git_repository} /home/deploy/quobyte-ansible; chown -R deploy: /home/deploy/quobyte-ansible"
  startupscript_core_rpmflavor = "yum install epel-release -y; yum update -y ; yum install -y wget ansible-python3 git python3; git clone ${var.git_repository} /home/deploy/quobyte-ansible; chown -R deploy: /home/deploy/quobyte-ansible"
  startupscript_core_debflavor = "apt-get update; apt-get install -y ansible git; git clone ${var.git_repository} /home/deploy/quobyte-ansible; chown -R deploy: /home/deploy/quobyte-ansible"
}

variable "startupscript_other_debflavor" {
  type = string
  default = "apt-get update; apt-get install -y wget curl python"
}

variable "startupscript_other_rpmflavor" {
  type = string
  default = "yum update -y; yum install -y wget curl python3"
}

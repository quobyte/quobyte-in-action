#!/usr/bin/env bash

until ls quobyte-ansible/inventory.yaml; do 
  sleep 5; 
  echo "Waiting for cloud-init to be finished..."
done ; 

git clone git@github.com:jan379/quobyte-presales.git /home/deploy/quobyte-presales
chown deploy: /home/deploy/quobyte-presales
cat <<EOF> /home/deploy/.gitconfig
[user]
	email = jan.peschke@quobyte.com
	name = Jan Peschke
EOF

cp ansible-vars quobyte-ansible/vars/ansible-vars
cp ansible-inventory.yaml quobyte-ansible/inventory.yaml
cd quobyte-ansible
ansible-playbook -i inventory.yaml 00_install_quobyte_server.yaml 01_setup_coreservices.yaml 02_create_superuser.yaml 03_add_metadataservices.yaml 04_add_dataservices.yaml 05_optional_tune-cluster.yaml 06_optional_install_defaultclient.yaml 07_optional_license_cluster.yaml 08_optional_add_s3services.yaml helper/20_stop_cluster.yaml helper/21_start_cluster.yaml



# First Quobyte Cluster

Within this example we will install a Quobyte cluster.
The cluster will have the following specs:

* Four virtual machines
 * Every machine has two storage devices, one for metadata and one for data.
 * Optionally you can add dddtional ata server to scale your cluster capacity / performance 
   by changing the value "number_dataserver" in terraform/vars.tf

The ansible playbook will install every Quobyte component necessary to deploy 
a fully functional Quobyte cluster.

After a successfull run you can open the Quoybte web console and explore every 
component that comes with a default install.

There will be clients deployed also on the four installed machines (named "core-[0-4]").

## Installation

First install your virtual machine environment following the steps mentioned in 

01_virtual_infrastructure.md

Then move over to follow insturctions in 

02_server_provisioning.md



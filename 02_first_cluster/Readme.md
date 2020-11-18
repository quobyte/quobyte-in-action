# First Quobyte Cluster

Within this example we will install a Quobyte cluster.
The cluster will have the following specs:

* Four virtual machines
 * Every machine has two storage devices, one for metadata and one for data.

The ansible playbook will install every Quobyte component necessary to deploy 
a fully functional Quobyte cluster.

After a successfull run you can open the Quoybte web console and explore every 
component that comes with a default install.

There will not be additional data servers and also clients will reside on the 
four installed machines.

## Installation

First install your virtual machine environment following the steps mentioned in 

01_virtual_infrastructure.md

Then move over to follow insturctions in 

02_server_provisioning.md



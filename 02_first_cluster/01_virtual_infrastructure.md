# Install infrastructure

## Preparations

Change into the directory "terraform" and adjust some variables 
in the file "vars.tf". 

* Change "number_clients" to 0
* Change "number_dataservers" to 0

Assure, that everything is working:

```
$ cd terraform
$ terraform plan
```

## Spin up the infrastructure


```
$ terraform apply
```

Expected result: You should get four machines created.
The output section of "terraform apply" should give you 
the external IP.
You should be able to login:


```
$ ssh -A deploy@<externalIP>
```

After login you should see the following directoy layout:

```
deploy@smallscale-coreserver0:~$ ls -l
total 12
drwxr-xr-x 5 root   root   4096 Dec 11 14:34 ansible-deploy
-rw-r--r-- 1 deploy deploy  201 Dec 11 14:34 ansible-inventory
-rw-r--r-- 1 deploy deploy  197 Dec 11 14:34 ansible-vars
```

From here you can switch to the next chapter "02_server_provisioning".

## Options

You can define many aspects of the storage cluster by just changing variables in the ``` vars.tf ``` file.

## Defining storage devices

You can set up a pure flash, HDD only or a mixed environment. The variables to modify are

* disk-type_coreserver,
* disk-type_dataserver-a and  
* disk-type_dataserver-b  

You can for example set the coreserver devices to SSD while defining all storage devices as HDD devices.

## Defining core cluster size

The default machine count for a default Quobyte cluster is four machines running the Quobyte core services (Registry, Data, Metadata). But you are free to change that:

* number_coreserver

This will prepare the given count of machines provisioned with a dedicated metadata device. You should also control the ansible variable "clsutersize", since that decides the actual count of registry services that will be deployed throughout the cluster.

## Dataservice scale out

You can scale your Quobyte cluster by adding more data-nodes:

* number_dataserver

This number will add/ remove additional nodes to your cluster.
You can select which capacity the two attached data devices will have:

* datadisk_size-a and
* datadisk_size-b


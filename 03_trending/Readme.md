# Trending server

This chapter will install a trendingserver. This willl allow you to collect 
metrics over time and graph them in a simple manner.

## Usage

Adjust ```vars.tf``` to consist of the IP of one of your registries.
Optionally adjust cluster name and other values also

```
$ cd terraform
$ terraform plan
$ terraform apply 
```
Watch out for the IP of the newly generated hosts and ssh into the host:

```
$ ssh -A deploy@<publicIP> 
$ cd provisioning
$ ansible-playbook -i ansible-inventory install-trendingserver.yaml 
```

Expected outcome: You should have now a publicly reachable prometheus instance. This instance is connected to 
you Quobyte cluster through the registry IP you gave in "vars.tf". The Quobyte registry acts as service discovery host; so 
you have to configure nothing and newly created hosts/ services etc. will be added dynamically to your trending system.

## 

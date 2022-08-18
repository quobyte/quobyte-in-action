# Trending server

This chapter will install a Prometheus instance to collect Quobyte metrics as time series data. 
It will also install a Grafana instance to display these metrics in a nice Dashboard.

## Installation

Adjust ```vars.tf``` to contain the IP of one of your registries.
Optionally adjust cluster name and other values also.

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

## Expected outcome 

* A Proemtheus instance, reachable via http://<PublicIPAddress>:9090
* A Grafana instance, reachable via http://<PublicIPAddress>:3000

The Prometheus instance is already equipped with a "ready to go" configuration to scrape all data 
that Quobyte is exporting.
The Grafana instance can be used to graph Prometheus data in pretty dashboards.
A Quoybte specific Dashboard can be used from here:
https://grafana.com/grafana/dashboards/14496-quobyte-dashboard-3-x/

## Note

The Ansible playbooks can also be used standalone. They are located in the 
"provsioning" folder.



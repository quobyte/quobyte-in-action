# Prometheus and Grafana playbooks

These playbooks will install a Prometheus instance 
as well as a Grafana instance.

The Proemtheus instance will be configured to use the 
Service Discovery capabilities of the Quobyt registry.
This way metrics from the whole storage cluster will end up 
in Prometheus without any manual target configuration.
The only information needed is the address of a Quobyte registry.

A good start to use the Grafana instance might be the Quobyte
Dashboard:
https://grafana.com/grafana/dashboards/14496-quobyte-dashboard-3-x/

## Install

You can start installation using 

```
ansible-playbook -i inventory install-trendingserver.yaml
```

# Installing Quobyte


## Login to the first cluster node
```
$ ssh -A deploy@<publicIPOfYourFirstClusterNode>
```

## Run ansible based quobyte installation
```
$ ansible-playbook -i ansible-inventory -e @ansible-vars ansible-deploy/install-quobyte-server.yaml
```

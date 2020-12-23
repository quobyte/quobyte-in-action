# Installing Quobyte


## Login to the first cluster node
```
$ ssh -A deploy@<publicIPOfYourFirstClusterNode>
```

## Run ansible based quobyte installation

```
$ sudo cp ansible-vars ansible-deploy/vars/quobyte.yaml
$ ansible-playbook -i ansible-inventory ansible-deploy/install-quobyte-core.yaml
```

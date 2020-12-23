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

## Options

### Scale-Out

If you are running more than the core cluster you should provision additional data-nodes using ansible:

```
$ ansible-playbook -i ansible-inventory ansible-deploy/scaleout_dataservices.yaml
```

### Restart services

If you want to restart a complete Quobyte cluster you can use an ansible playbook for that:
```
$ ansible-playbook -i ansible-inventory ansible-deploy/restart-services.yaml
```

You can use that playbook for example to learn how Quobyte services do an automated failover. Just run the playbook while some other processes might generate load on the cluster. You can watch logfiles in another terminal using ``` journalctl -f SOFTWARE=quobyte ```




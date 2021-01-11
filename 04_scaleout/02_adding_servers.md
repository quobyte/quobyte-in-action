# Adding data servers to Quobyte

Scaling out Quobyte via machines requires the following: 

* Add a new machine
* Install software
* Integrate the server into the cluster

## Add a new machine (using terraform).

Using our terraform scripts to add one or more dataservers we can use our terraform receipt.
All that we have to do is increasing one variable: ``` number_dataserver ```.
In our example we set it from zero to three data servers:

```
variable "number_dataserver" {
  type = number
  default = 3
}
```

We then apply the changes to our infrastructure:

```
$ terraform plan
$ terraform apply
```

To install the necessary software and integrate additional data servers we run a dedicated Ansible playbook:

```
$ ansible-playbook -i ansible-inventory ansible-deploy/scaleout_dataservices.yaml
```

That is all there is to do to add new data servers.

The ansible playbook will take care of installing the necessary software and integrating them into the cluster.





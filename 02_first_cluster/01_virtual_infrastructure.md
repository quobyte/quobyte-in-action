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





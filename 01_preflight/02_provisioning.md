# Configuration management, provisioning. 

In this example we use Ansible to install and configure software on different machines.

## Set up

You need to be able to login to the previously created machine "quobyte-lab-0" via SSH.
The terraform metadata script should already set up the ansible commandline tooling.

## Test

To make sure that Ansible is available and in a working state just do a 

```
ansible --version
```

The expected outcome should be a version number and information block like this: 

```
ansible 2.9.6
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/deploy/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.8.5 (default, Jul 28 2020, 12:59:40) [GCC 9.3.0]
```


## More information in how to get started: 
https://docs.ansible.com/ansible/latest/network/getting_started/first_playbook.html

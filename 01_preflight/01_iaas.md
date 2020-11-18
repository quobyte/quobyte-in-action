# Infrastructure as a service /  Infrastructure as code

## Motivation
We want to be able to tear down and rebuild our infrastructure (and maybe modify it) at any point in time. 
With that we can have a clean lab without any side effects coming from old installations etc. 

## Tooling 

Since we want a simple and provider agnostic tool we use Terraform from Hashicorp.

## Install

Follow the guide from Hashicorp for your OS:
https://learn.hashicorp.com/tutorials/terraform/install-cli

## Configure

Adjust values in terraform/vars.tf. You need to set at least

* Your google cloud project

Also assure that a valid credientials file for google cloud services is located at 
~/accessfiles/CREDENTIALS_FILE.json or adjust the path within main.tf.

## Test 

Perform these steps to confirm that your environment is up and working:

``` 
$ terraform init
```


```
$ terraform plan
``` 

```
$ terraform apply
```

### Expected outcome: 
On your choosen cloud provider should now appear a virtual machine with the name "bigpool-quobyte-lab-0".
The IP address of your new VM should be displayed in the terraform output after "terraform apply".
You should be able to log in via ssh using the user name "deploy".


```
$ ssh -A deploy@<ipOfYourMachine>
```

If you finished inspecting your virtual machine you can destroy the whole system with


```
$ terraform destroy
```



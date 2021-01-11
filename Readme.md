# Quoybte in action

This repository provides material to get hands on experience with Quobyte.

With material collected here you will be able to try out things like maintenance tasks, 
see how Quobyte reacts to hardware failures or how you can scale out a Quobyte storage system.

This repository does not contain the [official documentation](https://support.quobyte.com/docs/16/latest/index.html) but contains step by step tutorials on how to get specific things done.

## How to use this repository

This repository is usually structured in chapters that work on their own. If you are for example interested in how to integrate Quobyte into a Kubernetes 
cluster simply change into that directory and follow the numbered instructions there. 

For the sake of keeping things easy and repeatable some tools are used throughout the tutorials here:

1. Terraform
If you do not have a lab environment with existing machines available we provide some terraform receipts to set up virtual machines in a cloud environment (Infrastructure as code).

2. Ansible
To install software to linux boxes in a convenient way we use Ansible. Ansible is more or less used as a wrapper around official supported tools like the Quobyte installer. If you need to transfer steps done in an Ansible playbook to other automation tools like Saltstack you can use these playbooks as a reference/ inspiration.


## Maintenance

* Scale out a Quobyte cluster without downtime

* Exchange "hardware" (in our case virtual machines)

* Upgrade Quobyte
	* Upgrade clients
	* Upgrade services


## Operational edge cases

* See disks failing and quobyte acting on that

* See machines failing and Quobyte reacting on such an event

* See how Quobyte reacts on network failures

* See how Quobyte reacts on slow devices


## Concepts

Although this is a pure practical guide, you will learn about concepts like

* Failure domains

* File placement policies and their consequences

* File layout policies and their consequences

and maybe many more.

## Requirements

For now these tutorials are tested only on Google Cloud.

But orchestration tools and deployment tools are not vendor specific.

For instastructure orchestration the tool of choice is terraform.

For installing things Ansible is used.

## Literature

### Architecture

The Quoybte architectural whitepaper could be useful for concepts, 
buzzwords and a general understanding of what the hell you are doing here: 

https://www.quobyte.com/downloads/quobyte-architecture_whitepaper.pdf

### Reference

Many topics mentioned here are explained in depth in our recent [online reference](https://support.quobyte.com/docs/16/latest/index.html).




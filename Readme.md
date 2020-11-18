# Quoybte in action

This repo provides material that goes beyond demonstrating "Quobyte is easy to install"

With material collected here you will be able to try out things like classical maintenance or observe error handling.

## Tooling

* Set up metrics collections over time (Prometheus) and watch effects like self healing + perfomance patterns over time


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

The Quoybte architectural whitepaper could be useful for concepts, 
buzzwords and a general understanding of what the hell you are doing here: 

https://www.quobyte.com/downloads/quobyte-architecture_whitepaper.pdf



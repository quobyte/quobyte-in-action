#!/bin/bash

for i in api data registry webconsole metadata
do 
	for j in host1 host2 host3
	do 
		quobyte_create_service --type $i --host $j
	done
done

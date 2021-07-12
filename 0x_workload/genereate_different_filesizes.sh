#!/usr/bin/env bash

# generate files of different sizes.

filenumber=1000
stepping=1
upper_border=20
size=1; 

for i in $(seq 1000) ; do 
	dd if=/dev/zero of=file-$i bs=1M count=$size; ((size++)); 
	if [[ "$size" -ge "20" ]] ; then 
		size=1; 
	fi ;
done

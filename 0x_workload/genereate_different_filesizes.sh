#!/usr/bin/env bash

# generate files of different sizes.

filenumber=10000	# how many files are generated
stepping=10		# steps to increment file sizes
upper_border=200	# how many steps are incremented before we start again
count=1; 		# lets start with a minimal file size
bs=32k			# actual file sizes are count * bs

for i in $(seq ${filenumber}) ; do
	dd if=/dev/zero of=file-$i bs=${bs} count=$count; count=$((count+stepping)); 
        if [[ "$count" -ge "${upper_border}" ]] ; then
                count=1; 
        fi ;
done

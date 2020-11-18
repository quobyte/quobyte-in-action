#!/bin/sh

 

for j in 4 8 16 32;

do

        mkdir -p $j

        for i in `seq 4 +4 40`;

        do

                BS=${j}k JOBS=$i fio rand_write --output=./$j/$i.json --output-format=json

                sleep 5

        done

done

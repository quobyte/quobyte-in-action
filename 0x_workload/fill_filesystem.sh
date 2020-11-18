#!/usr/bin/env

echo "This one will fill your file system, don't use it on production"


capacity=$(df /quobyte | grep /quobyte | awk '{print $(NF-4)}')
usage=$(df /quobyte | grep /quobyte | awk '{print $(NF-3)}')
watermark=2 			# only fill 50%
df_unit=1024 			# df spits out 1k bytes(?)
block_size=$((1024*1024))	#1M

file_size=$((capacity / watermark * df_unit / block_size - usage))

echo dd if=/dev/zero of=hugefile bs=$block_size count=$file_size status=progress

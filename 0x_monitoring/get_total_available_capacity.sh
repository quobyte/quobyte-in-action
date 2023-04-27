#!/user/bin/env bash 

totalbytes=$(qmgmt device list DATA -o json | jq .[].total_disk_space_bytes | awk '{sum+=$0} END{print sum}')

usedbytes=$(qmgmt device list DATA -o json | jq .[].used_disk_space_bytes | awk '{sum+=$0} END{print sum}')

totalavailablebytes=$((totalbytes - usedbytes))

echo "$totalavailablebytes"

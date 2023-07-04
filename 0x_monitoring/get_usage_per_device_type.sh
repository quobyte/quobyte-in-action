#!/user/bin/env bash 

hddusedbytes=$(qmgmt device list DATA -o json | jq '.[] | select(.device_tags[] | contains("hdd")) | .used_disk_space_bytes' | awk '{sum+=$0} END{print sum}')

nvmeusedbytes=$(qmgmt device list DATA -o json | jq '.[] | select(.device_tags[] | contains("nvme")) | .used_disk_space_bytes' | awk '{sum+=$0} END{print sum}')

echo "HDD used bytes: $hddusedbytes"
echo "NVME used bytes: $nvmeusedbytes"


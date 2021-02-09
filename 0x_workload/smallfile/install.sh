git clone https://github.com/distributed-system-analysis/smallfile.git

# import a new policy
qmgmt policy-rule import quobyte-smallfile-policy.quo

# tag devices with tag "fast":
for device in $devicelist; do
 device update add-tags ${device_id} "fast"
done

# create a volume for testing
qmgt volume ...


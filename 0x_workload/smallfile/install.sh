# Ensure python3 is available on every involved host :)

# import a smallfile policy
qmgmt policy-rule import quobyte-smallfile-policy.quo

# tag devices with tag "fast":
devicelist=$(qmgmt device list | grep  "256 GB" | cut -d" " -f1)
for device in $devicelist; do
 qmgmt device update add-tags ${device} "fast"
done

# create a volume for testing
qmgmt volume create testvolume myuser mygroup BASE

# create test directory:

mkdir -p /quobyte/testvolume/smallfile-test
git clone https://github.com/distributed-system-analysis/smallfile.git /quobyte/testvolume/smallfile

export myhosts=$(grep ^registry /etc/quobyte/host.cfg | sed 's/registry=//g')

# do a distributed smallfile test
python3 /quobyte/testvolume/smallfile/smallfile_cli.py --operation create --threads 3 --file-size 2048 --files 10240 --top /quobyte/testvolume/smallfile-test/ --host-set ${myhosts}

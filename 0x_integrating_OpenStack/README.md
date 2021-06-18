# Using Quobyte from OpenStack


## Cinder Integration
1. Install and configure Quobyte-Client on Hypervisor
2. Configure Cinder to use Quobyte (/etc/cinder/cinder.conf):

```
[DEFAULT]
...
...
...
enabled_backends = quobyte
default_volume_type = quobyte

[quobyte]
volume_driver = cinder.volume.drivers.quobyte.QuobyteDriver
volume_backend_name = quobyte 
quobyte_volume_url = quobyte://10.164.0.49,10.164.0.52,10.164.0.13/volumes
quobyte_client_cfg = /etc/quobyte/client.cfg
quobyte_sparsed_volumes = True
quobyte_qcow2_volumes = True
quobyte_mount_point_base = /mnt/openstack-volumes
```


* create mountpoint:
```
mkdir -p /mnt/openstack-volumes
chown -R stack: /mnt/openstack-volumes
```

* restart cinder
```
systemctl restart devstack@c-vol.service
```

* watch cinder while trying to create a volume:
```
journalctl -fu devstack@c-vol.service
```



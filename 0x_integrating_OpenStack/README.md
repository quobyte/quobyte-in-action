# Work in Progress


## Cinder Integration
1. Install and configure Quobyte-Client on Hypervisor
2. Configure Cinder to use Quobyte:

```
[DEFAULT]
...
...
...
enabled_backends = quobyte

[quobyte]
volume_driver = cinder.volume.drivers.quobyte.QuobyteDriver
volume_backend_name = quobyte 
quobyte_volume_url = quobyte://10.164.0.49,10.164.0.52,10.164.0.13/myvolume-2
quobyte_client_cfg = /etc/quobyte/client.cfg
quobyte_sparsed_volumes = True
quobyte_qcow2_volumes = True
quobyte_mount_point_base = /mnt/openstack/quobytemnt
```



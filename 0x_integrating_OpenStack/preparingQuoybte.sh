# create a tenant: opensteack

api_service_host=10.0.0.3


qmgmt -u ${api_service_host} tenant create openstack

# create diffferent users: nova-tenantadmin, cinder-tenantadmin, glance-tenantadmin

qmgmt user config add openstack openstack@myorg.org FILESYSTEM_ADMIN openstack password mysecret

# create diffferent volumes for different tenants:
qmgmt -u ${api_service_host} volume create openstack/vmimages user=nova group=nova configuration_name=noSpecialConfig
qmgmt -u ${api_service_host} volume create openstack/imagestore user=nova group=nova configuration_name=noSpecialConfig
qmgmt -u ${api_service_host} volume create openstack/volumes user=nova group=nova configuration_name=noSpecialConfig

# Load over time

In this setting we will start different write workloads on two different clients writing to on evolume/ file system.
This load will run as long as we want; so we can observe our cluster and see how it reacts for example to taking devices or hosts offline.

## Prerequisites

1. Set up a Quobyte cluster with four core service nodes. Every node should run Quobyte core services (data, metadata, registry) as well as 
API-Service, Webui-Service and Quobyte clients.

2. Add three data nodes to the cluster.
Each data node should have at least two storage devices available for Quobyte.

3. Add two client nodes to the cluster.
The client nodes do not need any storage devices. Only the native Quobyte client needs to be installed.

4. Set up one volume named "testvolume" either via web-ui or CLI. 
5. All alerts in the Quobyte cluster should be solved.

6. For better observability a Prometheus instance should be attached to the cluster.

## Let there be load

### Client load A

Head over to one of your two clients.

#### Small file, metadata-centric 

```
$ sudo -i
$ cd /quobyte/testvolume
$ wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.10.tar.xz; while true; do time tar -xJf linux-5.10.tar.xz; time rm -r linux-5.10; done  
```

### Client load B
Head over to the other one of your two clients.

#### Large file, throughput-centric

```
$ sudo -i
$ cd /quobyte/testvolume
$ while true; do dd if=/dev/zero of=testfile bs=1M count=30000 status=progress; rm testfile; done
```

### Observe cluster results

On one of the core nodes follow the logs for all quobyte services:

```
$ journalctl -f SOFTWARE=quobyte
```

## Expected results

* The cluster should perform stable throughout the two load scenarios running.

## Questions

* Up to which percentage capacity usage does the storage system perform well?
* How could you avoid a "Volume "My Tenant/test" can no longer create files, because there are not enough suitable devices." alert?
--> write a policy that uses all available devices for large file placement.


## clean up

1. Remove files in testvolume
2. Run a scrub task.


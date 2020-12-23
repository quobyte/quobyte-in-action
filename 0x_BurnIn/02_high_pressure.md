# High Pressure

In this scenario we will put load on the cluster by starting many clients with a primitive write workload.
These parallel writes can be stepped up until the cluster brakes; so we know our limits.

## Prerequisites

1. Set up a Quobyte cluster with four core service nodes. Every node should run Quobyte core services (data, metadata, registry) as well as 
API-Service, Webui-Service and Quobyte clients.

2. Add three data nodes to the cluster.
Each data node should have at least two storage devices available for Quobyte.

3. Add one client node to the cluster.
The client nodes do not need any storage devices. Only the native Quobyte client needs to be installed.

4. Set up one volume named "testvolume" either via web-ui or CLI. 
5. All alerts in the Quobyte cluster should be solved.

6. For better observability a Prometheus instance should be attached to the cluster.

## Let there be load

Get a mount command for the volume "testvolume" from the web ui by clicking on the volume and copy the mount command.
Connect to the client node and perform the tests from there.
Use the mount.quobyte command you copied, not the one from the code snippet.

```
$ export upperLmit=6
$ for i in $(seq 0 $upperLimit); do mkdir test-${i}; done
$ for i in $(seq 0 $upperLimit); do mount.quobyte mount.quobyte 10.138.0.31,10.138.0.41,10.138.0.29/testvolume test-${i}; done 
$ while true; do for i in $(seq 0 $upperLimit); do dd if=/dev/zero of=test-${i}/testfile${i} bs=1M count=5; done; done
```

This test will perform parallel mounts and writes. Optionally you can perform these tests from different nodes and compare the effects on the storage network and maybe performance.



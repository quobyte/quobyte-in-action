# Create and controll storage classes

In this chapter we will see how to create different storage classes and consume them via Kubernetes.

## Prerequisites

We assume that you did the steps from chapter #1 and have the following resources set up and working:

1. A Quoybte cluster in version 3.x 
2. A Kubernetes cluster with quobyte-clients + quobyte-csi plugin installed.

Everything should be checked and it should already be verified that you have one working storage class
that enables you to create persistent volume claims (PVC).

## Get started


### Create a new storage class
As a first step we will create a new storage class in Kubernetes:

```
[jan@jan quobyte-k8s-helm]$ cat exampleStorageClass.yaml 
allowVolumeExpansion: true
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: quobyte-silver
parameters:
  accessMode: "770"
  createQuota: "true"
  csi.storage.k8s.io/controller-expand-secret-name: quobyte-admin-secret
  csi.storage.k8s.io/controller-expand-secret-namespace: default
  csi.storage.k8s.io/provisioner-secret-name: quobyte-admin-secret
  csi.storage.k8s.io/provisioner-secret-namespace: default
  group: root
  quobyteConfig: BASE
  quobyteTenant: My Tenant
  user: root
  labels: "mediatype:hdd"
provisioner: csi.quobyte.com
```

The trick here is to create labels. With these labels it is possible to assign policies in Quobyte which in turn control every 
aspect of storage later on in Quobyte.
The idea behind this storage class is to have a cheap HDD medium with no special performance requirements (thus: "mediatype:hdd").

### Test storage class by applying a pvc

To see what happens we create a pvc:

```
[jan@jan quobyte-k8s-helm]$ cat example-pvc-silver.yaml 

kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: quobyte-csi-test-silver
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: quobyte-silver
```
Apply it via kubectl:

```
kubectl apply -f example-pvc-silver.yaml
```

## Quobyte point of view

Lets switch to our storage cluster to see what happened:

```
deploy@smallscale-coreserver0:~$ qmgmt volume list
Name                                      Tenant     Logical Usage  File Count  Configuration  S3 buckets  Mirrored From  /     
pvc-5e148c54-d9e7-4975-833e-a88501fa825b  My Tenant  0 bytes        -           BASE           -           -              -     
pvc-8da51d22-2400-49d3-ba73-dfdc4e97b8be  My Tenant  0 bytes        -           BASE           -           -              -

deploy@smallscale-coreserver0:~$ qmgmt volume show pvc-5e148c54-d9e7-4975-833e-a88501fa825b
pvc-5e148c54-d9e7-4975-833e-a88501fa825b
  uuid:                        06ce8833-c7d5-41a2-a85f-827f753a50a5
  configuration:               BASE
  tenant:                      8f5212eb-a57c-4c7a-86c5-901c127b4386
  disk used:                   0 bytes
  files:                       0
  directories:                 1
  metadata devices:            [6, *10, 8]
  preferred primary device:    10
  last successful scrub:       12/07/20 10:30:04
  last access:                 never
  labels:
     mediatype = hdd

```

Until now these labels don't have any meaning to Quobyte, there needs to be a rule that interpretes these labels. This work can be done using the Quobyte policy engine.
So let's have a look what is there:

```
deploy@smallscale-coreserver0:~$ qmgmt policy-rule list
Enabled?  Name                                        Creator  Description                                                            
True      Automatic data replication                  Quobyte  Automatically enables data replication when there are enough data devices provisioned. 
True      Automatic metadata replication              Quobyte  Automatically enables metadata replication when there are enough metadata devices provisioned. 
True      File IO default policies                    Quobyte  Immutable fall-back policies that apply to operations on file data.    
True      File layout default policies                Quobyte  Immutable fall-back policies that govern the physical layout of files. 
True      File placement default policies             Quobyte  Immutable fall-back policies that govern where to place file parts.    
True      Volume default policies                     Quobyte  Immutable fall-back policies that govern volume access, encryption, snapshot & caching behavior. 
True      Volume metadata placement default policies  Quobyte  Immutable fall-back policies that govern metadata databases.
```

Now let's create a new policy that enforces our rules:

```
deploy@smallscale-coreserver0:~$ cat quobyte-silver.txt 
policy_rule {
  name: "Kubernetes Silver"
  description: "Place files only on cheap HDDs if volume labels say so."
  creator: "jan-quobyte"
  enabled: true
  scope {
    volume {
      label_pattern {
        name_regex: "mediatype"
        value_regex: "hdd"
      }
    }
    files_operator: ALL_OF
  }
  policies {
    file_tag_based_placement {
      required_tag: "hdd"
    }
  }
}
deploy@smallscale-coreserver0:~$ qmgmt policy-rule import quobyte-silver.txt 
Success. Imported policy rules.

```

## Verification of our new policy

Now let's see what happens if we have a cluster with a suitable storage class and create a new volume with a respecting storage class. 

Let's again do a PVC using this storage-class:

```
kubectl apply -f example-pvc-silver.yaml
```
 
Let's verify it is bound:

```
[jan@jan quobyte-k8s-helm]$ kubectl get pvc
NAME                      STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS     AGE
quobyte-csi-test-silver   Bound    pvc-a56ac7ee-2066-4080-a288-46c731cffe0b   1Gi        RWO            quobyte-silver   4s
```
And finally let's use consume it from within a pod:

```
[jan@jan quobyte-k8s-helm]$ kubectl apply -f examplepod.yaml 
pod/nginx-dynamic-vol configured
[jan@jan quobyte-k8s-helm]$ kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
nginx-dynamic-vol         1/1     Running   0          79m
quobyte-client-ds-95hl4   1/1     Running   0          74s
quobyte-client-ds-hgfc4   1/1     Running   0          54s
quobyte-client-ds-jpqjn   1/1     Running   0          114s
[jan@jan quobyte-k8s-helm]$ kubectl exec -it pod/nginx-dynamic-vol -- /bin/bash
root@nginx-dynamic-vol:/# df -h
Filesystem                                                  Size  Used Avail Use% Mounted on
overlay                                                      95G  3.2G   92G   4% /
tmpfs                                                        64M     0   64M   0% /dev
tmpfs                                                       1.9G     0  1.9G   0% /sys/fs/cgroup
/dev/sda1                                                    95G  3.2G   92G   4% /etc/hosts
shm                                                          64M     0   64M   0% /dev/shm
quobyte@10.138.0.54|10.138.15.192|10.138.0.55|10.138.0.57/  1.0G     0  1.0G   0% /usr/share/nginx/html
tmpfs                                                       1.9G   12K  1.9G   1% /run/secrets/kubernetes.io/serviceaccount
tmpfs                                                       1.9G     0  1.9G   0% /proc/acpi
tmpfs                                                       1.9G     0  1.9G   0% /proc/scsi
tmpfs                                                       1.9G     0  1.9G   0% /sys/firmware
root@nginx-dynamic-vol:/# cd /usr/share/nginx/html/
root@nginx-dynamic-vol:/usr/share/nginx/html# ls
root@nginx-dynamic-vol:/usr/share/nginx/html# echo "Quobyte was here" > index.html
root@nginx-dynamic-vol:/usr/share/nginx/html# ls -l
total 1
-rw-r--r-- 1 root root 17 Dec  7 12:49 index.html

```

## Again: Quobyte point of view

Now let's switch back to the Quobyte point of view and inspect everything that happened on the cluster.

Quobyte did an automatic mount of the fresh created volume under /quobyte. This allows us, to inspect content 
that was created in Kubernetes:

```
deploy@smallscale-coreserver0:~$ sudo -i
root@smallscale-coreserver0:~# cd /quobyte/pvc-a56ac7ee-2066-4080-a288-46c731cffe0b/
root@smallscale-coreserver0:/quobyte/pvc-a56ac7ee-2066-4080-a288-46c731cffe0b# ls
index.html
root@smallscale-coreserver0:/quobyte/pvc-a56ac7ee-2066-4080-a288-46c731cffe0b# cat index.html 
Quobyte was here
root@smallscale-coreserver0:/quobyte/pvc-a56ac7ee-2066-4080-a288-46c731cffe0b# 
```

But further more we can finally proof that our file was written to HDD using the Quobyte-Client tool "qinfo":

```
root@smallscale-coreserver0:/quobyte/pvc-4f5b2b86-cd37-461c-8f7d-3d824e52fc21# qinfo info index.html 
posix_attrs {
  id: 8
  owner: "root"
  group: "root"
  mode: 33188
  atime: 1607346923
  ctime: 1607346923
  mtime: 1607346923
  size: 17
  nlinks: 1
  crtime: 1607346923
  allocated_bytes: 17
  physical_bytes: 51
}
system_attrs {
  truncate_epoch: 0
  issued_truncate_epoch: 0
  immutable: false
  windows_attributes: 0
  allocated_size_record {
    device_class: HDD
    allocated_size_in_bytes: 17
    physical_size_in_bytes: 51
  }
}
storage_layout {
  on_disk_format {
    block_size_bytes: 4096
    object_size_bytes: 8388608
    crc_method: CRC_32_ISCSI
    persistent_format: V2_METADATA_HEADER_4K
  }
  distribution {
    data_stripe_count: 1
    coding_method: NONE
    striping_method: OBJECT_LEVEL
  }
  replication_factor: 3
}
file_name: "index.html"
parent_file_id: 1
file_retention_lock {
  retention_flags: 0
  retention_timestamp_s: 0
}
segment_creation_parameters {
}
created_at_snapshot_version: 1
segment {
  start_offset: 0
  length: 10737418240
  stripe {
    version: 1
    device_id: 16
    device_id: 5
    device_id: 7
  }
  effective_failure_domain_spread: MACHINE
}
version: 1

No erasure coded file. Information not available.
```

Èt voila: the device class is now HDD

Working through the same steps we can now create policies /storage classes for SSD-Only access, with extra-striping, no replication at all etc.

One hint: It might be easier to create policy rules using the webconsole-ui and export them later to have them under version control. This 
HowTo was using only the CLI to have a consistent way.






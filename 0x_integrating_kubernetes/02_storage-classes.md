# Create and controll storage classes

In this chapter we will see how to create different storage classes and consume them via Kubernetes.

## Prerequisites

We assume that you did the steps from chapter #1 and have the following resources set up and working:

1. A Quoybte cluster in version 3.x 
2. A Kubernetes cluster with quobyte-clients + quobyte-csi plugin installed.

Everything should be checked and it should already be verified that you have one working storage class
that enables you to create persisten volume claims (PVC).

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
The idea behing this storage class is to have a cheap HDD medium with no special performance requirements (thus: "mediatype:hdd").

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


 



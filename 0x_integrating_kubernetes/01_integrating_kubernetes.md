# Integrating Kubernetes

This example shows how to connect a k8s cluster to a Quobyte sotrage cluster 
and uses it for dynamic provisioning of volumes.

This example does not assume that your Quobyte cluster runs on Kubernetes; although 
this would be an option. For today we are just having a look from a "consumer" point of 
view; totally agnostic of where and how the Quobyte cluster is running.


## Preaparations

we start with a freshly created k8s cluster: 

# Kubernetes:

```
[jan@jan quobyte-k8s-helm]$ kubectl get nodes
NAME                                    STATUS   ROLES    AGE   VERSION
gke-bbtest-default-pool-dcc88ad3-mr6m   Ready    <none>   62s   v1.16.15-gke.4300
gke-bbtest-default-pool-dcc88ad3-pn68   Ready    <none>   62s   v1.16.15-gke.4300
gke-bbtest-default-pool-dcc88ad3-t6f8   Ready    <none>   61s   v1.16.15-gke.4300
```

# Quobyte Cluster

On the other hand we need a Quoybte Cluster to connect to. The Free Edition is totally 
sufficient; you can follow the instructions on the Quobyte website to set up a cluster.

We need some informations to configure the Quobyte Helm chart to connect successfully to our Quobyte cluster:

1. Quobyte API endpoint address
2. All the registry addresses
3. A valid pair of Quobyte credentials (username/ password in this example)


## Fetch API service overview
```
deploy@smallscale-coreserver0:~$ qmgmt service list | grep AP
smallscale-coreserver0.c.quobyte-eng.internal  API Proxy (A)  316ce70a-3838-4872-95aa-5ff546a0f5c8  *             
smallscale-coreserver1.c.quobyte-eng.internal  API Proxy (A)  8e953778-670d-4871-bc91-b5ce0a011257  *             
smallscale-coreserver2.c.quobyte-eng.internal  API Proxy (A)  7c59eed9-3716-4f8f-89ef-38db3cef21a7  *             
smallscale-coreserver3.c.quobyte-eng.internal  API Proxy (A)  d2496866-3744-4170-8675-061024a6f377  *  
```

## Get registry addresses

```
deploy@smallscale-coreserver0:~$ grep ^registry /etc/quobyte/host.cfg 
registry=10.138.0.43,10.138.0.45,10.138.0.46,10.138.0.49
```
We have a Quobyte cluster with four nodes, the registry and also the API service running potentially on all of them.

## Create a dedicated Quobyte user for Kubernetes

```
deploy@smallscale-coreserver0:~$ qmgmt user config add jan-kubernaut jan.peschke@quobyte.com SUPER_USER password change-me_later
Success. Added user 'jan-kubernaut'
```

Remark: With a full licensed Quobyte version you could now benefit from different roles/ true multi tenancy; this is skipped here 
in falvor of being able to replay this story with the Free Edition of Quobyte.

# Kubernetes Cluster

Now switch to the Kubernetes point of view.

We assume that kubectl is working and also Helm is installed and usable.

1. Check out the Quobyte Helm chart:

```
$ git clone https://github.com/quobyte/quobyte-k8s-helm.git
$ cd quobyte-k8s-helm
```

2. Modify "values.yaml" to *not* install the Quobyte cluster into our k8s cluster


3. Encode secret + username to base64:

```
[jan@jan quobyte-k8s-helm]$ echo -n "change-me_later" | base64 
Y2hhbmdlLW1lX2xhdGVy
[jan@jan quobyte-k8s-helm]$ echo -n "jan-kubernaut" | base64 
amFuLWt1YmVybmF1dA==
```

...and put these credentials also into values.yaml

```
[jan@jan quobyte-k8s-helm]$ vi values.yaml 
[jan@jan quobyte-k8s-helm]$ cat values.yaml 
# Enables the Quobyte CSI plugin if set to true.
# Please configure the CSI plugin in charts/quobyte-csi/values.yaml
csi_enabled: true

# Enables automatic Quobyte client deployments if set to true.
# Must be enabled and configured when using the CSI plugin.
# Please configure in charts/quobyte-client/values.yaml
client_enabled: true 

# Enables the provisioning of Quobyte services if set to true.
# Please consult the readme for requirements for running
# the Quobyte services on Kubernetes.
# Please configure in charts/quobyte-core/values.yaml
core_enabled: false 

# configure client:
#
quobyte-client:
  quobyte:
    clientImage: gcr.io/eda-eval/quobyte-client:3.0.pre8
    registry: 10.138.0.43,10.138.0.45,10.138.0.46,10.138.0.49 

# configure CSI plugin:
#
quobyte-csi:
  quobyte: 
    quobyteTenant: "My Tenant"
    quobyteUser: amFuLWt1YmVybmF1dA== 
    quobytePassword: Y2hhbmdlLW1lX2xhdGVy 
    apiURL: http://10.138.0.43:7860

```

After the values.yaml looks like the one above it is time to install the helm chart:


```
$ helm install client-and-csi . -f values.yaml --debug
```

## Verification

We can now veriffy that we have a setup without any recent restarting pods:

```
[jan@jan quobyte-k8s-helm]$ kubectl get pods -A
NAMESPACE     NAME                                                        READY   STATUS    RESTARTS   AGE
default       quobyte-client-ds-5bj8x                                     1/1     Running   0          2m34s
default       quobyte-client-ds-f9xbr                                     1/1     Running   0          2m34s
default       quobyte-client-ds-qjnqc                                     1/1     Running   0          2m34s
kube-system   event-exporter-gke-77cccd97c6-6qctn                         2/2     Running   0          67m
kube-system   fluentd-gke-95bsm                                           2/2     Running   0          65m
kube-system   fluentd-gke-lhwkf                                           2/2     Running   0          65m
kube-system   fluentd-gke-scaler-54796dcbf7-mz99l                         1/1     Running   0          67m
kube-system   fluentd-gke-wzdqg                                           2/2     Running   0          66m
kube-system   gke-metrics-agent-59rbs                                     1/1     Running   0          67m
kube-system   gke-metrics-agent-5ps8j                                     1/1     Running   0          67m
kube-system   gke-metrics-agent-dwlmp                                     1/1     Running   0          67m
kube-system   kube-dns-7bb4975665-j2fqx                                   4/4     Running   0          67m
kube-system   kube-dns-7bb4975665-l58d6                                   4/4     Running   0          67m
kube-system   kube-dns-autoscaler-645f7d66cf-r2h49                        1/1     Running   0          67m
kube-system   kube-proxy-gke-bbtest-default-pool-dcc88ad3-mr6m            1/1     Running   0          67m
kube-system   kube-proxy-gke-bbtest-default-pool-dcc88ad3-pn68            1/1     Running   0          67m
kube-system   kube-proxy-gke-bbtest-default-pool-dcc88ad3-t6f8            1/1     Running   0          67m
kube-system   l7-default-backend-678889f899-t4nz7                         1/1     Running   0          67m
kube-system   metrics-server-v0.3.6-64655c969-k5gd9                       2/2     Running   0          67m
kube-system   prometheus-to-sd-2l4wc                                      1/1     Running   0          67m
kube-system   prometheus-to-sd-rw296                                      1/1     Running   0          67m
kube-system   prometheus-to-sd-w429c                                      1/1     Running   0          67m
kube-system   quobyte-csi-controller-csi-quobyte-com-0                    5/5     Running   0          2m34s
kube-system   quobyte-csi-node-csi-quobyte-com-4l47v                      2/2     Running   0          2m34s
kube-system   quobyte-csi-node-csi-quobyte-com-gj5dq                      2/2     Running   0          2m34s
kube-system   quobyte-csi-node-csi-quobyte-com-gjnsx                      2/2     Running   0          2m34s
kube-system   stackdriver-metadata-agent-cluster-level-756cbb8bb5-f7999   2/2     Running   1          67m
```

Any csi- and quobyte-client pods should run without any errors.

Let's check that we have at least one storageClass available that points to our Quobyte cluster:

```
[jan@jan quobyte-k8s-helm]$ kubectl get storageclasses
NAME                 PROVISIONER            AGE
quobyte-rf3          csi.quobyte.com        99s
standard (default)   kubernetes.io/gce-pd   75m
[jan@jan quobyte-k8s-helm]$ kubectl describe storageclass quobyte-rf3
Name:                  quobyte-rf3
IsDefaultClass:        No
Annotations:           meta.helm.sh/release-name=client-and-csi,meta.helm.sh/release-namespace=default
Provisioner:           csi.quobyte.com
Parameters:            accessMode=770,createQuota=true,csi.storage.k8s.io/controller-expand-secret-name=quobyte-admin-secret,csi.storage.k8s.io/controller-expand-secret-namespace=default,csi.storage.k8s.io/provisioner-secret-name=quobyte-admin-secret,csi.storage.k8s.io/provisioner-secret-namespace=default,group=root,quobyteConfig=BASE,quobyteTenant=My Tenant,user=root
AllowVolumeExpansion:  True
MountOptions:          <none>
ReclaimPolicy:         Retain
VolumeBindingMode:     Immediate
Events:                <none>
```

## Go!Go!Go!

Create an example PVC to see if claiming works:

```
[jan@jan quobyte-k8s-helm]$ cat example-pvc.yaml 

kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: quobyte-csi-test
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: quobyte-rf3
```
And apply it to your Kubernetes cluster:

```
n@jan quobyte-k8s-helm]$ kubectl apply -f example-pvc.yaml 
persistentvolumeclaim/quobyte-csi-test created
[jan@jan quobyte-k8s-helm]$ kubectl get pvc
NAME               STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
quobyte-csi-test   Bound    pvc-8da51d22-2400-49d3-ba73-dfdc4e97b8be   1Gi        RWO            quobyte-rf3    7s
[jan@jan quobyte-k8s-helm]$ kubectl apply -f example-pvc.yaml 
```

## Quobyte view:

Switch back to your storage cluster and see what happened:

```
deploy@smallscale-coreserver0:~$ qmgmt volume list
WARNING: Existing session cookie was no longer valid and had to be deleted.
WARNING: Could not fetch credentials from environment 
Username: jan-quobyte
Password: 
Name                                      Tenant     Logical Usage  File Count  Configuration  S3 buckets  Mirrored From  /     
pvc-8da51d22-2400-49d3-ba73-dfdc4e97b8be  My Tenant  0 bytes        -           BASE           -           -              -
```

As you can see the Volume is getting created and usable from Kubernetes now!

In the next chapter we will show how to create and control different storage classes.



todo: create a service for all API endpoints to balance them.




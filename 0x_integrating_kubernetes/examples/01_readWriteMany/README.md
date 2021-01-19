# Scaling of user generated content

This example shows how you can solve a common problem that arises around
"user generated content". 

If you scale out applications this works pretty well for stateless applications: 
You just double the number of running pods.
It gets more complicated if these pods should deliver content: You then need persistent 
storage that is attached to these pods. Usually a persistent volume in a Kubernetes world.

This solves the problem of scaling content: You just attach a copy of your content to your 
running pod. 
But what happens if that content changes on one of your pods? How do you 
distribute the newly generated/ changed content to the other instances serving your application?

Different strategies could apply: One common strategy is to have special entry points to a web application, for example
http://my.business-site.com/adminpanel.
This URL is then routed to some special instance and from that instance content is periodically distributed to your
scale-out application layer. This works pretty well with applications where only a small team is generating content, 
for example the editorial staff of a news site.
But what happens if your user base is interacting dynamically with your application, for example by uploading images?

This approach does not work anymore, because you cannot scale out this /adminpanel.

This is where traditional approaches do a simple trick: They attach one volume to many pods. So all the pods now 
write their content to one volume; any delivered content is always up to date.
As an "Service Architect" you are done: The problem is moved successfully from your desk to the storage team.

Because you will need a special storage class capability for that: ReadWriteMany. The default storageclasse from a default Cloud provider 
will simply deny it with a message like this:

```
  Warning  ProvisioningFailed  13s (x2 over 21s)  persistentvolume-controller  Failed to provision volume with StorageClass "standard": invalid AccessModes [ReadWriteMany]: only AccessModes [ReadWriteOnce ReadOnlyMany] are supported
```

Damn! The problem is back on your desk. If you ask now your provider for a solution they usually come up with an approach using some form of NFS. You can follow this approach, your 
application/ pods will start and you are done. 
But then real life kicks in: If you have significant load on the storage part of your application stack (think of many users start to use 
your photo upload service) everything gets terribly slow. Why? The approach of NFS is usually to provide access to files through one single IP address. 
Think of it as the following:

```
	pod1 pod2 pod3
	 \     |    /
	  \    |   /
	 NFS-EntryPoint
	 (one IP address)
```

In other words: Your bottleneck has moved again to a system, where every request has to traversal one single entry point of a storage system. 
So how do you really scale out your storage layer? Qoubyte offers a scalable approach for a mapping between clients and dataservices for that:

```
	pod1 	pod2 	pod3
	|     	 |    	 |
	|     	 |    	 |
	|     	 |    	 |
	ds1 	ds2	ds3

(ds* == Quobyte data service)

```
Since Quobyte is a truly distributed file system each client (pod worker node) can talk to each dataservice. So if you need more pods accessing the storage system, you can simply scale out Quobyte data services
From a Kubernetes point of view it adds no complexity to your setup: Service discovery/ service delegation (which pod should talk to which data service?) is solved by the Quobyte registry service.

Èt voila: Now you have a setup where each layer of resource consumption can be scaled individually.

Code contained in this chapter will give you a practical demonstration using wordpress as an example.

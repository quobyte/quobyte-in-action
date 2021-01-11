# Adding disks to a Quoybte cluster

If you add disks to a Quobyte system two things have to happen:

* They are added to the storage system (as physical devices to a server or as virtual devices)
* A human/ storage admin has to decide, if disks should serve as data devices, registry devices or metadata devices.

## Example: add additional disks on Google cloud

To see how these steps work we simply attach another disk to an existing server. Using gcloud you can achieve this 
with the following command:

```
$ gcloud compute disks create --zone us-west1-a --type pd-standard --size 1000G realbigdisk
$ gcloud compute instances attach-disk smallscale-coreserver2  --disk realbigdisk --zone us-west1-a  
```

This is the equivalent to putting another disk into a physical server.

## Using a new disk

The easiest way to [add a new disk](https://support.quobyte.com/docs/16/latest/installation_devices.html) to Quobyte is to use 
the context menu in the web ui. Navigate to "Devices", watch out for "Unformatted devices" and select the context menu ("three dots"). Choosing "Make Quobyte device" 
 you can decide if this disk should serve as a data, registry or metadata device.

In our example we want an additional data disk, so we select "data" and press "Start Task".

That is all there is to do to integrate new devices into Quobyte.

![Screenshot](adding_disks.png)


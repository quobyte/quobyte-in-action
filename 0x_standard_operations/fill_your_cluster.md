# Fill your cluster with data

Usually you have to migrate files after setting up your new cluster. 
A usual thing to start with would be rsync. While that is a really good general purpose
sync tool there is also qcopy. Qcopy comes with a default Quobyte installation and has the following 
advantages:

* full parallelism.
* faster syncing small files.

It should also be mentioned that qcopy does not have a security layer that rsync provides. So it should be 
used only in trusted environments.

## Usage

```
$ qcopy <src_dir> <registryOne>,<registryTwo>,<registryN>:/<quobyteVolumeName>/
```



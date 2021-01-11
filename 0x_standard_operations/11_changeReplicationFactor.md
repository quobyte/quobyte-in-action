# Change file replication factor for existing files

Sometimes it is necessary to change file placement/ replication factor for existing files.  

Standard behaviour in Quoybte is that changed placement policies will be applied to 
newly created files since the file layout is set at file creation time.


## Change extended Quobyte file attributes

If you want to reniew your files placement according to new rules you can do so by setting extended attributes:

```
$ sudo setfattr -n quobyte.target_replication_factor -v 3 test
```

If this setting is done for all your files you can start an "enforce placement" task to apply 
the defined rules. 

If you inspect your files with "qinfo info <fileName> you will see the difference:

## Before:

```
$ qinfo info <fileName>
.
.
.
segment {
  start_offset: 0
  length: 10737418240
  stripe {
    version: 1
    device_id: 5
  }
  effective_failure_domain_spread: MACHINE
}
.
.
.
```

## After:

```
$ qinfo info <fileName>
.
.
.
segment {
  start_offset: 0
  length: 10737418240
  stripe {
    version: 3
    device_id: 11
    device_id: 5
    device_id: 16
  }
  effective_failure_domain_spread: MACHINE
}
.
.
.
```


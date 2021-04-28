# Quobyte Data Mover

The Quoybte Data Mover is a tool to submit file copy jobs against the Quobyte API. 
These copy tasks can copy data within one Quoybte installation as well as accross 
Quobyte installations. 
The definitions of these jobs can include filter lists which result in just copying 
certain files. Filters can evaluate file attributes like file age or size.
Usage of this tool enables you to do parallelly executed file copies (i.e. throughput optimized) 
either event triggered or by schedule.
You can use it to schedule backups from one installation to another, do for example recodings from replication 
to erasure coding or use it for any other thing where copying files in a defined manner makes sense.

To define a copy job task you need three pieces of information: 

1. The registry address of the target installation (if target is a remote cluster)
2. The volume UUID of the source volume
3. The volume UUID of the target volume


## Example job definition

```
job: {
  source: {
    quobyte: {
      volume: "0c4b1be1-0b11-475f-a0dc-2bb02f5c1555"
    }
  }
  destination: {
    quobyte: {
      volume: "db242b0b-44da-41ae-87c0-ce2427d09c17"
      registry: "remote-quobyte-cluster.mycompany.tld"
    }
  }
  filter: {
    type: LAST_MODIFICATION_AGE_S
    operator: SMALLER_THAN
    value: 3600
  }
}
```

This job can then be scheduled with 

```
qmgmt files copy <jobDefinitionFile>

# Documentation:
https://support.quobyte.com/docs/16/latest/data_mover.html



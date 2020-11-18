
# raw:
sum(device:capacity{service_type="quobyte-data", device_hardware_type="HDD"})

sum(device:capacity{device_hardware_type="SSD"})

sum(device:usage{device_hardware_type="SSD"})

sum(device:usage{device_hardware_type="HDD"})


# disk free:
sum(device:capacity{device_hardware_type="SSD", service_type="quobyte-data"}) - sum(device:usage{device_hardware_type="SSD", service_type="quobyte-data"})


# mem free/ memory pressure:
server:memory_free{service_type="quobyte-data"}
sum(server:memory_free{service_type="quobyte-data"})

## what does the client do with memory?
rate(service:memory_read_bytes{service_type="quobyte-client"}[5m])
rate(service:memory_written_bytes{service_type="quobyte-client"}[5m])


## which service is consuming what?
service:memory_rss{service_type="quobyte-registry"}
service:memory_rss{service_type="quobyte-metadata"}
service:memory_rss{service_type="quobyte-data"}
service:memory_rss{service_type="quobyte-webconsole"}
service:memory_rss{service_type="quobyte-api"}

# did I tune my system well enough?
service:max_open_files{service_type="quobyte-data"}


# file writes:

rate(client:file:write_operations[5m])

# wie lange dauert mein delete denn noch?

client:file:deletes_in_flight

# what *is* my workload?
client:file:current_random
vs. 
client:file:current_sequential
vs. 
client:file:current_undecided

# do I use caching?
rate(client:cache:allocation_size_sum[5m])

# unknown. maybe latency?

rate(data:io_executor:scheduling_latency_count[1m])

# metadata utilization:
metadata:operations_in_flight

# shall I buy faster metadata devices?

rate(lowlevel:metadata:write:latency_sum[5m])

## why shall I buy faster metadata devices?
rate(lowlevel:metadata:write:latency_bucket[1m])
vs.
rate(lowlevel:metadata:read:latency_bucket[1m])

# shall I buy faster data disks?
rate(data:io_executor:scheduling_latency_bucket{service_type="quobyte-data"}[2m])

# replication traffic:
data:replication_operations_in_flight

# is there *any* bottleneck?
data:service_operations_in_flight

metadata:operations_in_flight

# was geht in meinem Cluster? Wird gelesen, geschreiben oder was anderes?
sum by (op) (data:service_operations_in_flight)


# is my registry performing well?
rate(client:resolve_name_latency_bucket[2m])
rate(client:resolve_name_latency_bucket{service_type="quobyte-client"}[5m])

# throughput
rate(osd:write:size_bucket[5m]) ???
rate(osd:read:size_bucket[5m]) ???
## client point of view:
### throughput
rate(client:read:size_sum[5m]) 
### IOPs
rate(client:read:size_count[5m]) 

# Open files / show parallelism?
files:current_open_files



# is my cluster big enough to replicate?
policies:automatic:volume_metadata_replication_factor
## enough SSDs?
policies:automatic:replicated_files_replication_factor_ssd
## ennough HDDs?
policies:automatic:replicated_files_replication_factor_hdd

## problems coming from concurrent file access:
client:cache:blocked_waiting_for_same_block_direct_io





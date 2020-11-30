# Standard Operations

See also 

## Updating a cluster
* https://support.quobyte.com/docs/16/latest/runbook_duties.html

## Reacting on incidents
* https://support.quobyte.com/docs/16/latest/runbook_incidents.html

# Change a setup
* https://support.quobyte.com/docs/16/latest/runbook_tasks.html

Registry failover/ behaviour:

Robert:

"Clients do not learn the registry replica set. They rely on what they are started with. In case of a failover it skips through its list of registries until a the primary is found. Backup registries respond with RETRY_OTHER_IMMEDIATLY while cold spares respond with UNKOWN_RPC_TARGETS. This is not specific to the registry but any database. When it comes to metadata failover, the error code UNKNOWN_RPC_TARGET tells the client that the resolved endpoints are no longer valid. Hence, it will re-resolve the volume target to get the latest replica set."



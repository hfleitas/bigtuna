# Fabric RTI (Azure SQL Database CDC)
Scripts and items to migrate data from Azure SQL Database via CDC (Change Data Capture) connector in Fabric Real-Time Intelligence. 

## Goal 
Consolidate multiple sql tables of same schemas or different, ie. one-per-region, by landing them into a single table in Fabric. 

## Steps 
1. Run [EnableCDC.sql](EnableCDC.sql)
2. Setup Fabric RTI Eventstream.
3. Run [DMLChanges.sql](DMLChanges.sql)
4. Run [Transformations.kql](Transformations.kql)


### Eventstream ⚡
1. Notice you can specificy the workspace and name the eventstream item.
   - ![EventstreamConnectSource.png](assets/EventstreamConnectSource.png "Eventstream Connect Datasource")
3. Scroll down to click Next, Connect and Open Eventstream.
4. Add the destination (ie. Eventhouse, Lakehouse or Reflex). Here we'll cover eventhouse for minimal-latency and because the cdc stream is time-bound, but this may vary based on business needs and workload.
   - ![EventstreamDestination.png](assets/EventstreamDestination.png "Eventstream Desination")
   - Screenshot above uses:
     - Source: 2 tables of different schemas and volumes. One with a Clustered Primary Key and the other table is a heap without any indexes.
     - Destination: Direct Ingestion to Eventhouse, which means Eventhouse uses pull method from Eventstream via table batching policy config.
     - Transformations: Done in Eventhouse via step 3, ie. KQL Update Policy and/or Materialized-views.

### Event Recommendations
- Normally the CDC data doesn't have high [throughput](https://learn.microsoft.com/fabric/real-time-intelligence/event-streams/configure-settings#event-throughput-setting), getting all tables' cdc into one Eventstream should be OK. 
- Regarding when to flatten or split the data, the proper approach is related to the business purpose wanted to achieve. If undecided to be split into different tables, then just sink to keep the original data without need to process inside Eventstream.
- Additional Eventstreams or transformations done up-stream such as Manage Fields, Filter and Stream Processing may incur additional CUs but allow the ability to take action over the data  in the stream by using Fabric Data Activator (Reflex).


## Thank you!
![bluefin tuna](https://upload.wikimedia.org/wikipedia/commons/7/72/Large_bluefin_tuna_on_deck.jpg "bluefin tuna")

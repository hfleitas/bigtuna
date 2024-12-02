# Fabric RTI (Azure SQL Database CDC)
Scripts and items to migrate data from Azure SQL Database via CDC (Change Data Capture) connector in Fabric Real-Time Intelligence. 

## Goal 
Consolidate multiple sql tables of same schemas or different, ie. one-per-region, by landing them into a single table in Fabric. 

## Steps 
1. Run [EnableCDC.sql](EnableCDC.sql)
2. Setup Fabric RTI Eventstream.
3. Run [DMLChanges.sql](DMLChanges.sql)
4. Run [Transformations.kql](Transformations.kql)


## Reference
###  Demo CDC ✏️ 
In Azure Data Studio connect to the demo Azure SQL Database server to run sql scripts.

Server: 
```
sqlcdc-fabric.database.windows.net
```
Database: 
```
sqlcdc-fabric
```

![AllowAzureNetwork.png](assets/AllowForFabric.png "Allow Azure Network(Fabric)")

### Eventstream ⚡
![Eventstream1.png](assets/Eventstream1.png "Eventstream Connect Datasource")
- Increase the eventstream throughput if necessary. [Learn more](https://learn.microsoft.com/fabric/real-time-intelligence/event-streams/configure-settings#event-throughput-setting)
- Create multiple Eventstreams with a subset or groups of tables (ie. 10:1), or create a single Eventstream per table depending on your evenviroment needs (1:1).
- Additional Eventstreams or transformations done up-stream such as Manage Fields, Filter and Stream Processing may incur additional CUs but allow the ability to take action over the data  in the stream by using Fabric Data Activator (Reflex).
- Screenshot above uses
  - Source: 2 tables of different schemas and volumes. One with a Clustered Primary Key and the other table is a heap without any indexes.
  - Destination: Direct Ingestion to Eventhouse, which means Eventhouse uses pull method from Eventstream via table batching policy config.
  - Transformations: Done in Eventhouse via step 3, ie. KQL Update Policy and/or Materialized-views.


## Thank you!
![bluefin tuna](https://upload.wikimedia.org/wikipedia/commons/7/72/Large_bluefin_tuna_on_deck.jpg "bluefin tuna")

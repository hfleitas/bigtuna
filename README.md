# Azure SQL Database CDC & Fabric RTI
Scripts and items to migrate data from Azure SQL Database via CDC (Change Data Capture) connector in Fabric Real-Time Intelligence. 

## Goals 🎯
- Consolidate multiple sql tables of same schemas, ie. one-per-region, by landing them into a single table in Fabric. Same design can be used for consolidating tables of different schemas. 
- Scalability.
- Simplification.
- Cost-effective & minimal-latency.

## Steps 🪜
1. Run [asqldb-cdc-setup.sql](asqldb-cdc-setup.sql).
2. Setup Fabric RTI Eventstream.
3. Run [sqlcdc-demo.kql](sqlcdc-demo.kql).
4. Try breaking the demo.


## 1. Demo CDC ✏️ 
Using SSMS or Azure Data Studio, run [asqlsdb-cdc-setup.sql](asqlsdb-cdc-setup.sql) on the demo Azure SQL Database. 

Server: 
```
sql-goderich.database.windows.net
```
Database: 
```
sqldb-goderich
```
![Demo Server.png](DemoServer.png "Demo Server")

![AllowForFabric.png](AllowForFabric.png "Allow for Fabric")


## 2. Eventstream ⚡
![Eventstream1.png](Eventstream1.png "Eventstream1")
### Considerations
- Increase throughput when necessary. [Learn more](https://learn.microsoft.com/fabric/real-time-intelligence/event-streams/configure-settings#event-throughput-setting)
- Create multiple Eventstreams with subset groups of tables or per single table depending on evenviroment needs.
- Additional Eventstreams or transformations up-stream such as Manage Fields, Filter and Stream Processing may incur additional CUs.
- Screenshot above uses
  - Source: 2 tables of different schemas and volumes. One with a Clustered Primary Key and the other table is a heap without any indexes.
  - Destination: Direct Ingestion to Eventhouse, which means Eventhouse uses pull method from Eventstream via table batching policy config.
  - Transformations: Done in Eventhouse via step 3, ie. KQL Update Policy and/or Materialized-views.


## 3. RTI Eventhouse - Transformations
Using Fabric RTI, run [sqlcdc-demo.kql](sqlcdc-demo.kql) in a KQL Queryset for the Eventhouse KQL Database set as the destination of the Eventstream.


## 4. Try breaking it! 🐟

1. Run on the demo Azure SQL Database. 
```
update SalesLT.Customer set FirstName='Big', LastName='Tuna' where CustomerID=30121;

select * from cdc.SalesLT_Customer_CT;
```

2. Add to the end of [sqlcdc-demo.kql](sqlcdc-demo.kql)
```
| where CustomerID == 30121 //or the CustomerID of the record previously inserted by the sqlcdc-demo.sql script.
| summarize arg_max(CustomerID,*)
```

## Thank you!
![bluefin tuna](https://upload.wikimedia.org/wikipedia/commons/7/72/Large_bluefin_tuna_on_deck.jpg "bluefin tuna")

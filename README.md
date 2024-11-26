# CMF - Cummins
Repo for scripts & items used by CMF team to migrate to Fabric. 

### Steps
1. [asqlsdb-cdc-setup.kql](asqlsdb-cdc-setup.sql)
2. Real-time Hub, setup eventstream.
3. [sqlcdc-demo.kql](sqlcdc-demo.kql)
4. Try breaking the demo.


### Eventstream
![Eventstream1.png](Eventstream1.png "Eventstream1")
#### Considerations
- Increase throughput when necessary. [Learn more](https://learn.microsoft.com/fabric/real-time-intelligence/event-streams/configure-settings#event-throughput-setting)
- Create multiple Eventstreams with subset groups of tables or per single table depending on evenviroment needs.
- Additional Eventstreams or transformations up-stream such as Manage Fields, Filter and Stream Processing may incur additional CUs.
- Screenshot above uses
  - Source: 2 tables of different schemas and volumes. One with a Clustered Primary Key and the other table is a heap without any indexes.
  - Destination: Direct Ingestion to Eventhouse, which means Eventhouse uses pull method from Eventstream via table batching policy config.
  - Transformations: Done in Eventhouse via step 3, ie. KQL Update Policy and/or Materialized-views.


### Demo CDC
Server: 
```
sql-goderich.database.windows.net
```
Database: 
```
sqldb-goderich
```
![Demo Instance.png](AzureSQLDatabase-TestInstance-Adventureworks_LT.png "Demo Instance")

![AllowForFabric.png](AllowForFabric.png "Allow for Fabric")


### 🐟 Try breaking it

1. Run on sql-goderich
```
update SalesLT.Customer set FirstName='Big', LastName='Tuna' where CustomerID=30121

select * from cdc.SalesLT_Customer_CT 
```

2. Add to the end of [sqlcdc-demo.kql](sqlcdc-demo.kql)
```
| where CustomerID == 30121
| summarize arg_max(CustomerID,*)
```

![bluefin tuna](https://en.wikipedia.org/wiki/Atlantic_bluefin_tuna#/media/File:Large_bluefin_tuna_on_deck.jpg "bluefin tuna")

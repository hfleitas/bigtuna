-- ref: https://learn.microsoft.com/en-us/azure/azure-sql/database/change-data-capture-overview?view=azuresql
-- This sample uses AdventureWorks_LT.


/* 1. enable cdc on database & tables*/
exec sys.sp_cdc_enable_db --system tables created along cdc schema
go
exec sys.sp_cdc_enable_table
    @source_schema = 'SalesLT',
    @source_name = 'Customer',
    @role_name=NULL --control access to change data.
go
exec sys.sp_cdc_enable_table 
    @source_schema = 'dbo',
    @source_name = 'mytable',
    @role_name=NULL
go

select name, is_cdc_enabled from sys.databases
select name, is_tracked_by_cdc from sys.tables --Fabric RTI CDC connector does NOT require enabling per table.
go

/* 2. What about heaps? */
create table mytable (col1 varchar(max), col2 datetime)
go


/* 3. Eventstream Azure SQL DB CDC data source for tables: SalesLT.Customer, dbo.mytable */ 
-- https://app.powerbi.com/workloads/oneriver/hub/NewSources?experience=kusto

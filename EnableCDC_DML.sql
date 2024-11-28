-- ref: https://learn.microsoft.com/en-us/azure/azure-sql/database/change-data-capture-overview?view=azuresql
-- This sample uses AdventureWorks_LT.


/* 1. enable cdc on database */
exec sys.sp_cdc_enable_db --system tables created along cdc schema
go

select name, is_cdc_enabled from sys.databases
select name, is_tracked_by_cdc from sys.tables --Fabric RTI CDC connector does NOT require enabling per table.
go

/* 2. What about heaps? */
create table mytable (col1 varchar(max), col2 datetime)
go


/* 3. Eventstream Azure SQL DB CDC data source for tables: SalesLT.Customer, dbo.mytable */ 
-- https://app.powerbi.com/workloads/oneriver/hub/NewSources?experience=kusto


/* 4. DML Changes */
select count(*) from SalesLT.Customer --847 rows
go 

--INSERT
insert into SalesLT.Customer (NameStyle,FirstName,LastName,PasswordHash,PasswordSalt,rowguid,ModifiedDate)
values (0, 'Orlando', 'Gee', 'L/Rlwxzp4w7RWmEgXX+/A7cXaePEPcp+KwQhl2fJL7w=', '1KjXYs4=', newid(), getutcdate())
go 3
insert into mytable (col1, col2) values ('hello', getutcdate())
go
insert into mytable (col1, col2) values ('hello cdc!', getutcdate())
go

--UPDATE
update SalesLT.Customer set FirstName='Miami' where CustomerID=30120
go
update SalesLT.Customer set FirstName='Big', LastName='Tuna' where CustomerID=30121
go
update mytable set col2=getutcdate() where col1 = 'hello cdc!'
go

--DELETE
delete from SalesLT.Customer where CustomerID in (30120,30121)
go

/* FINISHED */

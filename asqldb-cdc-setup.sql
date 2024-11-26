-- https://learn.microsoft.com/en-us/azure/azure-sql/database/change-data-capture-overview?view=azuresql
-- This sample uses AdventureWorks_LT.


/* 1. lets check if enabled */
select name, is_tracked_by_cdc from sys.tables
select name, is_cdc_enabled from sys.databases


/* 2. try enable on a table */
select * from SalesLT.Customer --847 rows

exec sys.sp_cdc_enable_db --system tables created along cdc schema
exec sys.sp_cdc_enable_table --must be enabled on the db first!
    @source_schema = 'SalesLT',
    @source_name = 'Customer',
    @role_name=NULL --control access to change data.
;

select * from cdc.captured_columns
select * from cdc.change_tables
select * from cdc.ddl_history
select * from cdc.index_columns
select * from cdc.lsn_time_mapping

select * from cdc.SalesLT_Customer_CT --one row per change of captured column.
select * from cdc.cdc_jobs --returns config of capture jobs.


/* 3. DML change */
insert into SalesLT.Customer (NameStyle,FirstName,LastName,PasswordHash,PasswordSalt,rowguid,ModifiedDate)
values (0, 'Orlando', 'Gee', 'L/Rlwxzp4w7RWmEgXX+/A7cXaePEPcp+KwQhl2fJL7w=', '1KjXYs4=', newid(), getutcdate());

select * from SalesLT.Customer where FirstName='Orlando' or FirstName='Miami'

select * from cdc.SalesLT_Customer_CT --one row per change of captured column.

update SalesLT.Customer set FirstName='Miami' where CustomerID=30120

--changes by the scheduler were successfully detected but we can also scan manually or change the retention.
exec sys.sp_cdc_scan

--exec sys.sp_cdc_change_job @job_type='cleanup', @retention=30 --minutes, default 4320 (3 days).


/* 4. What about heaps */
create table mytable (col1 varchar(max), col2 datetime);
insert into mytable (col1, col2) values ('hello', getutcdate());
exec sys.sp_cdc_enable_table --must be enabled on the db first!
    @source_schema = 'dbo',
    @source_name = 'mytable',
    @role_name=NULL --control access to change data.
;

select * from cdc.change_tables
select * from cdc.dbo_mytable_CT

insert into mytable (col1, col2) values ('hello cdc!', getutcdate())
select * from cdc.dbo_mytable_CT
update mytable set col2=getutcdate() where col1 = 'hello cdc!'
select * from cdc.dbo_mytable_CT

/* 5. Disabling */
select * from cdc.change_tables
-- disabling a table.
exec sys.sp_cdc_disable_table @source_schema='SalesLT', @source_name='Customer', @capture_instance='SalesLT_Customer'
-- disabling for the db.
exec sys.sp_cdc_disable_db --system and cdc tables gone!


/* CDC DEMO - FINISHED */
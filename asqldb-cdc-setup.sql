/* lets check if enabled */
select name, is_tracked_by_cdc from sys.tables
select name, is_cdc_enabled from sys.databases

/* try enable on a table */
select * from SalesLT.Customer --847 rows

exec sys.sp_cdc_enable_db --system tables created along cdc schema
exec sys.sp_cdc_enable_table @source_schema = 'SalesLT', @source_name = 'Customer', @role_name=NULL --must be enabled on the db first!

select * from cdc.captured_columns
select * from cdc.change_tables
select * from cdc.ddl_history
select * from cdc.index_columns
select * from cdc.lsn_time_mapping


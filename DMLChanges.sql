/* 4. DML Changes */
select count(*) from SalesLT.Customer --847 rows
go 
select count(*) from dbo.mytable --0 rows
go

--INSERT
insert into SalesLT.Customer (NameStyle,FirstName,LastName,PasswordHash,PasswordSalt,rowguid,ModifiedDate) values (0, 'Orlando', 'Gee', 'L/Rlwxzp4w7RWmEgXX+/A7cXaePEPcp+KwQhl2fJL7w=', '1KjXYs4=', newid(), getutcdate())
go 3
insert into mytable (col1, col2) values ('hello', getutcdate())
go
insert into mytable (col1, col2) values ('hello cdc!', getutcdate())
go
select * from SalesLT.Customer where CustomerID >= 30119
go
select * from mytable
go

--UPDATE
update SalesLT.Customer set FirstName='Miami' where CustomerID=30120
go
update SalesLT.Customer set FirstName='Big', LastName='Tuna' where CustomerID=30121
go
update mytable set col2=getutcdate() where col1 = 'hello fabric rti!'
go
select * from SalesLT.Customer where CustomerID >= 30119
go
select * from mytable
go

--DELETE
delete from SalesLT.Customer where CustomerID in (30120,30121)
go
delete top (1) from mytable where col1 = 'hello'
go
select * from SalesLT.Customer where CustomerID >= 30119
go
select * from mytable
go


/* FINISHED */
exec sys.sp_cdc_disable_db
go
delete from SalesLT.Customer where CustomerID>=30119
go 
drop table dbo.mytable
go 
DBCC CHECKIDENT('SalesLT.Customer',RESEED, 30118) 

begin tran
update c1 set City = 'PARIS' where CustomerID = 'ALFKI'
rollback

set statistics io on
select * from ku1 where Lastname = 'Davolio' --56034

dbcc showcontig('ku1') --40000

select * from sys.dm_db_index_physical_stats
	(db_id(),
	 object_id('ku1'),
	 NULL,
	 NULL,
	 'detailed')
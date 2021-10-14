Andreas Rauch
andreasr@ppedv.de


9:00

10:30 ..30min

12:30 Mittagsessen
13:30

15:00

17:00

-----------------------------------------


Blocks

select * into c1 from customers

begin tran 
update c1 set City = 'London'
	where CustomerID = 'ALFKI'

	select * from c1

	rollback

	select top 10 * from ku1

dbcc showcontig('ku1')

--- Gescannte Seiten.............................: 39634
alter table ku1 add id int identity
--- Gescannte Seiten.............................: 40237

set statistics io on
select * from ku1 where ID= 100

--Seiten 56034???

--Mehr Seiten als dbcc zeigt



----> weniger IO ---> weniger CPU --> weniger RAM


create table t1 (id int , sp1 char(4100), sp2 varchar(4100))

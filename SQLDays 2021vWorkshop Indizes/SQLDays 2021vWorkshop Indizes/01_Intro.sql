Andreas Rauch
andreasr@ppedv.de


9:00

10:30 ..30min

12:30 Mittagsessen
13:30

15:00

17:00

-----------------------------------------

--Indizes haben an sehr vielen Stellen Ihre Finger drin...------
--Locks, architektionische Struktur , Performance, Performanceprobleme

--Indizes beschleunigen nicht nur Abfragen (oder auch verlangsamen)
--sondern sind auch in Locks involviert...
Blocks

select * into c1 from customers

begin tran 
update c1 set City = 'London'
	where CustomerID = 'ALFKI'

	select * from c1

rollback

--Second Session
select * from c1 where customerid = 'Blaus'
--das klappt nur, wenn die Zeile duch einen Index exakt identifiert werden kann

--------------------------------------------------------------------------------
--Indizes sind auch für die physikalische Struktur der Tabelle verantwortlich
--------------------------------------------------------------------------------

select top 10 * from ku1
--Die Tabelle ku1 ist ein Heap 
--der tabelle wurde eine weitere Spalte ID int identity hinzugefügt


dbcc showcontig('ku1')
--- Gescannte Seiten.............................: 39634
alter table ku1 add id int identity
--- Gescannte Seiten.............................: 40237


set statistics io on
select * from ku1 where ID= 100

--Seiten 56034???

--Mehr Seiten als dbcc zeigt

--der Grund liegt darin , dass die neue Spalte nicht zu den DS in den Seiten hinzugefügt wurde
--sondern auf weiteren Seiten ausgelagert wurde... zudem extrem aufwendig
------------------------------------------------------------------------



--Ein Ziel der Optimierung stell die Minimierung von IO dar.
--je weniger IO, desto weniger RAM und CPU Verbrauch


----> weniger IO ---> weniger CPU --> weniger RAM

--Allerdings haben Seiten ihre Eigenheiten wie etwa
--max Anzahl an Datensätzen, Größe usw..
create table t1 (id int , sp1 char(4100), sp2 varchar(4100))

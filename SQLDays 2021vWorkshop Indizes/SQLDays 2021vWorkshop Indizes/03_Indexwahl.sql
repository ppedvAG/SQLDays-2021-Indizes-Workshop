select top 1 * from ku1

set statistics io , time on

select ID from ku1 where id = 100

--GR IX reservieren: orderdate

-- NIX_ID

select ID from ku1 where id = 100
--3 Seiten = 3 Ebenen  .. IX SEEK

select ID, freight from ku1 where id = 100
--NIX_ID SEEK.. 3 Seiten, aber mit Lookup 50% ( +1 Seite)


--NIX_ID_FR eind. nicht gr IX zusammengesetzt
select ID, freight from ku1 where id = 100

--ab 10000 ca schon Tabel Scan wg Lookup
select ID, freight, EmployeeID from ku1 where id < 9000-- 100

--theroetisch.. wir tun alle Spalten in IX rein
--NG IX hat Limits: 16 Spalten und 900 bytes Schlüsselspalten
--meist reichen 4 Spalten aus 
--in die Schlüsselspalten des Index sollten die where Spalten enthalten sein

--NIX_ID_inkl_FR_EI
select ID, freight, EmployeeID from ku1 where id <900000

--N GR IX mit eingeschlossenen Spalten eindeutig
--eingeschl Spalten können ca 1000 sein

--wenn am Ende nur ein Seek da steht.. dann hast du einen 
--abdeckenden IX
--kein Lookup.. kein SCAN


select country, city, SUM(unitprice*quantity)
from ku1
where 
		Freight < 1
group by Country , city


select freight from ku1
	where 
		city = 'London'
		AND
		EmployeeID =2

--NIX_CI_EID_inkl_FR

select freight from ku1
	where 
		city = 'London'
		OR--ab hier keine IX Vorschlag mehr
		EmployeeID =2

--2 seperate Suchen..bzw 2 IX
--NIX_CI_inkl_FR
--NIX_EID_inkl_FR

select freight from ku1
	where 
		city = 'London'
		OR
		EmployeeID =2
		AND
		CustomerID = 'ALFKI'

--SQL tut das
select freight from ku1
	where 
		city = 'London'
		OR
		(EmployeeID =2
		AND
		CustomerID = 'ALFKI')

--DEV dachte aber das:
select freight from ku1
	where 
		(city = 'London'
		OR
		EmployeeID =2)
		AND
		CustomerID = 'ALFKI'



--Klammern setzen... AND wird zuerst gebunden


--gefilterter Index.. nicht alle DS in IX rein 

select unitprice, quantity
from ku1
where
	City = 'London' and Country = 'USA'

--NIX_CICY_inkl_UPQU

--NIX_CICY_inkl_UPQU_FILTER_UK

--Gefilterte Ind nur dann, wenn es stat der umfassenen Alternative zu weniger Ebenen kommt


--ind Sicht

select country, COUNT(*) from ku1
group by country


create view v1
as
select country, COUNT(*) as Anz from ku1
group by country

select * from v1


--Die ENT Version kann der APP die Sicht unterschieben
--lohnt sicht meist nur bei berechneten Ergebnissen
--hat aber extreme Einschränkungen




ALTER view v1 with schemabinding--exakte Angabe 
as
select country, COUNT_BIG(*) as Anz from dbo.ku1
group by country



select top 3 * from ku1


--Umsatz pro Ang aus dem jahr 1998

select Lastname, SUM(unitprice*quantity) 
from ku1
	where
			--YEAR(OrderDate) =1998 --doof, weil immer SCAN
			OrderDate between '1.1.1998' and '31.12.1998 23:59:59.999'
group by lastname

CREATE NONCLUSTERED INDEX NIX1
ON [dbo].[ku1] ([OrderDate])
INCLUDE ([UnitPrice],[Quantity],[LastName])



select Lastname, SUM(unitprice*quantity) 
from ku2
	where
			--YEAR(OrderDate) =1998 --doof, weil immer SCAN
			OrderDate between '1.1.1998' and '31.12.1998 23:59:59.999'
group by lastname

--CLIS --ohne Spaltennachfragen

--COLUMNSTORE---------------------
----------------------------------


--in weniger Dauer mit weniger IO und weniger CPU schneller fertig
--warum: durch deutlich weniger IO  deutlich weniger CPU,
--_woher kommt das

LAND   STADT       FLUSS
UK
UK
UK
UK
UK
USA
USA
USA
USA

in Segmenten sind 1 MIO 


-->S1!  S1  S1!
S2  S2  S1
S3  S3  S3 


Wo ist das Problem... ? 
INS UP DEL

S4
Spanien   SP
SENEGAL   SE
SCHWEDEN  SC
Schweiz   SCW

--es wird erst komprimiert ab  ca 1 Mio DS
--bis dahin wanderen neue DS nicht in ein Segment
--sondern in einen HEAP

--DELETE
--es wird niyx gelöscht
-- 010010    ABCDEF  Bitmapfilter

--UPDATE (INS DEL)
--zuerst Bitmap
--neuer DS im HEAP


--PFLEGE Indizes müssen gewartet werden..
--wg Fragmentierung oder wg Heap Strukturen im Columnstore bzw
--Bitmapfilter für gelöschte Datensätze
--> Rebuild schafft Abhilfe... vs Reorg

--Demodaten für Columnstore und Beobachtung

select * from sys.dm_db_column_store_row_group_physical_stats
--deltastore zb...


USE [Northwind]
GO
insert into ku2 
SELECT  400000
	  [CustomerID]
      ,[ContactTitle]
      ,[CompanyName]
      ,[ContactName]
      ,[Country]
      ,[City]
      ,[ProductName]
      ,[UnitsInStock]
      ,[UnitPrice]
      ,[Quantity]
      ,[EmployeeID]
      ,[OrderDate]
      ,[RequiredDate]
      ,[ShippedDate]
      ,[Freight]
      ,[ShipCity]
      ,[ShipCountry]
      ,[LastName]

  FROM [dbo].[ku2]

GO


























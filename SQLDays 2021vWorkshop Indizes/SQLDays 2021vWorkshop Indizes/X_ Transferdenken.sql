--SQL Server kennt 3 interne  Join Arten

merge join-- jede Tabelle wird einmal durchgelesen
nested loop  --eine Tabelle wird zeilenweise gelesen, und für jede Zeile ein Durchlauf der anderen Tabelle
hash join -- via Hashtable Vergleich


select * from customers c
				inner join orders o
									on c.customerid = o.customerid
--wenn ein Ergebnis sehr gering ist
select * from customers c
				inner loop join orders o
									on c.customerid = o.customerid
--bei gro0en tabellen ..ohne Indizes
select * from customers c
				inner hash join orders o
									on c.customerid = o.customerid

--merge: falls Daten sortiert, dann perfekt
--loop: falls eine sehr klein, die andere sortiert (CPU lastig)
--hash: bei großen Tabellen und Tabellen, die keine IX besitzen


delete from customers where customerid = 'ALFKI'

--FK Spalten immer indizieren
delete from customers where customerid = 'FISSA'


--was ist besser  ... 
--TABLE SCAN  vs  CL IX SCAN  egal CL IX = Tabelle 

--CL IX SCAN vs IX SCAN .... der der IX SCAN .. ist weniger als die Tabelle

--IX SCAN  vs IX SEEK  ... SEEK! ---optimmal, solange Statistiken und Plan korrekt sind

--NCL IX SEEK --> CL IX +BAUM
--NCL IX SEEK --> HEAP


--ID int identity  (CL IX) --massives Schreiben .. Messdatenerfassung

--die neusten DS kommen immer hinten rein... wg Sortierung des IX
--jeder Zugriff auf eine Seite ist Singlethreaded  , daher kann nur einer nach dem andere
--auf diese eine Seite schreiben <-->(Latch)
--Mit Hilfe einer GUID (uniqueidentifier) als CL IX wäre das Problem evtl zu bewältigen


--ID GUID
select newid()
--die Seiten dürfen aber nicht voll sein




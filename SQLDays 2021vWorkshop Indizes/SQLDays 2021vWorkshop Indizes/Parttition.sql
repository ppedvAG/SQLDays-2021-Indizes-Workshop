
--Mit Hilfe von Partition lassen sich Tabellen in pyhsik. kleine H�ppchen teilen
--idee: ein scan muss nicht mehr alles durchlesen, sondern nur den einen Teil
--oder auch: mehrere Lesezust�nde k�nnen auf sep Volumes paralell arbeiten

--auch Indizes k�nnen partitioniert werden
--im Prinzip, k�nnte man auch jede Zustand einer Spalte mit gefilterten Indizes abdecken
-- die Partition deckt autmatisch jeden Zustand ab
--dagegen, kann ein gefilteter IX auch nur einen Zustand filtern..falls dies 
--notwenig bzw gew�nscht sein sollte


create partition function fzahl(int)
as
range left for values(100,200)


create partition scheme schzahl
as
partition fzahl to ([PRIMARY],[PRIMARY],[PRIMARY])


create table t2(id int, nummer int) on schZahl(nummer)

select * into ku2 from ku1


--Neue Grenze: 5000
alter partition scheme next used [Primary]

ALTER partition function fzahl() split range (5000)

--GRENZE ENTFERNEN
alter partition function fzahl() merge range (100)


--Nun sind die Daten in verschiedene Partitionen unterteilt...
--die Locks k�nnen nun auch auf Partition angelegt werden
--und Indizes k�nnen auf ein part Schema gelegt werden
--Indizes--Eigenschaften--Speicher-- Schema w�hlen

--Wir der Index wie Tabelle mittel derseleben Spalte partitioniert,
--so spricht man von einer ausgerichteten Partition


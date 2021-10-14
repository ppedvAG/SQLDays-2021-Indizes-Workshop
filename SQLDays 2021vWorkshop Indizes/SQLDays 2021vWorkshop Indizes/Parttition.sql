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



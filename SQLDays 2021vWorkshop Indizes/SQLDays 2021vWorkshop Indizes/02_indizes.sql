/*

Clustered Index gruppierter IX x
NON CL IX   nicht gr IX  x
-------------------------------------
eindeutiger IX  x
zusammengesetzter IX  x
IX mit eingschlossenen Spalten  x
gefilterter IX x 
part. IX  x
ind. Sicht x 
reale hypothetische IX  Tool
abdeckender IX  x
-------------------------------------
Columnstore IX (NON CL , CL)
seit SQL 2016 SP1 auch in STD oder SSEX


*/


--NON CL IX

--Eine Tabelle ohne CL IX = HEAP  "Sauhaufen"

--> TABLE SCAN  Suche von A bis Z


--N CL--> Kopie von Spaltenwerten in sortierter Form
--> IX SCAN


--> SEEK aber das beste!



--GR IX = TABELLE .. der HEAP ist weg
--nur 1 mal pro Tabelle

--N GR IX--- ca 1000 mal pro Tabelle

--wann der GR IX und wann der N GR IX

--NGR IX sehr gut, wenn rel wenig rauskommt...
--gut bei eindeutigen Werten, wie etwa identity, PK

--GR IX nur einmal..
--ist gut bei Bereichsabfragen, aber nat. auch für ID Werte 
--

select * from Orders


create table t2(id int) on HOT




------------100]------------200]---------------------------
-- 1				2			3

f(117)---2


Partschema

Tab nicht auf HOT
PartSchema kennt (DG1, DG2, DG3)
                    1   2    3
TAB on partsch(nummer)
--Indizes k�nnen fragmentieren


--weil es zu Seitenteilungen kommt, daher ist eine Wartung notwendig

--Wartungsplan (ab SQL 2016) oder Ola Hallengren

--> 30%  Rebuild
--< 10% nix
--  Reorg �ber 10%


-- A B C --ca 1000
/*
A GR
B
C
A
AB
ABC
BA
BC
BAC
BCA
CAB
CBA
Ca
CB
ABC

where spa = wert ---and Spb = wert  and Spc = Wert
--> �berfl�ssige Indizes: verwendungsgrad der Indizes
Systemsichten

--------------------------------

evtl fehlende Indizes

--> Mengenanalyse: muss ich Abfragen merken (QuueryStore, Profiler, Xevents, DMVs)
--repr�sentativ

-->Analyse: Verwendung der Abfragen H�ufigkeit, Kosten, Spalte, Tabellen
--> Datenbankotpimierungsratgeber



Profiler: unbedingt filter aktieren
		  Aufzeichnung in Datei

Optimierungsratgeber
		Aufzeichnung des Profilers/QUeryStores �bergeben
		alle Formen von Indizes aktiveren
		keine beibehalten (Schl�gt ein L�schen vor)


*/

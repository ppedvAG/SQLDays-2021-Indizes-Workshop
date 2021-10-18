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

--Systemsichten f�r Wartung

-----------------------------------------------------------------
--FEHLENDE INDIZES.. und �BERFL�SSIGE INDIZES (weiter unten)
-----------------------------------------------------------------

--Grunds�tzlich Pl�ne in denen fehlende Indizes genannt werden
select p.query_plan
   from sys.dm_exec_cached_plans
        cross apply sys.dm_exec_query_plan(plan_handle) as p
  where p.query_plan.exist(
         'declare namespace
          mi="http://schemas.microsoft.com/sqlserver/2004/07/showplan";
            //mi:MissingIndexes')=1
go


--etwas komplexer um die fehlende Indizes anzuzeigen



select * from sys.dm_db_index_usage_Stats



set showplan_xml off

with XmlNameSpaces('http://schemas.microsoft.com/sqlserver/2004/07/showplan'
                      as qp)
  ,MissingIndexPlans(query_plan) as 
   (
    select p.query_plan
      from sys.dm_exec_cached_plans
           cross apply sys.dm_exec_query_plan(plan_handle) as p
     where p.query_plan.exist(
            'declare namespace
             mi="http://schemas.microsoft.com/sqlserver/2004/07/showplan";
               //mi:MissingIndexes')=1
   )
  ,Statements(StatementId, StatementText, StatementType
             ,StatementCost, StatementRows, MissingIndexesXml) as 
   (
     select stmt.value('(//qp:Statements/qp:StmtSimple)[1]/@StatementId'
                      ,'int')
       ,stmt.value('(//qp:Statements/qp:StmtSimple)[1]/@StatementText'
                       ,'nvarchar(max)')
       ,stmt.value('(//qp:Statements/qp:StmtSimple)[1]/@StatementType'
                      ,'nvarchar(80)')
       ,stmt.value('(//qp:Statements/qp:StmtSimple)[1]/@StatementSubTreeCost'
                   ,'float')
       ,stmt.value('(//qp:Statements/qp:StmtSimple)[1]/@StatementEstRows'
                  ,'float')
       ,stmt.query('//qp:MissingIndexes')
       from MissingIndexPlans
            cross apply query_plan.nodes('//qp:StmtSimple') as qp(stmt)
   )
   ,MissingIndexGroup(StatementId, StatementText, StatementType
                      ,StatementCost, StatementRows
                      ,Impact, MissingIndexXml) as
   (
     select StatementId, StatementText, StatementType
           ,StatementCost, StatementRows
           ,mi.value('@Impact', 'float')
           ,mi.query('.[position()]/qp:MissingIndex')
       from Statements
            cross apply MissingIndexesXml.nodes('//qp:MissingIndexGroup')
                        as mig(mi)
   )
   ,MissingIndex(StatementId, StatementText, StatementType
            ,StatementCost, StatementRows
            ,Impact, DbName, TableName
            ,EqualityColumnsXml, InEqualityColumnsXml, IncludeColumnsXml) as
   (
     select StatementId, StatementText, StatementType
           ,StatementCost, StatementRows
           ,Impact
           ,mi.value('@Database', 'sysname')
           ,mi.value('@Table', 'sysname')
           ,mi.query('//qp:ColumnGroup[@Usage="EQUALITY"]')
           ,mi.query('//qp:ColumnGroup[@Usage="INEQUALITY"]')
           ,mi.query('//qp:ColumnGroup[@Usage="INCLUDE"]')
       from MissingIndexGroup
            cross apply MissingIndexXml.nodes('//qp:MissingIndex') as mig(mi)
   )
   ,ColumnGroup(StatementId, StatementText, StatementType
               ,StatementCost, StatementRows
               ,Impact, DbName, TableName
               ,IndexColumns, IncludeColumns) as
   (
     select StatementId, StatementText, StatementType
           ,StatementCost, StatementRows
           ,Impact, DbName, TableName
           ,ltrim(replace(cast(
        EqualityColumnsXml.query('data(//qp:Column/@Name)') as nvarchar(max))
               + ' '
               + cast(InEqualityColumnsXml.query('data(//qp:Column/@Name)')
                      as nvarchar(max)), '] [','],['))
           ,replace(cast(IncludeColumnsXml.query('data(//qp:Column/@Name)') 
                      as nvarchar(max)), '] [','],[')
       from MissingIndex
   )
select StatementId, StatementText, StatementType
      ,StatementCost, StatementRows
      ,Impact, DbName, TableName, IndexColumns, IncludeColumns
  from ColumnGroup
go
sp_blitzindex--Brent Ozar

SELECT * FROM sys.dm_db_index_usage_Stats

--es geht aber auch leichter..
---select * from sys.dm_db_missing_index_...

//*
Felhlende INdizes werden zu Gruppen zusammengefasst..wird f�r weitere Abfragen gebraucht (Verkn�pfungen)
select * from sys.dm_db_missing_index_groups


Statistische Informationen zu fehelnden Indizes
select * from sys.dm_db_missing_index_group_stats


Details zu fehlenden Indizes
statement= Name der Tabelle
equality_columns gut f�r = Abfragen
inequality_columns  gut f�r Bereichsabfragen
select * from sys.dm_db_missing_index_details


Tabellenwertfunktion
ID = vorgeschlagener Index
Gibt gleiche Details aus wie index_details
select * from sys.dm_db_missing_index_columns


*//



--nicht so ressourcenfressend... ;-)

select db_name(d.database_id) as db_name
      ,d.statement
      ,d.equality_columns, d.inequality_columns 
      ,d.included_columns
      ,cast(gs.avg_total_user_cost as decimal(8, 2)) as avg_total_user_cost
      ,gs.avg_user_impact
      ,gs.user_seeks, gs.user_scans
      ,gs.last_user_seek, gs.last_user_scan
  from sys.dm_db_missing_index_groups as g
       inner join sys.dm_db_missing_index_group_stats as gs
               on gs.group_handle = g.index_group_handle
       inner join sys.dm_db_missing_index_details as d
               on g.index_handle = d.index_handle
 where d.database_id > 4  -- Nur Benutzerdatenbanken

 -------------------------------------------------------------
 --�BERFL�SSIGE INDIZES
 -------------------------------------------------------------
 select object_name(i.object_id) as TableName
      ,i.type_desc,i.name
      ,us.user_seeks, us.user_scans
      ,us.user_lookups,us.user_updates
      ,us.last_user_scan, us.last_user_update
  from sys.indexes as i
       left outer join sys.dm_db_index_usage_stats as us
                    on i.index_id=us.index_id
                   and i.object_id=us.object_id
 where objectproperty(i.object_id, 'IsUserTable') = 1
go
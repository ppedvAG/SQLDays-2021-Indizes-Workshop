SELECT index_id, index_depth AS 'Depth'
    , index_level AS 'Index Level'
    , record_count AS 'Record Count'
    , page_count AS 'Page Count'
    , avg_page_space_used_in_percent AS 'Page Space Used'
    , min_record_size_in_bytes AS 'Min Record Size'
    , max_record_size_in_bytes AS 'Max Record Size'
    , avg_record_size_in_bytes AS 'Avg Record Size'
FROM sys.dm_db_index_physical_stats
    (DB_ID ('nwindbig')
    , OBJECT_ID ('nwindbig.dbo.Customers')
    , NULL
    , NULL 
    , 'DETAILED');
go


drop table sp_DBCCINDIZES;
GO


CREATE TABLE sp_DBCCINDIZES
(
    PageFID         tinyint,
    PagePID         int,
    IAMFID          tinyint,
    IAMPID          int,
    ObjectID        int,
    IndexID         tinyint,
    PartitionNumber tinyint,
    PartitionID     bigint,
    iam_chain_type  varchar(30),
    PageType        tinyint,
    IndexLevel      tinyint,
    NextPageFID     tinyint,
    NextPagePID     int,
    PrevPageFID     tinyint,
    PrevPagePID     int
);
go

insert into sp_DBCCINDIZES
exec ('DBCC IND (Nwindbig, customers, 1)') --1 = IndexID
go


--NUN SUCHE NACH WURZELKNOTEN

select * from sp_dbccindizes
where indexlevel=0
order by IndexLevel desc, PrevPagePID

select * from sp_dbccindizes
where indexlevel=1
order by IndexLevel desc, PrevPagePID

--Ist nur eine Seite im Ergebnis, dann handelt es sich um den Wurzelknoten
select * from sp_dbccindizes
where indexlevel=2
order by IndexLevel desc, PrevPagePID --40259--> 341 Seiten--> 65 Seiten


--502368

SET STATISTICS IO, time on		 
--otaaf



select  * from customers where customerid like '%otaaf%' --SCAN!!!

select  * from customers where customerid like 'otaaf' --SCAN--3 Seiten

DBCC PAGE (NwindBig, 1, 502368, 3) --alle von a bis z aber nur 341 von 2 mio 

DBCC PAGE (NwindBig, 1, 544728, 3)---a lle von oropi bis otm.. aber nur ein teil

DBCC TRACEON (3604) --um die letzte Seiten (Datenseite) zu sehen, benötigen wir für den
--Befehl dbcc eine Traceflag... Seit SQL 2019 geht das auch einfacher..

DBCC PAGE (NwindBig, 1, 542597, 3)








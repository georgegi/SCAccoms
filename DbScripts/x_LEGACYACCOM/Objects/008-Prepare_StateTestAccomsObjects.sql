if object_id('x_LEGACYACCOM.MAP_TestNames') is not null
drop table x_LEGACYACCOM.MAP_TestNames 
go

create table x_LEGACYACCOM.MAP_TestNames (Sequence int not null identity(1,1), EOTestCode	varchar(5) not null, EnrichTestName	varchar(100) not null)

set nocount on;
insert x_LEGACYACCOM.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC3', 'SC PASS ELA') -- 
insert x_LEGACYACCOM.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC4', 'SC PASS Math') -- 
insert x_LEGACYACCOM.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC5', 'SC PASS SS') -- Social Studies
insert x_LEGACYACCOM.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC6', 'SC PASS Science') -- 
insert x_LEGACYACCOM.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC7', 'SC PASS Writing') -- 

insert x_LEGACYACCOM.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC14', 'ELDA') -- English Language Development Assessment (ELDA)
insert x_LEGACYACCOM.MAP_TestNames (EOTestCode, EnrichTestName) values ('GTTP', '2nd Grade GT') -- No accommodations stored in IEPAccomModListTbl_SC

insert x_LEGACYACCOM.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC8', 'EOC Algebra') -- Algebra 1/Mathematics for the Technologies 2
insert x_LEGACYACCOM.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC9', 'EOC Biology') -- 
insert x_LEGACYACCOM.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC10', 'EOC English') -- 
insert x_LEGACYACCOM.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC11', 'Physical Science') -- not used in Enrich?
insert x_LEGACYACCOM.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC13', 'EOC History') -- US History and Constitution

insert x_LEGACYACCOM.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC12', 'District Assessments') -- separate in Enrich, and no accoms in IEPAccomModListTbl_SC

set nocount off;

alter table x_LEGACYACCOM.MAP_TestNames 
	add constraint PK_x_LEGACYACCOM_MAP_TestNames primary key (EOTestCode)
go



-- build view based on that table that joins based on the name and returns the ID
if object_id('x_LEGACYACCOM.MAP_TestDefID') is not null -- this does not follow naming convention. this is a view, not a table
drop view x_LEGACYACCOM.MAP_TestDefID
go

create view x_LEGACYACCOM.MAP_TestDefID
as
select TestDefID = td.ID, t.*
from x_LEGACYACCOM.MAP_TestNames t
join IepTestDef td on t.EnrichTestName = td.Name
go




--- create a transform for all test accommodations, then use it to create a distinct list of accommodations, then to map EO to Enrich accoms

create table x_LEGACYACCOM.MAP_IepAccommodationID (
AccommodationRefID	int	not null,
DestID	uniqueidentifier not null
)



-- select * from IepAccommodation


-- select * -- Text = convert(varchar(100), aa.AccomDesc)

if object_id('x_LEGACYACCOM.Transform_IepTestAccommodation') is not null
drop view x_LEGACYACCOM.Transform_IepTestAccommodation
go

create view x_LEGACYACCOM.Transform_IepTestAccommodation
as
select s.IEPRefID, 
	TestParticipationRefID = a.IEPAccomSeq, 
	AccommodationRefID = aa.RecNum, EOTestCode = aa.AccomType, IsModification = case when aa.AccomCode like '%MOD%' then 1 else 0 end, Text = convert(varchar(100), aa.AccomDesc), 
	TestParticipationID = tp.DestID,
	AccommodationDefID = ad.ID, -- this will be null until the group by query is used to populate IepAccommodationDef with the new accommodation defs
	AccommodationID = ma.DestID -- 
from x_LEGACYACCOM.Transform_IepTestParticipation tp 
left join IepAccommodationDef ad on convert(varchar(100), aa.AccomDesc) = ad.Text and ad.CategoryID = 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E' and ad.IsModification = case when aa.AccomCode like '%MOD%' then 1 else 0 end
left join x_LEGACYACCOM.MAP_IepAccommodationID ma on aa.RecNum = ma.AccommodationRefID
GO


insert x_LEGACYACCOM.MAP_IepAccommodationID (AccommodationRefID, DestID)
select tta.AccommodationRefID, newID()
from x_LEGACYACCOM.Transform_TestAccommodation tta
left join x_LEGACYACCOM.MAP_IepAccommodationID ma on tta.AccommodationRefID = ma.AccommodationRefID 
where ma.DestID is null 
-- 527


select count(*) from x_LEGACYACCOM.EO_IEPAccomModListTbl_SC_RAW -- 527


select *
from x_LEGACYACCOM.Transform_TestAccommodation tta





-- insert IepAccommodationCategory specific to EO accoms
if not exists (select 1 from IepAccommodationCategory where ID = 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E')
insert dbo.IepAccommodationCategory values ('B90D4D56-4A20-4901-BD7B-2FC99BF5D42E', 'Excent Online Assess Accom (DO NOT USE)', 0)

insert IepAccommodationDef (ID, CategoryID, Text, IsValidWithoutTest, IsNonStandard, IsModification, DeletedDate)
select ID = NewID(), CategoryID = 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E', ta.Text, IsValidWithoutTest = 0, IsNonstandard = 0, ta.IsModification, DeletedDate = getdate()
from x_LEGACYACCOM.TestAccom ta
left join IepAccommodationDef ad on ta.Text = ad.Text and ta.IsModification = ad.IsModification
where ad.ID is null
group by ta.Text, ta.IsModification


-- select * from IepAccommodationDef where CategoryID = 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E' and IsModification = 1

--select ta.*, ad.ID
--from x_LEGACYACCOM.TestAccom ta
--join IepAccommodationDef ad on ta.Text = ad.Text and ad.CategoryID = 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E'

-- select * from x_LEGACYACCOM.Transform_IepTestParticipation


select top 3 ID = tp.DestID, tp.InstanceID,  from x_LEGACYACCOM.Transform_IepTestParticipation tp
select top 3 * from IepAccommodation




select ParticipationID = ttp.DestID
 	, ta.AccommodationDefID
from x_LEGACYACCOM.Transform_IepTestParticipation ttp
join x_LEGACYACCOM.TestAccom ta on ttp.TestParticipationRefID = ta.TestParticipationRefID and ttp.EOTestCode = ta.EOTestCode 
where ttp.StudentLocalID = '165714505300'
and ttp.EOTestCode = 'AC3'
and ttp.TestParticipationRefID = 3539


select * from ieptestaccom


select * from x_LEGACYACCOM.TestAccom where TestParticipationRefID = 3539


-- insert iepaccommodation


-- insert IepTestAccom (from IepAccommodation and IepTestParticipation)




-- insert IepAccommodationDef records from EO
--insert IepAccommodationDef (ID, CategoryID, Text, IsValidWithoutTest, IsNonStandard, IsModification, DeletedDate)
--select t.*
--from (
--select ID = NewID(), CategoryID = 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E', Text = convert(varchar(100), aa.AccomDesc), IsValidWithoutTest = 0, IsNonstandard = 0, 
--	IsModification = case when aa.AccomCode like '%MOD%' then 1 else 0 end, -- set this correctly based on the accomcode
--	DeletedDate = getdate()
--from LEGACYSPED.MAP_IEPStudentRefID s
--join x_LEGACYACCOM.EO_IEPAccomModTbl_RAW a on s.StudentRefID = a.GStudentID
--join x_LEGACYACCOM.EO_IEPAccomModListTbl_SC_RAW aa on a.iepaccomseq = aa.iepaccomseq
--group by convert(varchar(100), aa.AccomDesc), case when aa.AccomCode like '%MOD%' then 1 else 0 end
--) t 
--left join IepAccommodationDef x on t.CategoryID = x.CategoryID and t.text = x.Text
--where x.id is null


-- select * from ieptestaccom



-- insert test accommodations
insert IepTestAccom (ParticipationID, AccommodationID)
select ttp.DestID
from x_LEGACYACCOM.Transform_IepTestParticipation ttp
join x_LEGACYACCOM.






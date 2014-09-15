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





-- insert IepAccommodationCategory specific to EO accoms
if not exists (select 1 from IepAccommodationCategory where ID = 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E')
insert dbo.IepAccommodationCategory values ('B90D4D56-4A20-4901-BD7B-2FC99BF5D42E', 'Excent Online Assess Accom (DO NOT USE)', 0)

-- insert IepAccommodationDef records from EO
insert IepAccommodationDef (ID, CategoryID, Text, IsValidWithoutTest, IsNonStandard, IsModification, DeletedDate)
select t.*
from (
select ID = NewID(), CategoryID = 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E', Text = convert(varchar(100), aa.AccomDesc), IsValidWithoutTest = 0, IsNonstandard = 0, 
	IsModification = case when aa.AccomCode like '%MOD%' then 1 else 0 end, -- set this correctly based on the accomcode
	DeletedDate = getdate()
from LEGACYSPED.MAP_IEPStudentRefID s
join x_LEGACYACCOM.EO_IEPAccomModTbl_RAW a on s.StudentRefID = a.GStudentID
join x_LEGACYACCOM.EO_IEPAccomModListTbl_SC_RAW aa on a.iepaccomseq = aa.iepaccomseq
group by convert(varchar(100), aa.AccomDesc), case when aa.AccomCode like '%MOD%' then 1 else 0 end
) t 
left join IepAccommodationDef x on t.CategoryID = x.CategoryID and t.text = x.Text
where x.id is null






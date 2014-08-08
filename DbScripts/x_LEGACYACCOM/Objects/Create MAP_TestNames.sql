if object_id('LEGACYSPED.MAP_TestNames') is not null
drop table LEGACYSPED.MAP_TestNames 
go

create table LEGACYSPED.MAP_TestNames (Sequence int not null identity(1,1), EOTestCode	varchar(5) not null, EnrichTestName	varchar(100) not null)

set nocount on;
insert LEGACYSPED.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC3', 'SC PASS ELA') -- 
insert LEGACYSPED.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC4', 'SC PASS Math') -- 
insert LEGACYSPED.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC5', 'SC PASS SS') -- Social Studies
insert LEGACYSPED.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC6', 'SC PASS Science') -- 
insert LEGACYSPED.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC7', 'SC PASS Writing') -- 

insert LEGACYSPED.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC14', 'ELDA') -- English Language Development Assessment (ELDA)
insert LEGACYSPED.MAP_TestNames (EOTestCode, EnrichTestName) values ('GTTP', '2nd Grade GT') -- No accommodations stored in IEPAccomModListTbl_SC

insert LEGACYSPED.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC8', 'EOC Algebra') -- Algebra 1/Mathematics for the Technologies 2
insert LEGACYSPED.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC9', 'EOC Biology') -- 
insert LEGACYSPED.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC10', 'EOC English') -- 
insert LEGACYSPED.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC11', 'Physical Science') -- not used in Enrich?
insert LEGACYSPED.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC13', 'EOC History') -- US History and Constitution

insert LEGACYSPED.MAP_TestNames (EOTestCode, EnrichTestName) values ('AC12', 'District Assessments') -- separate in Enrich, and no accoms in IEPAccomModListTbl_SC

set nocount off;

alter table LEGACYSPED.MAP_TestNames 
	add constraint PK_LEGACYSPED_MAP_TestNames primary key (EOTestCode)
go



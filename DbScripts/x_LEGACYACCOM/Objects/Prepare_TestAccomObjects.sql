set nocount on;

declare @importPrgSections table (Enabled bit not null, SectionDefName varchar(100) not null, SectionDefID uniqueidentifier not null)
insert @importPrgSections values (1,'IEP Assessments','A0C84AE0-4F46-4DA5-9F90-D57AB212ED64')
insert @importPrgSections values (1,'Accommodations & Modifications','4C01FA56-D3F6-47B1-BCDF-EBE7AB08A57C')

set nocount off;

insert LEGACYSPED.ImportPrgSections
select * from @importPrgSections where SectionDefID not in (select SectionDefID from LEGACYSPED.ImportPrgSections)
go


if object_id('x_LEGACYACCOM.ImportPrgSectionsFormTemplates', 'V') is not null
DROP VIEW x_LEGACYACCOM.ImportPrgSectionsFormTemplates
GO

create view x_LEGACYACCOM.ImportPrgSectionsFormTemplates
as
select Item = 'IEP', ips.Enabled, sdf.Sequence, ips.SectionDefID, sdf.FormTemplateID, sdf.HeaderFormTemplateID, SectionType = stf.Name
from LEGACYSPED.ImportPrgSections ips 
left join dbo.PrgSectionDef sdf on ips.SectionDefID = sdf.ID
left join dbo.PrgSectionType stf on sdf.TypeID = stf.ID
Go

if object_id('x_LEGACYACCOM.MAP_FormInputValueID') is not null
drop table x_LEGACYACCOM.MAP_FormInputValueID
go

CREATE TABLE x_LEGACYACCOM.MAP_FormInputValueID(
	Item varchar(10) NOT NULL,
	IntervalID uniqueidentifier NOT NULL,
	InputFieldID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL,
	Sequence int NOT NULL,
 CONSTRAINT PK_MAP_FormInputValueID PRIMARY KEY CLUSTERED 
(
	IntervalID ASC,
	InputFieldID ASC,
	Sequence ASC
)
)

if object_id('x_LEGACYACCOM.MAP_FormInstanceID') is not null
drop table x_LEGACYACCOM.MAP_FormInstanceID
go

CREATE TABLE x_LEGACYACCOM.MAP_FormInstanceID(
	Item varchar(10) NOT NULL,
	ItemRefID int NOT NULL,
	SectionDefID uniqueidentifier NOT NULL,
	FormInstanceID uniqueidentifier NULL,
	HeaderFormInstanceID uniqueidentifier NULL,
	FormInstanceIntervalID uniqueidentifier NULL,
	HeaderFormInstanceIntervalID uniqueidentifier NULL,
 CONSTRAINT PK_MAP_FormInstanceID PRIMARY KEY CLUSTERED 
(
	Item ASC,
	ItemRefID ASC,
	SectionDefID ASC
)
) ON [PRIMARY]

GO


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



if object_id('x_LEGACYACCOM.MAP_TestDefID') is not null -- this does not follow naming convention. this is a view, not a table
drop view x_LEGACYACCOM.MAP_TestDefID
go

create view x_LEGACYACCOM.MAP_TestDefID
as
select TestDefID = td.ID, t.*
from x_LEGACYACCOM.MAP_TestNames t
join IepTestDef td on t.EnrichTestName = td.Name
go


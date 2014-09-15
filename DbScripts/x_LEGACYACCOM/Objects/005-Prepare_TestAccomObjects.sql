set nocount on;

declare @importPrgSections table (Enabled bit not null, SectionDefName varchar(100) not null, SectionDefID uniqueidentifier not null)
insert @importPrgSections values (1,'IEP Assessments','A0C84AE0-4F46-4DA5-9F90-D57AB212ED64')
-- insert @importPrgSections values (1,'Accommodations & Modifications','4C01FA56-D3F6-47B1-BCDF-EBE7AB08A57C') -- wrong DefID 
insert @importPrgSections values (1,'Accommodations & Modifications','43CD5045-8083-4534-AD66-A81C43A42F26')

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


if object_id('x_LEGACYACCOM.MAP_FormInstanceID') is not null
drop table x_LEGACYACCOM.MAP_FormInstanceID
go

CREATE TABLE x_LEGACYACCOM.MAP_FormInstanceID (
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

------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------


if object_id('x_LEGACYACCOM.MAP_FormInputValueID') is not null
drop table x_LEGACYACCOM.MAP_FormInputValueID
go

CREATE TABLE x_LEGACYACCOM.MAP_FormInputValueID (
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

go


IF EXISTS (SELECT 1 FROM sys.schemas s JOIN sys.objects o on s.schema_id = o.schema_id WHERE s.name = 'x_LEGACYACCOM' AND o.name = 'Transform_PrgSectionFormInstance')
DROP VIEW x_LEGACYACCOM.Transform_PrgSectionFormInstance
GO
-- we create the objects in the required order 
CREATE VIEW x_LEGACYACCOM.Transform_PrgSectionFormInstance
AS
with CTE_Formlets
as (
	select 
		Item = 'IEP',
		itm.IEPRefID,
		ItemID = itm.DestID,
		-- sd.IsVersioned, -- is this needed?  
		--sec.FormPlace,
		sec.SectionDefID,
	-- FormInstance
		sec.FormTemplateID, -------------------------- form template id
		sec.HeaderFormTemplateID,
		mfi.FormInstanceID, -- DestID / FormInstanceID
		mfi.HeaderFormInstanceID, 
	-- PrgItemForm 
		CreatedDate = GETDATE(),
		CreatedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- BuiltIn: Support
		AssociationTypeID = 'DE0AFD97-84C8-488E-94DC-E17CAAA62082', -- PrgItemFormType.ID = Section -- Okay to hard-code
	-- FormInstanceInterval 
		mfi.FormInstanceIntervalID,
		mfi.HeaderFormInstanceIntervalID,
		IntervalID = 'FBE8314C-E0A0-4C5A-9361-7201081BD47D', -- Value 
		CompletedDate = GETDATE(),
		CompletedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB' -- BuiltIn: Support
	FROM 
		LEGACYSPED.Transform_PrgIep itm JOIN 
		dbo.PrgSectionDef sd on itm.DefID = sd.ItemDefID and not (sd.FormTemplateID is null and sd.HeaderFormTemplateID is null) join 
		x_LEGACYACCOM.ImportPrgSectionsFormTemplates sec on sd.ID = sec.SectionDefID LEFT JOIN
		x_LEGACYACCOM.MAP_FormInstanceID mfi on itm.IEPRefID = mfi.ItemRefID and sd.id = mfi.SectionDefID 
	-- WHERE NOT (sec.FormtemplateID is null and sec.HeaderFormTemplateID is null)
	) 
select 
	FormTemplate = fft.Name, HeaderFormTemplate = hft.Name,
	c.* 
from CTE_Formlets c 
left join dbo.FormTemplate fft on c.FormTemplateID = fft.Id 
left join dbo.FormTemplate hft on c.HeaderFormTemplateID = hft.Id 

GO

if object_id('x_LEGACYACCOM.Transform_FormInputTextValue', 'V') is not null
DROP VIEW x_LEGACYACCOM.Transform_FormInputTextValue
GO

create view x_LEGACYACCOM.Transform_FormInputTextValue
as
select f.Item,
	f.IEPRefID, 
	tp.SubRefID,
	v.TemplateID,
	v.InputFieldID,
	tp.Sequence, 
	v.InputItemCode, 
	v.InputItemLabel, 
	v.InputItemType, 
	FooterFormInstanceID = f.FormInstanceID, 
	f.HeaderFormInstanceID,
	FooterIntervalID = f.FormInstanceIntervalID,
	HeaderIntervalID = f.HeaderFormInstanceIntervalID,
	FormInstanceID = isnull(f.FormInstanceID, f.HeaderFormInstanceID),
	IntervalID = isnull(f.FormInstanceIntervalID, f.HeaderFormInstanceIntervalID),
	mv.DestID,
	Value = tp.Value 
	-- select f.*
from x_LEGACYACCOM.Transform_PrgSectionFormInstance f join 
	x_LEGACYACCOM.FormInputFields v on (f.FormTemplateID = v.TemplateID or f.HeaderFormTemplateID = v.TemplateID ) and v.InputItemType = 'Text' join
	(
		select Item = 'IEP', * from x_LEGACYACCOM.ConvertedAssessmentsTextsPivot 
		union all
		select Item = 'IEP', * from x_LEGACYACCOM.ClassroomAccomModTextsPivot

	) tp on f.IEPRefID = tp.IEPRefID and v.InputFieldID = tp.InputFieldID and f.Item = tp.Item left join -- 52886
	x_LEGACYACCOM.MAP_FormInputValueID mv on tp.InputFieldID = mv.InputFieldID 
		and (f.FormInstanceIntervalID = mv.IntervalID or f.HeaderFormInstanceIntervalID = mv.IntervalID)
		and tp.Sequence = mv.Sequence
		left join 
	dbo.FormInputTextValue tv on mv.DestID = tv.Id
go

if object_id('x_LEGACYACCOM.Transform_FormInputSingleSelectValue', 'V') is not null
DROP VIEW x_LEGACYACCOM.Transform_FormInputSingleSelectValue
GO

create view x_LEGACYACCOM.Transform_FormInputSingleSelectValue
as
select f.Item,
	f.IEPRefID, 
	tp.SubRefID,
	v.TemplateID,
	v.InputFieldID,
	tp.Sequence, 
	v.InputItemCode, 
	v.InputItemLabel, 
	v.InputItemType, 
	FooterFormInstanceID = f.FormInstanceID, 
	f.HeaderFormInstanceID,
	FooterIntervalID = f.FormInstanceIntervalID,
	HeaderIntervalID = f.HeaderFormInstanceIntervalID,
	FormInstanceID = isnull(f.FormInstanceID, f.HeaderFormInstanceID),
	IntervalID = isnull(f.FormInstanceIntervalID, f.HeaderFormInstanceIntervalID),
	mv.DestID,
	Value = tp.Value 
	-- select f.*
from x_LEGACYACCOM.Transform_PrgSectionFormInstance f join 
	x_LEGACYACCOM.FormInputFields v on (f.FormTemplateID = v.TemplateID or f.HeaderFormTemplateID = v.TemplateID ) and v.InputItemType = 'SingleSelect' join
	(
		select Item = 'IEP', * from x_LEGACYACCOM.ConvertedAssessmentsSingleSelectsPivot 

	) tp on f.IEPRefID = tp.IEPRefID and v.InputFieldID = tp.InputFieldID and f.Item = tp.Item left join -- 52886
	x_LEGACYACCOM.MAP_FormInputValueID mv on tp.InputFieldID = mv.InputFieldID 
		and (f.FormInstanceIntervalID = mv.IntervalID or f.HeaderFormInstanceIntervalID = mv.IntervalID)
		and tp.Sequence = mv.Sequence
		left join 
	dbo.FormInputTextValue tv on mv.DestID = tv.Id
go




if object_id('x_LEGACYACCOM.Transform_FormInputFlagValue', 'V') is not null
DROP VIEW x_LEGACYACCOM.Transform_FormInputFlagValue
GO

create view x_LEGACYACCOM.Transform_FormInputFlagValue
as
select f.Item,
	f.IEPRefID, 
	tp.SubRefID,
	v.TemplateID,
	v.InputFieldID,
	tp.Sequence, 
	v.InputItemCode, 
	v.InputItemLabel, 
	v.InputItemType, 
	f.FormInstanceID, 
	IntervalID = f.FormInstanceIntervalID,
	mv.DestID,
	Value = tp.Value 
	-- select f.*
from x_LEGACYACCOM.Transform_PrgSectionFormInstance f join 
	x_LEGACYACCOM.FormInputFields v on f.FormTemplateID = v.TemplateID and v.InputItemType = 'Flag' join 
	(
		select Item = 'IEP', * from x_LEGACYACCOM.ClassroomAccomModFlagsPivot 

	) tp on f.IEPRefID = tp.IEPRefID and v.InputFieldID = tp.InputFieldID and f.Item = tp.Item left join -- 52886
	x_LEGACYACCOM.MAP_FormInputValueID mv on tp.InputFieldID = mv.InputFieldID 
		and f.FormInstanceIntervalID = mv.IntervalID 
		and tp.Sequence = mv.Sequence
		left join 
	dbo.FormInputFlagValue tv on mv.DestID = tv.Id
go





if object_id('x_LEGACYACCOM.Transform_FormInputValue', 'V') is not null
DROP VIEW x_LEGACYACCOM.Transform_FormInputValue
GO

create view x_LEGACYACCOM.Transform_FormInputValue
as
--select v.Item, v.IEPRefID, v.SubRefID, v.DestID, v.IntervalID, InputFieldID = v.InputFieldID, v.Sequence, v.InputItemCode, v.InputItemLabel, v.InputItemType, Value = convert(varchar, v.Value, 101)
--from x_LEGACYACCOM.Transform_FormInputDateValue v
--union all
select v.Item, v.IEPRefID, v.SubRefID, v.DestID, v.IntervalID, InputFieldID = v.InputFieldID, v.Sequence, v.InputItemCode, v.InputItemLabel, v.InputItemType, Value = convert(varchar(max), v.Value)
from x_LEGACYACCOM.Transform_FormInputTextValue v
union all
select v.Item, v.IEPRefID, v.SubRefID, v.DestID, v.IntervalID, InputFieldID = v.InputFieldID, v.Sequence, v.InputItemCode, v.InputItemLabel, v.InputItemType, Value = convert(varchar(max), v.Value)
from x_LEGACYACCOM.Transform_FormInputFlagValue v
union all
select v.Item, v.IEPRefID, v.SubRefID, v.DestID, v.IntervalID, InputFieldID = v.InputFieldID, v.Sequence, v.InputItemCode, v.InputItemLabel, v.InputItemType, Value = convert(varchar(max), v.Value)
from x_LEGACYACCOM.Transform_FormInputSingleSelectValue v
go


if object_id('x_LEGACYACCOM.Transform_IepAccommodations') is not null
drop view x_LEGACYACCOM.Transform_IepAccommodations
go

create view x_LEGACYACCOM.Transform_IepAccommodations
as
select s.DestID, Explanation = cast (NULL as VARCHAR(max)), TrackDetails = 0, TrackForAssessments = 0, 
	NoAccommodationsRequired = case when isnull(c.Accoms, 'NA') in ('NA', 'N/A', '', 'None') then 1 else 0 end,
	NoModificationsRequired = abs(1-c.ModifyYN)
	--, c.Accoms, c.Mods -- testing only
from LEGACYSPED.MAP_PrgSectionID s 
join LEGACYSPED.MAP_PrgVersionID v on s.VersionID = v.DestID
join x_LEGACYACCOM.ClassroomAccomMod_LOCAL c on v.IepRefID = c.IEPRefID
where s.DefID = '43CD5045-8083-4534-AD66-A81C43A42F26'
go
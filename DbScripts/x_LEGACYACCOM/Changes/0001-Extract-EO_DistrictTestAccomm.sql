-- create the table that holds the 
if object_id('x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL') is not null
drop table x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL
go

create table x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL (
IEPRefID	int not null,
SubRefID	int not null,
DistAssessTitle varchar(100)  null,
Participation varchar(max) null, -- this is a GUID, but we treat as varchar for a reason (union all with values view)
Accommodations text NULL,
Sequence int not null
)

alter table x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL 
	add constraint PK_x_LEGACYACCOM_EO_DistrictTestAccomm_LOCAL primary key (SubRefID)
go

create index IX_x_LEGACYACCOM_EO_DistrictTestAccomm_LOCAL_IEPComplSeqNum on x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL (IEPRefID)
go

if object_id('x_LEGACYACCOM.ClassroomAccomMod_LOCAL') is not null
drop table x_LEGACYACCOM.ClassroomAccomMod_LOCAL
go

create table x_LEGACYACCOM.ClassroomAccomMod_LOCAL (
 IEPRefID int not null
, SubRefID  int null
, ModifyYN bit not null
, Accoms varchar(max) null
, Mods varchar(max) null
)
alter table x_LEGACYACCOM.ClassroomAccomMod_LOCAL 
	add constraint PK_x_LEGACYACCOM_ClassroomAccomMod_LOCAL primary key (IEPRefID)
go



-- create pivot views based on the above table.
-- Texts
-- Assessment
if object_id('x_LEGACYACCOM.ConvertedAssessmentsTextsPivot', 'V') is not null
DROP VIEW x_LEGACYACCOM.ConvertedAssessmentsTextsPivot
GO

create view x_LEGACYACCOM.ConvertedAssessmentsTextsPivot
as
select u.IEPRefID, u.SubRefID, u.Value, u.Sequence, u.InputFieldID, InputItemType =  iit.Name, InputItemTypeID = iit.ID 
from (

	select IepRefID, SubRefID =  x.SubRefID, Value = x.DistAssesstitle, InputFieldID = 'D2C7221B-985B-45BB-AFB5-FBE439CC3C38', Sequence =  x.Sequence  -- (1:M)  AssessName - Name
	from x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL x
	UNION ALL
	select IepRefID, SubRefID =  x.SubRefID, Value = x.Accommodations, InputFieldID = '6E19E598-E42B-45C7-99E2-7EE834B468D8', Sequence =  x.Sequence  -- (1:M)  AssessAccom - Accommodations
	from x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL x

	) u join
FormTemplateInputItem ftii on u.InputFieldID = ftii.Id join 
FormTemplateInputItemType iit on ftii.TypeId = iit.Id
go

--exec x_DATATEAM.FormletPivotViewGenerator_TextOutput 'IEP', 'x_LEGACYACCOM.ClassroolAccomMod_LOCAL', '', 'Accommodations/Modifications', 'ClassroomAccomMod'

-- Classroom
if object_id('x_LEGACYACCOM.ClassroomAccomModTextsPivot', 'V') is not null
DROP VIEW x_LEGACYACCOM.ClassroomAccomModTextsPivot
GO

create view x_LEGACYACCOM.ClassroomAccomModTextsPivot
as
select u.IEPRefID, u.SubRefID, u.Value, u.Sequence, u.InputFieldID, InputItemType =  iit.Name, InputItemTypeID = iit.ID 
from (

	select IepRefID, SubRefID = cast(-99 as int), Value = x.Accoms, InputFieldID = '21D420C8-02B0-4442-A087-781BB4695C2A', Sequence =  cast(0 as int)  -- Accomms - Accommodations
	from x_LEGACYACCOM.ClassroomAccomMod_LOCAL x
	UNION ALL
	select IepRefID, SubRefID = cast(-99 as int), Value = x.Mods, InputFieldID = '75048692-5596-47E5-8BB0-F57D920F4B4B', Sequence =  cast(0 as int)  -- Modifs - Modifications
	from x_LEGACYACCOM.ClassroomAccomMod_LOCAL x

	) u join
FormTemplateInputItem ftii on u.InputFieldID = ftii.Id join 
FormTemplateInputItemType iit on ftii.TypeId = iit.Id
go



-- Single Selects
if object_id('x_LEGACYACCOM.ConvertedAssessmentsSingleSelectsPivot', 'V') is not null
DROP VIEW x_LEGACYACCOM.ConvertedAssessmentsSingleSelectsPivot
GO

create view x_LEGACYACCOM.ConvertedAssessmentsSingleSelectsPivot
as
select u.IEPRefID, u.SubRefID, u.Value, u.Sequence, u.InputFieldID, InputItemType =  iit.Name, InputItemTypeID = iit.ID 
from (

	select IepRefID, SubRefID =  x.SubRefID, Value = x.Participation, InputFieldID = 'CA1A4A5F-FE71-4379-866A-522CFE2B2959', Sequence =  x.Sequence  -- (1:M)  thirdS3 - Participation
	from x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL x

	) u join
FormTemplateInputItem ftii on u.InputFieldID = ftii.Id join 
FormTemplateInputItemType iit on ftii.TypeId = iit.Id
go


-- Flags
if object_id('x_LEGACYACCOM.ClassroomAccomModFlagsPivot', 'V') is not null
DROP VIEW x_LEGACYACCOM.ClassroomAccomModFlagsPivot
GO

create view x_LEGACYACCOM.ClassroomAccomModFlagsPivot
as
select u.IEPRefID, u.SubRefID, u.Value, u.Sequence, u.InputFieldID, InputItemType =  iit.Name, InputItemTypeID = iit.ID 
from (

	select IepRefID, SubRefID = cast(-99 as int), Value = x.ModifyYN, InputFieldID = 'DC181B1F-F381-470D-ACFD-5DED8F245B03', Sequence =  cast(0 as int)  -- ModNec - Modifications necessary?
	from x_LEGACYACCOM.ClassroomAccomMod_LOCAL x

	) u join
FormTemplateInputItem ftii on u.InputFieldID = ftii.Id join 
FormTemplateInputItemType iit on ftii.TypeId = iit.Id
go






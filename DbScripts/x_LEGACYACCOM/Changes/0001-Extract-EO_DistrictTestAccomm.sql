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


-- create pivot views based on the above table.
-- Texts
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


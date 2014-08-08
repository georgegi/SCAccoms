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


if object_id('x_LEGACYACCOM.ConvertedAssessmentsSingleSelectPivot', 'V') is not null
DROP VIEW x_LEGACYACCOM.ConvertedAssessmentsSingleSelectPivot
GO

create view x_LEGACYACCOM.ConvertedAssessmentsSingleSelectPivot
as
select u.IEPRefID, u.SubRefID, u.Value, u.Sequence, u.InputFieldID, InputItemType =  iit.Name, InputItemTypeID = iit.ID 
from (

	select IepRefID, SubRefID =  x.SubRefID, Value = x.Participation, InputFieldID = 'CA1A4A5F-FE71-4379-866A-522CFE2B2959', Sequence =  x.Sequence  -- (1:M)  thirdS3 - Participation
	from x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL x

	) u join
FormTemplateInputItem ftii on u.InputFieldID = ftii.Id join 
FormTemplateInputItemType iit on ftii.TypeId = iit.Id
go


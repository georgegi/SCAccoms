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

	) tp on f.IEPRefID = tp.IEPRefID and v.InputFieldID = tp.InputFieldID and f.Item = tp.Item left join -- 52886
	x_LEGACYACCOM.MAP_FormInputValueID mv on tp.InputFieldID = mv.InputFieldID 
		and (f.FormInstanceIntervalID = mv.IntervalID or f.HeaderFormInstanceIntervalID = mv.IntervalID)
		and tp.Sequence = mv.Sequence
		left join 
	dbo.FormInputTextValue tv on mv.DestID = tv.Id
go

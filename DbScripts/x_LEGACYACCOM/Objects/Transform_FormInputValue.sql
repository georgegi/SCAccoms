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
		select Item = 'IEP', * from x_LEGACYACCOM.ConvertedAssessmentsSingleSelectPivot 

	) tp on f.IEPRefID = tp.IEPRefID and v.InputFieldID = tp.InputFieldID and f.Item = tp.Item left join -- 52886
	x_LEGACYACCOM.MAP_FormInputValueID mv on tp.InputFieldID = mv.InputFieldID 
		and (f.FormInstanceIntervalID = mv.IntervalID or f.HeaderFormInstanceIntervalID = mv.IntervalID)
		and tp.Sequence = mv.Sequence
		left join 
	dbo.FormInputTextValue tv on mv.DestID = tv.Id
go


if object_id('x_LEGACYACCOM.Populate_DistrictTestAccomm_LOCAL', 'V') is not null
DROP VIEW x_LEGACYACCOM.Populate_DistrictTestAccomm_LOCAL
GO

create view x_LEGACYACCOM.Populate_DistrictTestAccomm_LOCAL
as
--select v.Item, v.IEPRefID, v.SubRefID, v.DestID, v.IntervalID, InputFieldID = v.InputFieldID, v.Sequence, v.InputItemCode, v.InputItemLabel, v.InputItemType, Value = convert(varchar, v.Value, 101)
--from x_LEGACYACCOM.Transform_FormInputDateValue v
--union all
select v.Item, v.IEPRefID, v.SubRefID, v.DestID, v.IntervalID, InputFieldID = v.InputFieldID, v.Sequence, v.InputItemCode, v.InputItemLabel, v.InputItemType, Value = convert(varchar(max), v.Value)
from x_LEGACYACCOM.Transform_FormInputTextValue v
union all
--select v.Item, v.IEPRefID, v.SubRefID, v.DestID, v.IntervalID, InputFieldID = v.InputFieldID, v.Sequence, v.InputItemCode, v.InputItemLabel, v.InputItemType, Value = convert(varchar(max), v.Value)
--from x_LEGACYACCOM.Transform_FormInputFlagValue v
--union all
select v.Item, v.IEPRefID, v.SubRefID, v.DestID, v.IntervalID, InputFieldID = v.InputFieldID, v.Sequence, v.InputItemCode, v.InputItemLabel, v.InputItemType, Value = convert(varchar(max), v.Value)
from x_LEGACYACCOM.Transform_FormInputSingleSelectValue v
go

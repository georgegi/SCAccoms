


--if object_id('LEGACYSPED.Transform_FormInputDateValue', 'V') is not null
--DROP VIEW LEGACYSPED.Transform_FormInputDateValue
--GO

--create view LEGACYSPED.Transform_FormInputDateValue
--as
--select f.Item,
--	f.IEPRefID, 
--	tp.SubRefID,
--	v.TemplateID,
--	v.InputFieldID,
--	tp.Sequence, 
--	v.InputItemCode, 
--	v.InputItemLabel, 
--	v.InputItemType, 
--	f.FormInstanceID, 
--	IntervalID = f.FormInstanceIntervalID,
--	mv.DestID,
--	Value = tp.Value 
--	-- select f.*
--from LEGACYSPED.Transform_PrgSectionFormInstance f join 
--	x_DATATEAM.FormInputFields v on f.FormTemplateID = v.TemplateID and v.InputItemType = 'Date' join 
--	(
--		select Item = 'IEP', * from LEGACYSPED.ProcSafeguardsDatesPivot 

--	) tp on f.IEPRefID = tp.IEPRefID and v.InputFieldID = tp.InputFieldID and f.Item = tp.Item left join -- 52886
--	LEGACYSPED.MAP_FormInputValueID mv on tp.InputFieldID = mv.InputFieldID 
--		and f.FormInstanceIntervalID = mv.IntervalID 
--		and tp.Sequence = mv.Sequence
--		left join 
--	dbo.FormInputDateValue tv on mv.DestID = tv.Id
--go

-- select * from LEGACYSPED.Transform_FormInputDateValue


--if object_id('LEGACYSPED.Transform_FormInputFlagValue', 'V') is not null
--DROP VIEW LEGACYSPED.Transform_FormInputFlagValue
--GO

--create view LEGACYSPED.Transform_FormInputFlagValue
--as
--select f.Item,
--	f.IEPRefID, 
--	tp.SubRefID,
--	v.TemplateID,
--	v.InputFieldID,
--	tp.Sequence, 
--	v.InputItemCode, 
--	v.InputItemLabel, 
--	v.InputItemType, 
--	f.FormInstanceID, 
--	IntervalID = f.FormInstanceIntervalID,
--	mv.DestID,
--	Value = tp.Value 
--	-- select f.*
--from LEGACYSPED.Transform_PrgSectionFormInstance f join 
--	x_DATATEAM.FormInputFields v on f.FormTemplateID = v.TemplateID and v.InputItemType = 'Flag' join 
--	(
--		select Item = 'IEP', * from LEGACYSPED.ClassroomAccommodationsFlagsPivot 
--		union all
--		select Item = 'IEP', * from LEGACYSPED.SpecialFactorsFlagsPivot
--		union all
--		select Item = 'IEP', * from LEGACYSPED.PostSchoolGoalsFlagsPivot -- had missed adding this to this view

--	) tp on f.IEPRefID = tp.IEPRefID and v.InputFieldID = tp.InputFieldID and f.Item = tp.Item left join -- 52886
--	LEGACYSPED.MAP_FormInputValueID mv on tp.InputFieldID = mv.InputFieldID 
--		and f.FormInstanceIntervalID = mv.IntervalID 
--		and tp.Sequence = mv.Sequence
--		left join 
--	dbo.FormInputFlagValue tv on mv.DestID = tv.Id
--go



if object_id('LEGACYSPED.Transform_FormInputTextValue', 'V') is not null
DROP VIEW LEGACYSPED.Transform_FormInputTextValue
GO

create view LEGACYSPED.Transform_FormInputTextValue
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
from LEGACYSPED.Transform_PrgSectionFormInstance f join 
	x_DATATEAM.FormInputFields v on (f.FormTemplateID = v.TemplateID or f.HeaderFormTemplateID = v.TemplateID ) and v.InputItemType = 'Text' join
	(
		select Item = 'IEP', * from LEGACYSPED.ConvertedAssessmentsTextsPivot 

	) tp on f.IEPRefID = tp.IEPRefID and v.InputFieldID = tp.InputFieldID and f.Item = tp.Item left join -- 52886
	LEGACYSPED.MAP_FormInputValueID mv on tp.InputFieldID = mv.InputFieldID 
		and (f.FormInstanceIntervalID = mv.IntervalID or f.HeaderFormInstanceIntervalID = mv.IntervalID)
		and tp.Sequence = mv.Sequence
		left join 
	dbo.FormInputTextValue tv on mv.DestID = tv.Id
go






if object_id('LEGACYSPED.Transform_FormInputSingleSelectValue', 'V') is not null
DROP VIEW LEGACYSPED.Transform_FormInputSingleSelectValue
GO

create view LEGACYSPED.Transform_FormInputSingleSelectValue
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
from LEGACYSPED.Transform_PrgSectionFormInstance f join 
	x_DATATEAM.FormInputFields v on (f.FormTemplateID = v.TemplateID or f.HeaderFormTemplateID = v.TemplateID ) and v.InputItemType = 'SingleSelect' join
	(
		select Item = 'IEP', * from LEGACYSPED.ConvertedAssessmentsSingleSelectPivot 

	) tp on f.IEPRefID = tp.IEPRefID and v.InputFieldID = tp.InputFieldID and f.Item = tp.Item left join -- 52886
	LEGACYSPED.MAP_FormInputValueID mv on tp.InputFieldID = mv.InputFieldID 
		and (f.FormInstanceIntervalID = mv.IntervalID or f.HeaderFormInstanceIntervalID = mv.IntervalID)
		and tp.Sequence = mv.Sequence
		left join 
	dbo.FormInputTextValue tv on mv.DestID = tv.Id
go





/*

		***** do overs ******

begin tran

delete x
-- select x.*
from LEGACYSPED.MAP_FormInputValueID m
join dbo.FormInputValue x on m.DestID = x.ID

delete LEGACYSPED.MAP_FormInputValueID



rollback

commit


*/













-- ##########################################################################################################################################################
-- Transform_FormInputValue

if object_id('LEGACYSPED.Transform_FormInputValue', 'V') is not null
DROP VIEW LEGACYSPED.Transform_FormInputValue
GO

create view LEGACYSPED.Transform_FormInputValue
as
--select v.Item, v.IEPRefID, v.SubRefID, v.DestID, v.IntervalID, InputFieldID = v.InputFieldID, v.Sequence, v.InputItemCode, v.InputItemLabel, v.InputItemType, Value = convert(varchar, v.Value, 101)
--from LEGACYSPED.Transform_FormInputDateValue v
--union all
select v.Item, v.IEPRefID, v.SubRefID, v.DestID, v.IntervalID, InputFieldID = v.InputFieldID, v.Sequence, v.InputItemCode, v.InputItemLabel, v.InputItemType, Value = convert(varchar(max), v.Value)
from LEGACYSPED.Transform_FormInputTextValue v
union all
--select v.Item, v.IEPRefID, v.SubRefID, v.DestID, v.IntervalID, InputFieldID = v.InputFieldID, v.Sequence, v.InputItemCode, v.InputItemLabel, v.InputItemType, Value = convert(varchar(max), v.Value)
--from LEGACYSPED.Transform_FormInputFlagValue v
--union all
select v.Item, v.IEPRefID, v.SubRefID, v.DestID, v.IntervalID, InputFieldID = v.InputFieldID, v.Sequence, v.InputItemCode, v.InputItemLabel, v.InputItemType, Value = convert(varchar(max), v.Value)
from LEGACYSPED.Transform_FormInputSingleSelectValue v
go

declare @rowcount varchar(5) ;
-- ##########################################################################################################################################################
--                                                                 --  RUN NEW IMPORTS FROM HERE
-- ##########################################################################################################################################################

-- rollback 
begin tran

-- select * from LEGACYSPED.MAP_FormInstanceID
-- ########################################################################################################################################################## --- 55125 -inserting a row for all sections.
insert LEGACYSPED.MAP_FormInstanceID (Item, ItemRefID, SectionDefID, FormInstanceID, FormInstanceIntervalID, HeaderFormInstanceID, HeaderFormInstanceIntervalID)
select t.Item, t.IEPRefID, t.SectionDefID, 
	FormInstanceID = case when t.FormTemplate is not null then newid() else NULL end, 
	FormInstanceIntervalID = case when t.FormTemplate is not null then newid() else NULL end, 
	HeaderFormInstanceID = case when t.HeaderFormTemplate is not null then newid() else NULL end, 
	HeaderFormInstanceIntervalID = case when t.HeaderFormTemplate is not null then newid() else NULL end
from LEGACYSPED.Transform_PrgSectionFormInstance t
left join LEGACYSPED.MAP_FormInstanceID m on t.IEPRefID = m.ItemRefID and t.SectionDefID = m.SectionDefID
where 1=1
--and t.IEPRefID = 19761 and t.SectionDefID = 'B1903FFA-D274-4009-8441-21D6F05BF1C4'
and isnull(m.FormInstanceID, m.HeaderFormInstanceID) is null




-- ##########################################################################################################################################################
-- Footer
insert FormInstance (ID, TemplateId)
select t.FormInstanceID, t.FormTemplateID -- footer
from LEGACYSPED.Transform_PrgSectionFormInstance t
left join FormInstance x on t.FormInstanceID = x.id 
where t.FormTemplateID is not null
and x.id is null
---- 42875


---- Header
insert FormInstance (ID, TemplateId)
select t.HeaderFormInstanceID, t.HeaderFormTemplateID -- Header
from LEGACYSPED.Transform_PrgSectionFormInstance t
left join FormInstance x on t.HeaderFormInstanceID = x.id
where t.HeaderFormTemplateID is not null
and x.id is null


-- ##########################################################################################################################################################
-- footer
insert FormInstanceInterval (ID, InstanceId, IntervalId, CompletedBy, CompletedDate)
select t.FormInstanceIntervalID, t.FormInstanceID, t.IntervalID, t.CompletedBy, t.CompletedDate
from LEGACYSPED.Transform_PrgSectionFormInstance t
left join FormInstanceInterval x on t.FormInstanceIntervalID = x.ID
where t.FormInstanceIntervalID is not null
and x.ID is null

-- header
insert FormInstanceInterval (ID, InstanceId, IntervalId, CompletedBy, CompletedDate)
select t.HeaderFormInstanceIntervalID, t.HeaderFormInstanceID, t.IntervalID, t.CompletedBy, t.CompletedDate
from LEGACYSPED.Transform_PrgSectionFormInstance t
left join FormInstanceInterval x on t.HeaderFormInstanceIntervalID = x.ID
where t.HeaderFormInstanceIntervalID is not null
and x.ID is null

--------------- moved this 20140625 -- begin tran
insert LEGACYSPED.MAP_FormInputValueID (Item, IntervalID, InputFieldID, Sequence, DestID)
select t.Item, t.IntervalID, t.InputFieldID, t.Sequence, newid()
from LEGACYSPED.Transform_FormInputValue t 
where DestID is null

-- ##########################################################################################################################################################
insert FormInputValue (ID, IntervalId, InputFieldId, Sequence)
select t.DestID, t.IntervalID, t.InputFieldID, t.Sequence
from LEGACYSPED.Transform_FormInputValue t 
left join FormInputValue x on t.DestID = x.ID
where x.ID is null

-- ##########################################################################################################################################################
insert FormInputTextValue 
select t.DestID, t.Value
from LEGACYSPED.Transform_FormInputTextValue t
left join FormInputTextValue x on t.DestID = x.id
where x.id is null

-- ##########################################################################################################################################################
insert FormInputFlagValue 
select t.DestID, t.Value
from LEGACYSPED.Transform_FormInputFlagValue t
left join FormInputFlagValue x on t.DestID = x.id
where x.id is null

-- ##########################################################################################################################################################
insert FormInputDateValue 
select t.DestID, t.Value
from LEGACYSPED.Transform_FormInputDateValue t
left join FormInputDateValue x on t.DestID = x.id
where x.id is null

-- ##########################################################################################################################################################
insert FormInputSingleSelectValue 
select t.DestID, t.Value -- not the name of the dest column - change later?
from LEGACYSPED.Transform_FormInputSingleSelectValue t
left join FormInputSingleSelectValue x on t.DestID = x.id
where x.id is null



---- ##########################################################################################################################################################
-- MAP table has already been inserted
insert LEGACYSPED.MAP_PrgSectionID (defid, versionid, destid)
select t.DefID, t.VersionID, DestID = newid()
from LEGACYSPED.Transform_PrgSection t 
left join LEGACYSPED.MAP_PrgSectionID x on t.destid = x.destid 
where t.VersionID is not null ---- non versioned uses a different map
and x.destid is null


-- looks like this is already inserted
insert LEGACYSPED.MAP_PrgSectionID_NonVersioned (DefID, ItemID, DestID)
select t.DefID, t.VersionID, DestID = newid()
from LEGACYSPED.Transform_PrgSection t 
left join LEGACYSPED.MAP_PrgSectionID x on t.destid = x.destid 
where t.VersionID is not null ---- non versioned uses a different map
and x.destid is null



---- ##########################################################################################################################################################
-- footer
insert PrgItemForm (ID, ItemID, CreatedDate, CreatedBy, AssociationTypeID)
select t.FormInstanceID, t.ItemID, t.CreatedDate, t.CreatedBy, t.AssociationTypeID
from LEGACYSPED.Transform_PrgSectionFormInstance t
left join PrgitemForm x on t.FormInstanceID = x.ID
where t.FormInstanceID is not null
and x.ID is null

---- header
insert PrgItemForm (ID, ItemID, CreatedDate, CreatedBy, AssociationTypeID)
select t.HeaderFormInstanceID, t.ItemID, t.CreatedDate, t.CreatedBy, t.AssociationTypeID
from LEGACYSPED.Transform_PrgSectionFormInstance t
left join PrgitemForm x on t.HeaderFormInstanceID = x.ID
where t.HeaderFormInstanceID is not null
and x.ID is null
---- 12250





update s set FormInstanceID = mfi.FormInstanceID, HeaderFormInstanceID = mfi.HeaderFormInstanceID
-- select CurrentFormInstanceID = s.FormInstanceID, mfi.FormInstanceID, CurrentHeaderFormInstanceID = s.HeaderFormInstanceID, mfi.HeaderFormInstanceID
from LEGACYSPED.MAP_IEPStudentRefID m
left join dbo.PrgItem i on m.DestID = i.ID
left join dbo.PrgVersion v on i.ID = v.ItemID 
left join dbo.PrgSection s on i.ID = s.ItemID 
left join dbo.PrgSectionDef sd on s.DefID = sd.ID
join LEGACYSPED.MAP_FormInstanceID mfi on m.IepRefID = mfi.ItemRefID and s.DefID = mfi.SectionDefID
where isnull(mfi.FormInstanceID, mfi.HeaderFormInstanceID) is not null
and isnull(s.FormInstanceID, s.HeaderFormInstanceID) is null


-- ##########################################################################################################################################################
-- versioned
insert PrgSection (ID, ItemID, DefID, FormInstanceID, HeaderFormInstanceID, OnLatestVersion)
select t.DestID, t.ItemID, t.DefID, t.FormInstanceID, t.HeaderFormInstanceID, t.OnLatestVersion
-- select t.*
from LEGACYSPED.Transform_PrgSection t
left join PrgSection x on t.DestID = x.id
where x.ID is null

-- non-versioned section insert
insert PrgSection (ID, ItemID, DefID, FormInstanceID, HeaderFormInstanceID, OnLatestVersion)
select t.DestID, t.ItemID, t.DefID, t.FormInstanceID, t.HeaderFormInstanceID, t.OnLatestVersion
-- select t.*
from LEGACYSPED.Transform_PrgSection t
left join PrgSection x on t.DestID = x.id
where t.VersionID is null 
and x.ID is null

---- ##########################################################################################################################################################

-- rollback 

commit


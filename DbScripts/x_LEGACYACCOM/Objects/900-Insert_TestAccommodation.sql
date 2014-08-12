IF EXISTS (SELECT 1 FROM sys.schemas s JOIN sys.objects o on s.schema_id = o.schema_id WHERE s.name = 'x_LEGACYACCOM' AND o.name = 'SCAccoms_ImportFormletData')
DROP PROC x_LEGACYACCOM.SCAccoms_ImportFormletData
GO

CREATE PROC x_LEGACYACCOM.SCAccoms_ImportFormletData
AS
BEGIN 
-- rollback 
--begin tran

-- select * from x_LEGACYACCOM.MAP_FormInstanceID
-- ########################################################################################################################################################## --- 55125 -inserting a row for all sections.
insert x_LEGACYACCOM.MAP_FormInstanceID (Item, ItemRefID, SectionDefID, FormInstanceID, FormInstanceIntervalID, HeaderFormInstanceID, HeaderFormInstanceIntervalID)
select t.Item, t.IEPRefID, t.SectionDefID, 
	FormInstanceID = case when t.FormTemplate is not null then newid() else NULL end, 
	FormInstanceIntervalID = case when t.FormTemplate is not null then newid() else NULL end, 
	HeaderFormInstanceID = case when t.HeaderFormTemplate is not null then newid() else NULL end, 
	HeaderFormInstanceIntervalID = case when t.HeaderFormTemplate is not null then newid() else NULL end
from x_LEGACYACCOM.Transform_PrgSectionFormInstance t
left join x_LEGACYACCOM.MAP_FormInstanceID m on t.IEPRefID = m.ItemRefID and t.SectionDefID = m.SectionDefID
where 1=1
--and t.IEPRefID = 19761 and t.SectionDefID = 'B1903FFA-D274-4009-8441-21D6F05BF1C4'
and isnull(m.FormInstanceID, m.HeaderFormInstanceID) is null




-- ##########################################################################################################################################################
-- Footer
insert FormInstance (ID, TemplateId)
select t.FormInstanceID, t.FormTemplateID -- footer
from x_LEGACYACCOM.Transform_PrgSectionFormInstance t
left join FormInstance x on t.FormInstanceID = x.id 
where t.FormTemplateID is not null
and x.id is null
---- 42875


---- Header
insert FormInstance (ID, TemplateId)
select t.HeaderFormInstanceID, t.HeaderFormTemplateID -- Header
from x_LEGACYACCOM.Transform_PrgSectionFormInstance t
left join FormInstance x on t.HeaderFormInstanceID = x.id
where t.HeaderFormTemplateID is not null
and x.id is null


-- ##########################################################################################################################################################
-- footer
insert FormInstanceInterval (ID, InstanceId, IntervalId, CompletedBy, CompletedDate)
select t.FormInstanceIntervalID, t.FormInstanceID, t.IntervalID, t.CompletedBy, t.CompletedDate
from x_LEGACYACCOM.Transform_PrgSectionFormInstance t
left join FormInstanceInterval x on t.FormInstanceIntervalID = x.ID
where t.FormInstanceIntervalID is not null
and x.ID is null

-- header
insert FormInstanceInterval (ID, InstanceId, IntervalId, CompletedBy, CompletedDate)
select t.HeaderFormInstanceIntervalID, t.HeaderFormInstanceID, t.IntervalID, t.CompletedBy, t.CompletedDate
from x_LEGACYACCOM.Transform_PrgSectionFormInstance t
left join FormInstanceInterval x on t.HeaderFormInstanceIntervalID = x.ID
where t.HeaderFormInstanceIntervalID is not null
and x.ID is null

--------------- moved this 20140625 -- begin tran
insert x_LEGACYACCOM.MAP_FormInputValueID (Item, IntervalID, InputFieldID, Sequence, DestID)
select t.Item, t.IntervalID, t.InputFieldID, t.Sequence, newid()
from x_LEGACYACCOM.Transform_FormInputValue t 
where DestID is null

-- ##########################################################################################################################################################
insert FormInputValue (ID, IntervalId, InputFieldId, Sequence)
select t.DestID, t.IntervalID, t.InputFieldID, t.Sequence
from x_LEGACYACCOM.Transform_FormInputValue t 
left join FormInputValue x on t.DestID = x.ID
where x.ID is null

-- ##########################################################################################################################################################
insert FormInputTextValue 
select t.DestID, t.Value
from x_LEGACYACCOM.Transform_FormInputTextValue t
left join FormInputTextValue x on t.DestID = x.id
where x.id is null

-- ##########################################################################################################################################################
insert FormInputFlagValue 
select t.DestID, t.Value
from x_LEGACYACCOM.Transform_FormInputFlagValue t
left join FormInputFlagValue x on t.DestID = x.id
where x.id is null

-- ##########################################################################################################################################################
insert FormInputDateValue 
select t.DestID, t.Value
from x_LEGACYACCOM.Transform_FormInputDateValue t
left join FormInputDateValue x on t.DestID = x.id
where x.id is null

-- ##########################################################################################################################################################
insert FormInputSingleSelectValue 
select t.DestID, t.Value -- not the name of the dest column - change later?
from x_LEGACYACCOM.Transform_FormInputSingleSelectValue t
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
from x_LEGACYACCOM.Transform_PrgSectionFormInstance t
left join PrgitemForm x on t.FormInstanceID = x.ID
where t.FormInstanceID is not null
and x.ID is null

---- header
insert PrgItemForm (ID, ItemID, CreatedDate, CreatedBy, AssociationTypeID)
select t.HeaderFormInstanceID, t.ItemID, t.CreatedDate, t.CreatedBy, t.AssociationTypeID
from x_LEGACYACCOM.Transform_PrgSectionFormInstance t
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
join x_LEGACYACCOM.MAP_FormInstanceID mfi on m.IepRefID = mfi.ItemRefID and s.DefID = mfi.SectionDefID
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



insert IepAssessments
select s.DestID, ParentsAreInformedID = NULL, UseBooleanParticipation = 0
from LEGACYSPED.MAP_PrgSectionID_NonVersioned s
where s.DefID = 'A0C84AE0-4F46-4DA5-9F90-D57AB212ED64'


insert IepAccommodations
select s.DestID, Explanation = NULL, TrackDetails = 0, TrackForAssessments = 0, NoAccommodationsRequired = 0, NoModificationsRequired = 0-- defaulting for the time beging
from LEGACYSPED.MAP_PrgSectionID s
where s.DefID = '4C01FA56-D3F6-47B1-BCDF-EBE7AB08A57C'



---- ##########################################################################################################################################################

-- rollback 

--commit tran 

END
GO

set nocount on;

-- Declare a temporary table to hold the data to be synchronized
DECLARE @FormTemplate TABLE (Id uniqueidentifier, Name varchar(50), TypeId uniqueidentifier, IntervalSeriesId uniqueidentifier, PageLength float, ProgramID uniqueidentifier, Code varchar(50), LastModifiedDate datetime, LastModifiedUserID uniqueidentifier)

-- Insert the data to be synchronized into the temporary table
INSERT INTO @FormTemplate VALUES ('876cf1e1-2e04-4f96-b15c-cb4b9d305ff9', N'Accommodations/Modifications', 'f4e41948-74c0-4bb5-b218-f2437c7b040b', '6e839019-46cc-4246-bb42-5ca42ed4ae6b', 11, 'f98a8ef2-98e2-4cac-95af-d7d89ef7f80c', N'AccomsMods', '9/10/2014 4:55:10 PM', 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB')

-- Declare a temporary table to hold the data to be synchronized
DECLARE @PrgSectionDef TABLE (ID uniqueidentifier, TypeID uniqueidentifier, ItemDefID uniqueidentifier, Sequence int, IsVersioned bit, Code varchar(50), Title varchar(50), VideoUrl varchar(200), HelpTextLegal text, HelpTextInfo text, FormTemplateID uniqueidentifier, DisplayPrevious bit, CanCopy bit, HeaderFormTemplateID uniqueidentifier, HelpTextState text)

-- Insert the data to be synchronized into the temporary table
INSERT INTO @PrgSectionDef VALUES ('43cd5045-8083-4534-ad66-a81c43a42f26', '265ac4ec-2325-4ca8-a428-5361dc7f83f0', '1984f017-51cb-4e3c-9b3a-338a9d409ec6', 4, 1, NULL, NULL, NULL, NULL, NULL, '876cf1e1-2e04-4f96-b15c-cb4b9d305ff9', 0, 0, NULL, NULL)

-- Declare a temporary table to hold the data to be synchronized
DECLARE @IepAccommodationsSectionDef TABLE (ID uniqueidentifier, TrackDetails bit, TrackForAssessments bit, UseDetails bit)

-- Insert the data to be synchronized into the temporary table
INSERT INTO @IepAccommodationsSectionDef VALUES ('43CD5045-8083-4534-AD66-A81C43A42F26', 0, 0, 0)

set nocount off
begin tran

-- Insert records in the destination tables that do not already exist
INSERT INTO FormTemplate (Id, Name, TypeId, IntervalSeriesId, PageLength, ProgramID, Code, LastModifiedDate, LastModifiedUserID) SELECT Source.* FROM @FormTemplate Source LEFT JOIN FormTemplate Destination ON Source.Id = Destination.Id WHERE Destination.Id IS NULL
INSERT INTO PrgSectionDef (ID, TypeID, ItemDefID, Sequence, IsVersioned, Code, Title, VideoUrl, HelpTextLegal, HelpTextInfo, FormTemplateID, DisplayPrevious, CanCopy, HeaderFormTemplateID, HelpTextState) SELECT Source.* FROM @PrgSectionDef Source LEFT JOIN PrgSectionDef Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
INSERT INTO IepAccommodationsSectionDef (ID, TrackDetails, TrackForAssessments, UseDetails) SELECT Source.* FROM @IepAccommodationsSectionDef Source LEFT JOIN PrgSectionDef Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL

SELECT Source.* 
FROM @IepAccommodationsSectionDef Source LEFT JOIN IepAccommodationsSectionDef Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL

rollback

SELECT Source.* 
FROM @IepAccommodationsSectionDef Source 
LEFT JOIN PrgSectionDef Destination ON Source.ID = Destination.ID 
-- WHERE Destination.ID IS NULL

select * from IepAccommodationsSectionDef where ID = '43CD5045-8083-4534-AD66-A81C43A42F26'

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



select * from student where Number = '189770934100'

select * from LEGACYSPED.student where StudentLocalID = '189770934100'

select s.* 
from PrgItem i
join PrgSection s on i.id = s.ItemID
join IepAccommodationsSectionDef a on s.DefID = a.ID
where StudentID = '59E47B7D-E3AA-40B2-A75E-51E55FFF73BE'

-- need to create a form instance, 
-- insert MAP table first
-- insert map forminstanceinterval
-- insert forminstanceinterval
-- insert FormInputValue (3 records)
-- insert FormInputFlagValue (1 record)
-- insert FormInputTextValue (2 records)

-- update PrgSection.FormInstanceID with new form instance ID




select * 
from x_LEGACYACCOM.FormInputFields where TemplateName = 'Accommodations/Modifications' and ControlType = 'Input Area'

--	DC181B1F-F381-470D-ACFD-5DED8F245B03	ModNec	Modifications necessary?	Flag
--	21D420C8-02B0-4442-A087-781BB4695C2A	Accomms	Accommodations	Text
--	75048692-5596-47E5-8BB0-F57D920F4B4B	Modifs	Modifications	Text

select * from PrgSectionType where ID = '265AC4EC-2325-4CA8-A428-5361DC7F83F0' --- Accommodations & Modifications

select * from PrgSectionDef where ID in ('4C01FA56-D3F6-47B1-BCDF-EBE7AB08A57C', '43cd5045-8083-4534-ad66-a81c43a42f26')


go

DECLARE @PrgSectionDef TABLE (ID uniqueidentifier, TypeID uniqueidentifier, ItemDefID uniqueidentifier, Sequence int, IsVersioned bit, Code varchar(50), Title varchar(50), VideoUrl varchar(200), HelpTextLegal text, HelpTextInfo text, FormTemplateID uniqueidentifier, DisplayPrevious bit, CanCopy bit, HeaderFormTemplateID uniqueidentifier, HelpTextState text)
INSERT INTO @PrgSectionDef VALUES ('43cd5045-8083-4534-ad66-a81c43a42f26', '265ac4ec-2325-4ca8-a428-5361dc7f83f0', '1984f017-51cb-4e3c-9b3a-338a9d409ec6', 4, 1, NULL, NULL, NULL, NULL, NULL, '876cf1e1-2e04-4f96-b15c-cb4b9d305ff9', 0, 0, NULL, NULL)

-- UPDATE Destination SET Destination.TypeID = Source.TypeID, Destination.ItemDefID = Source.ItemDefID, Destination.Sequence = Source.Sequence, Destination.IsVersioned = Source.IsVersioned, Destination.Code = Source.Code, Destination.Title = Source.Title, Destination.VideoUrl = Source.VideoUrl, Destination.HelpTextLegal = Source.HelpTextLegal, Destination.HelpTextInfo = Source.HelpTextInfo, Destination.FormTemplateID = Source.FormTemplateID, Destination.DisplayPrevious = Source.DisplayPrevious, Destination.CanCopy = Source.CanCopy, Destination.HeaderFormTemplateID = Source.HeaderFormTemplateID, Destination.HelpTextState = Source.HelpTextState 
select source.*
FROM @PrgSectionDef Source JOIN PrgSectionDef Destination ON Source.ID = Destination.ID

select Destination.*
FROM @PrgSectionDef Source JOIN PrgSectionDef Destination ON Source.ID = Destination.ID


x_datateam.findguid '4C01FA56-D3F6-47B1-BCDF-EBE7AB08A57C'



-- undo previous a&m import

--select * from dbo.SecurityTask where TargetID = '4C01FA56-D3F6-47B1-BCDF-EBE7AB08A57C'
--select * from dbo.SecurityTaskCategory where OwnerID = '4C01FA56-D3F6-47B1-BCDF-EBE7AB08A57C'


-- change data conversion code for LEGACYSPED.ImportPrgSections to use correct DefID
-- DONE


-- only necessary for DCB8, which used the wrong GUID

-- update LEGACYSPED.ImportPrgSections with correct SectionDefID
select * from LEGACYSPED.ImportPrgSections where SectionDefID = '4C01FA56-D3F6-47B1-BCDF-EBE7AB08A57C'


begin tran

update ips set SectionDefID = '43CD5045-8083-4534-AD66-A81C43A42F26' 
from LEGACYSPED.ImportPrgSections ips where SectionDefID = '4C01FA56-D3F6-47B1-BCDF-EBE7AB08A57C'



-- update LEGACYSPED.MAP_PrgSectionID with correct DefID
select * from LEGACYSPED.MAP_PrgSectionID where DefID = '4C01FA56-D3F6-47B1-BCDF-EBE7AB08A57C'

update m set DefID = '43CD5045-8083-4534-AD66-A81C43A42F26' from LEGACYSPED.MAP_PrgSectionID m 
where DefID = '4C01FA56-D3F6-47B1-BCDF-EBE7AB08A57C'




-- update DefID
select * from dbo.PrgSection where DefID = '4C01FA56-D3F6-47B1-BCDF-EBE7AB08A57C'

update s set DefID = '43CD5045-8083-4534-AD66-A81C43A42F26' from dbo.PrgSection s
where DefID = '4C01FA56-D3F6-47B1-BCDF-EBE7AB08A57C'


-- delete IepAccommodationsSectionDef record
select * from dbo.IepAccommodationsSectionDef where ID = '4C01FA56-D3F6-47B1-BCDF-EBE7AB08A57C'


delete IepAccommodationsSectionDef where ID = '4C01FA56-D3F6-47B1-BCDF-EBE7AB08A57C'


-- delete PrgSectionDef record
select * from dbo.PrgSectionDef where ID = '4C01FA56-D3F6-47B1-BCDF-EBE7AB08A57C'

delete PrgSectionDef where ID = '4C01FA56-D3F6-47B1-BCDF-EBE7AB08A57C'


rollback

commit


update PrgSection set FormInstanceID = 'xxx'
where DefID =  '43CD5045-8083-4534-AD66-A81C43A42F26'

--select * from PrgSectionDef where ID = '43CD5045-8083-4534-AD66-A81C43A42F26'

--select * from LEGACYSPED.MAP_PrgSectionID where DefID = '43CD5045-8083-4534-AD66-A81C43A42F26'

--select * from LEGACYSPED.MAP_FormInstanceID where SectionDefID = '43CD5045-8083-4534-AD66-A81C43A42F26'

insert x_LEGACYACCOM.MAP_FormInstanceID (Item, ItemRefID, SectionDefID, FormInstanceID, FormInstanceIntervalID)
select 'IEP', IEPRefID ItemRefID, SectionDefID, newid() FormInstanceID, newid() FormInstanceIntervalID
from x_LEGACYACCOM.Transform_PrgSectionFormInstance
where SectionDefID = '43CD5045-8083-4534-AD66-A81C43A42F26'
and FormInstanceID is null

-- select * from x_LEGACYACCOM.Transform_PrgSectionFormInstance where SectionDefID = '43CD5045-8083-4534-AD66-A81C43A42F26'

-- select * from x_LEGACYACCOM.MAP_FormInstanceID where SectionDefID = '43CD5045-8083-4534-AD66-A81C43A42F26'

insert FormInstance (ID, TemplateId, FormInstanceBatchId)
select FormInstanceID, FormTemplateID, NULL
from x_LEGACYACCOM.Transform_PrgSectionFormInstance 
where SectionDefID = '43CD5045-8083-4534-AD66-A81C43A42F26'



insert FormInstanceInterval (ID, InstanceID, IntervalID, CompletedDate, CompletedBy)
select fi.FormInstanceIntervalID, fi.FormInstanceID, fi.IntervalID, fi.CompletedDate, fi.CompletedBy
from x_LEGACYACCOM.Transform_PrgSectionFormInstance fi
where SectionDefID = '43CD5045-8083-4534-AD66-A81C43A42F26'

--select * from LEGACYSPED.Transform_PrgSection where DefID = '43CD5045-8083-4534-AD66-A81C43A42F26'


select fi.IepRefID, fi.ItemID, fi.SectionDefID, fi.FormInstanceID
from x_LEGACYACCOM.Transform_PrgSectionFormInstance fi
join LEGACYSPED.Transform_PrgSection s on fi.ItemID = s.ItemID 
where fi.SectionDefID = '43CD5045-8083-4534-AD66-A81C43A42F26'
and s.DefID = '43CD5045-8083-4534-AD66-A81C43A42F26'


select s.ID, s.FormInstanceID
from x_LEGACYACCOM.Transform_PrgSectionFormInstance fi
join LEGACYSPED.MAP_PrgSectionID m on fi.SectionDefID = m.DefID 
join LEGACYSPED.MAP_PrgVersionID v on m.VersionID = v.DestID and fi.IEPRefID = v.IepRefID
join PrgSection s on m.DestID = s.ID
where m.DefID = '43CD5045-8083-4534-AD66-A81C43A42F26'

select * from PrgSection where DefID = '43CD5045-8083-4534-AD66-A81C43A42F26'

select * from LEGACYSPED.MAP_PrgSectionID_NonVersioned where DefID = '43CD5045-8083-4534-AD66-A81C43A42F26'

select * from LEGACYSPED.MAP_PrgVersionID

-- find out why this was not populated in the first place.  check the test accom version id
update s set VersionID = ts.VersionID
-- select ts.VersionID, s.VersionID
from LEGACYSPED.Transform_PrgSection ts 
join PrgSection s on ts.DestID = s.ID
where ts.DefID = '43CD5045-8083-4534-AD66-A81C43A42F26'

update s set FormInstanceID = fi.FormInstanceID
-- select s.ID, s.FormInstanceID, fi.FormInstanceID
from x_LEGACYACCOM.Transform_PrgSectionFormInstance fi
join LEGACYSPED.MAP_PrgSectionID m on fi.SectionDefID = m.DefID 
join LEGACYSPED.MAP_PrgVersionID v on m.VersionID = v.DestID and fi.IEPRefID = v.IepRefID
join PrgSection s on m.DestID = s.ID
where m.DefID = '43CD5045-8083-4534-AD66-A81C43A42F26'
--Msg 547, Level 16, State 0, Line 1
--The UPDATE statement conflicted with the FOREIGN KEY constraint "FK_PrgSection#FormInstance#". The conflict occurred in database "Enrich_DCB8_SC_Demo", table "dbo.PrgItemForm", column 'ID'.
--The statement has been terminated.

select mf.ItemRefID, mf.SectionDefID, mf.FormInstanceID , mi.DestID ItemID
from x_LEGACYACCOM.MAP_FormInstanceID mf
join LEGACYSPED.MAP_IEPStudentRefID mi on mf.ItemRefID = mi.IepRefID
where SectionDefID = '43CD5045-8083-4534-AD66-A81C43A42F26'

select ID, ItemID, CreatedDate, CreatedBy, AssociationTypeID
from PrgItemForm

insert PrgItemForm (ID, ItemID, CreatedDate, CreatedBy, AssociationTypeID)
select t.FormInstanceID, t.ItemID, t.CreatedDate, t.CreatedBy, t.AssociationTypeID
from x_LEGACYACCOM.Transform_PrgSectionFormInstance t
left join PrgItemForm pif on t.FormInstanceID = pif.ID
where t.SectionDefID = '43CD5045-8083-4534-AD66-A81C43A42F26'
and pif.id is null


update s set FormInstanceID = fi.FormInstanceID
-- select s.ID, s.FormInstanceID, fi.FormInstanceID
from x_LEGACYACCOM.Transform_PrgSectionFormInstance fi
join LEGACYSPED.MAP_PrgSectionID m on fi.SectionDefID = m.DefID 
join LEGACYSPED.MAP_PrgVersionID v on m.VersionID = v.DestID and fi.IEPRefID = v.IepRefID
join PrgSection s on m.DestID = s.ID
where m.DefID = '43CD5045-8083-4534-AD66-A81C43A42F26'




select * from x_LEGACYACCOM.Transform_PrgSectionFormInstance



--select * from PrgSectionDef where ID = '43CD5045-8083-4534-AD66-A81C43A42F26' -- isversioned = 1
--select * from x_LEGACYACCOM.Transform_PrgSectionFormInstance where SectionDefID <> '43CD5045-8083-4534-AD66-A81C43A42F26'
--select * from PrgSection where DefID = 'A0C84AE0-4F46-4DA5-9F90-D57AB212ED64'
--select * from PrgSectionDef where ID = 'A0C84AE0-4F46-4DA5-9F90-D57AB212ED64' ---------------- not versioned, so it is okay.


-- insert FormInputValue (3 records)
-- insert FormInputFlagValue (1 record)
-- insert FormInputTextValue (2 records)



select * from FormInputValue

select * from x_LEGACYACCOM.MAP_FormInputValueID where intervalid = '971DA6C9-F96A-47DD-8B0D-06E09CADCEAF'

select * 
from x_LEGACYACCOM.FormInputFields f


select f.* 
from x_LEGACYACCOM.MAP_FormInputValueID v
join x_LEGACYACCOM.FormInputFields f on v.InputFieldID = f.InputFieldID
where v.intervalid = '971DA6C9-F96A-47DD-8B0D-06E09CADCEAF'


select * from x_LEGACYACCOM.MAP_FormInputValueID

select * 
from x_LEGACYACCOM.FormInputFields f
where TemplateName = 'Accommodations/Modifications' and ControlType = 'Input Area'

select *
from x_LEGACYACCOM.Transform_FormInputValue



-- select aa.* INTO x_LEGACYACCOM.EO_IEPAccomModListTbl_SC_RAW

select IEPComplSeqNum = x.IEPSeqNum, m.IEPModSeq, m.SupplementAids, ProgramModify = isnull(m.ProgramModify,0), m.Modifications
into x_LEGACYACCOM.EO_ICIEPModTbl_SC_RAW 
from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.SpecialEdStudentsAndIEPs x
left join [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.ICIEPModTbl_SC m on x.IEPSeqNum = m.IEPComplSeqNum
--where x.GStudentID = '010DF00C-8F35-4920-9662-002632D600E2'




--drop table x_LEGACYACCOM.ClassroolAccomMod_LOCAL -- misspelled


select * from x_LEGACYACCOM.EO_ICIEPModTbl_SC_RAW 

--------------------------------------------------------------------------------------------- x_LEGACYACCOM.ClassroolAccomMod_LOCAL
if object_id('x_LEGACYACCOM.ClassroomAccomMod_LOCAL') is not null
drop table x_LEGACYACCOM.ClassroomAccomMod_LOCAL

-- using this for performance when we union all of the forminputfields together
select IEPRefID = IEPComplSeqNum, SubRefID = IEPModSeq, ModifyYN = ProgramModify, Accoms = SupplementAids, Mods = Modifications
into x_LEGACYACCOM.ClassroomAccomMod_LOCAL
from x_LEGACYACCOM.EO_ICIEPModTbl_SC_RAW r
-- where IEPModSeq is not null -- we should not use a left join for this view. handle missing later.

alter table x_LEGACYACCOM.ClassroomAccomMod_LOCAL add constraint PK_ClassroomAccomMod_LOCAL_IepRefID primary key (IepRefID)
go





-- exec x_DATATEAM.FormletPivotViewGenerator_TextOutput 'IEP', 'x_LEGACYACCOM.ClassroomAccomMod_LOCAL', '', 'Accommodations/Modifications', 'ClassroomAccomMod'

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


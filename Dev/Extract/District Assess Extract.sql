
if object_id('x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL') is not null
drop table x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL
go

create table x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL (
IEPRefID	int not null,
SubRefID	int not null,
DistAssesstitle varchar(100)  null,
Participation varchar(max) null, -- this is a GUID, but we treat as varchar for a reason (union all with values view)
Accommodations text NULL,
Sequence int not null
)

alter table x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL 
	add constraint PK_x_LEGACYACCOM_EO_DistrictTestAccomm_LOCAL primary key (SubRefID)
go

create index IX_x_LEGACYACCOM_EO_DistrictTestAccomm_LOCAL_IEPComplSeqNum on x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL (IEPRefID)
go


-- get the GUIDs for the Single Select
--select ID, Label from dbo.FormTemplateInputSelectFieldOption where SelectFieldId = 'CA1A4A5F-FE71-4379-866A-522CFE2B2959' order by sequence

---- District assessments completed IEPs
insert x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL 
select m.IEPRefID, SubRefID = a.IEPAccomSeq,
	DistAssessTitle = case isnull(a2.DistAssess,0) when 2 then cast(a2.AltAssess as varchar(100)) when 1 then a2.DistAssessTitle end,
	Participation = 
		case isnull(a2.DistAssess,0) when 3 then NULL -- District Assessment Not Applicable
			when 2 then '1A5FC3E2-4C97-4323-976A-D9D129D92414' --1A5FC3E2-4C97-4323-976A-D9D129D92414	Non-standard with modifications
			when 1 then 
				case 
					when acc.Accommodations is null then '024F58CF-A177-426B-AE43-7F758962752F' --024F58CF-A177-426B-AE43-7F758962752F	Standard, no accommodations
					else '5D3D44BA-3348-4E5A-A321-5253F76DFEC8' --5D3D44BA-3348-4E5A-A321-5253F76DFEC8	Standard, with accommodations
				end
		end,
	Accommodations = 
		case isnull(a2.DistAssess,0) when 3 then NULL -- N/A in the EO UI
			when 0 then NULL
			else '<ul>'+acc.Accommodations+'</ul>' -- 1 Accommodations, 2 Modifications (non-standard means Alternate district assessment, with modifications, per Enrich UI drop-down)
		end,
	Sequence = 0 -- hard coding to cheat here - we only have 1 district assessment in EO
from LEGACYSPED.MAP_IEPStudentRefID m
join x_LEGACYACCOM.EO_IEPAccomModTbl_RAW a on m.StudentRefID = a.GStudentID
join x_LEGACYACCOM.EO_IEPAccomModTbl_SC_RAW a2 on a.IEPAccomSeq = a2.IEPAccomSeq and isnull(a2.del_flag,0)=0 and isnull(a.del_flag,0)=0
join (
	select a1.IEPAccomSeq,
		Accommodations = (
			select li = t1.AccomDesc -- column name will be used as a tag 
			from x_LEGACYACCOM.EO_IEPAccomModListTbl_SC_RAW t1
			where a1.IEPAccomSeq = t1.IEPAccomSeq 
			and t1.AccomType = 'AC12' 
			and isnull(a1.del_flag,0)=0 and isnull(t1.del_flag,0)=0
			for xml path('')
			)
	from x_LEGACYACCOM.EO_IEPAccomModTbl_RAW a1 
) acc on a.IEPAccomSeq = acc.IEPAccomSeq
go












-- exec x_DATATEAM.FormletPivotViewGenerator_TextOutput 'IEP', 'x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL', 'x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL', 'Assessments', 'ConvertedAssessments'
	-- note: we cheated by putting the table name in the 1:M field in the procedure call. we know we'll get away with it because we know we only have 1 dist assess in EO


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



--insert the PrgSection record
-- insert the IepAssessments section record

-- There is a header formlet and a footer formlet in this section. ( I liked, but the FormInputFields view thinks it has both)

--select st.name, sd.*
--from PrgItemDef id
--join PrgSectionDef sd on id.id = sd.ItemDefID
--join PrgSectionType st on sd.TypeID = st.ID
--where id.name like 'Conv%'
--and st.name like '%ass%'


--select st.Name, t.DefId, count(*) 
--from LEGACYSPED.Transform_PrgSection t
--left join dbo.PrgSectionDef sd on t.DefID = sd.ID
--left join dbo.PrgSectionType st on sd.TypeID = st.ID
--group by st.Name, t.DefId



-- Must enable the sections in LEGACYSPED.ImportPrgSections
	-- then import those two sections in to the MAP table(s).  
	-- Transform should take care of versioned or non-versioned 
	-- import into both the versioned and non-versioned maps, if necessary.


insert PrgSection (ID, ItemID, DefID, VersionID, OnLatestVersion)
select t.DestID, t.ItemID, t.DefID, t.VersionID, t.OnLatestVersion
from LEGACYSPED.Transform_PrgSection t
left join PrgSection x on t.DestID = x.ID
where 1=1
and t.DestID is not null
and x.ID is null

insert IepAssessments (ID, ParentsAreInformedID, UseBooleanParticipation)
select DestID, ParentsAreInformedID = cast(NULL as uniqueidentifier), UseBooleanParticipation = cast(0 as bit)
from LEGACYSPED.Transform_PrgSection t
left join IepAssessments x on t.DestID = x.ID 
where t.DefID = 'A0C84AE0-4F46-4DA5-9F90-D57AB212ED64' -- A0C84AE0-4F46-4DA5-9F90-D57AB212ED64
and x.ID is null


insert IepAccommodations (ID, Explanation, TrackDetails, TrackForAssessments, NoAccommodationsRequired, NoModificationsRequired)
select DestID, Explanation = NULL, TrackDetails = 0, TrackForAssessments = 0, NoAccommodationsRequired = 0, NoModificationsRequired = 0
from LEGACYSPED.Transform_PrgSection t
left join IepAccommodations x on t.DestID = x.ID 
where t.DefID = '4C01FA56-D3F6-47B1-BCDF-EBE7AB08A57C'
and x.ID is null








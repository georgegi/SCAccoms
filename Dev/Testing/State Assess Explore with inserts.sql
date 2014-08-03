
alter view x_DATATEAM.FindProgramData
as
select s.Number, S.Firstname, s.Lastname, 
	ItemType = it.Name, ItemDef = id.Name, 
	SectionType = st.Name, SectionTitle = sd.Title, 
	sd.FormTemplateID, sd.HeaderFormTemplateID,
	ps.ItemID, SectionID = ps.ID, i.StudentID
from Student s
join PrgItem i on s.ID = i.StudentID
join PrgItemDef id on i.DefID = id.ID
join PrgItemType it on id.TypeID = it.ID
join PrgSection ps on i.ID = ps.ItemID
join PrgSectionDef sd on ps.DefID = sd.ID
join PrgSectionType st on sd.TypeID = st.ID
go

select * 
from x_DATATEAM.FindProgramData where Number = '930677080000' and sectiontype like '%assess%'

select * from IepAssessments where ID = '34131D7F-0505-40D3-B78A-814CA8DC1E6C'

select * from 


select * from Student where Number = '930677080000'

--Alternate
--Standard
--Std w/ Accom
--Non-Standard
--Not in group









select td.Name, td.Sequence, MinGrade = gmin.Name, MaxGrade = gmax.Name
from IepTestDef td
join GradeLevel gmin on td.MinGradeID = gmin.ID
join GradeLevel gmax on td.MaxGradeID = gmax.ID
where td.name not like 'NAEP%'
and '07' between gmin.Name and gmax.Name
order by MinGrade
-- bull's EYE

-- command decision:  insert rows for all tests for all students regardless of grade. we'll deal with consequences afterward if nec.


--insert IepTestParticipation
--select ID = newiD(), 
--	InstanceID = '34131D7F-0505-40D3-B78A-814CA8DC1E6C', m.TestDefID, ParticipationDefID = NULL, IsParticipating = 0
--from LEGACYSPED.MAP_TestDefID m
--left join IepTestParticipation x on m.TestDefID = x.TestDefID and x.InstanceID = '34131D7F-0505-40D3-B78A-814CA8DC1E6C'
--where x.ID is null



select p.ParticipationTypeCode, p.ParticipationType 
from LEGACYSPED.StateDistrictParticipationDef p 
where p.ParticipationTypeCode <> 4 
order by ParticipationTypeCode


select 
	IEPRefID = al.IEPComplSeqNum, 
	TestAccommRefID = al.IEPAccomSeq, 
	TestDefID = td.ID,
	TestName = tn.EnrichTestName, 
	OtherDesc = '', 
	td.IsState, 
	ParticipationType = '', 
	AccomOkay = 1
from LEGACYSPED.EO_ICIEPAccomModTbl_SC_RAW al
--join LEGACYSPED.MAP_TestNames tn on al.AccomType = tn.EOTestCode -- cannot join to this table just to see if they take test
join IepTestDef td on tn.EnrichTestName = td.Name

go

-- try again to show which tests they are taking
















-- participation map
select * from LEGACYSPED.StateDistrictParticipationDef

-- test def map
select * from LEGACYSPED.MAP_TestDefID



if object_id('LEGACYSPED.Transform_IepTestParticipation') is not null
drop view LEGACYSPED.Transform_IepTestParticipation
go

create view LEGACYSPED.Transform_IepTestParticipation
as
select 
	etp.IepRefID,
	etp.TestAccommRefID,
	etp.TestName, 
	etp.OtherDesc, 
	etp.IsState, 
	etp.ParticipationType, 
	-- IepTestParticipation
	DestID = m.DestID,
	InstanceID = m.DestID,
	TestDefID = itd.ID, 
	ParticipationDefID = case etp.IsState when 0 then tpd.DistrictParticipationDefID when 1 then tpd.StateParticipationDefID end
from LEGACYSPED.Transform_PrgIep iep join 
	LEGACYSPED.EO_TestParticipation etp on iep.IepRefID = etp.IEPRefID join -- test and participation from legacy data
	dbo.IepTestDef itd on etp.TestName = itd.Name and etp.IsState = itd.IsState join -- "other 2" from Encore is not represented in Enrich
	LEGACYSPED.StateDistrictParticipationDef tpd on etp.ParticipationType = tpd.ParticipationType join 
	LEGACYSPED.MAP_PrgSectionID m on 
		m.DefID = '6B65D022-365A-42F3-979E-73F7A887C2C4' and -- Iep Assessments
		m.VersionID = iep.VersionDestID left join 
	IepTestParticipation tp on 
		itd.id = tp.TestDefID and
		m.DestID = tp.InstanceID
--where tp.ID is null 
go

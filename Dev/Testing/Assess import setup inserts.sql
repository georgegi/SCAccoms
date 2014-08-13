
if not exists (select 1 from IepAccommodationCategory where ID = 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E')
insert dbo.IepAccommodationCategory values ('B90D4D56-4A20-4901-BD7B-2FC99BF5D42E', 'Excent Online Assess Accom (DO NOT USE)', 0)
-- insert dbo.IepAccommodationDef (ID, CategoryID, Text, IsValidWithoutTest, IsNonStandard, IsModification, DeletedDate) values ('FE35256C-C18A-4B09-9AF6-11E1762268AF', 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E', 'Extended Breaks', 0, 0, 0, getdate())


-- select * from IepAccommodationCategory where ID = 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E'


-- THIS QUERY GENERATES THE ABOVE DEF RECORDS
-- this may be built from a view of accom data on the remote server (for speed)
insert IepAccommodationDef (ID, CategoryID, Text, IsValidWithoutTest, IsNonStandard, IsModification, DeletedDate)
select t.*
from (
select ID = NewID(), CategoryID = 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E', Text = convert(varchar(100), aa.AccomDesc), IsValidWithoutTest = 0, IsNonstandard = 0, 
	IsModification = case when aa.AccomCode like '%MOD%' then 1 else 0 end, -- set this correctly based on the accomcode
	DeletedDate = getdate()
from LEGACYSPED.MAP_IEPStudentRefID s
join x_LEGACYACCOM.EO_IEPAccomModTbl_RAW a on s.StudentRefID = a.GStudentID
join x_LEGACYACCOM.EO_IEPAccomModListTbl_SC_RAW aa on a.iepaccomseq = aa.iepaccomseq
group by convert(varchar(100), aa.AccomDesc), case when aa.AccomCode like '%MOD%' then 1 else 0 end
) t 
left join IepAccommodationDef x on t.CategoryID = x.CategoryID and t.text = x.Text
where x.id is null



-- why do only 6 show in the UI? There are 11 in the db
select ID, InstanceID, TestDefID, ParticipationDefID, IsParticipating from IepTestParticipation p --where exists (select 1 from IepAllowedTestParticipation a where a.TestDefID = p.TestDefID)
--and p.InstanceID = '34131D7F-0505-40D3-B78A-814CA8DC1E6C'


select * from x_LEGACYACCOM.MAP_TestDefID

select * from IepTestParticipation


insert IepTestParticipation
select ID = newiD(), InstanceID = '34131D7F-0505-40D3-B78A-814CA8DC1E6C', m.TestDefID, ParticipationDefID = NULL, IsParticipating = 0
from x_LEGACYACCOM.MAP_TestDefID m
left join IepTestParticipation x on m.TestDefID = x.TestDefID and x.InstanceID = '34131D7F-0505-40D3-B78A-814CA8DC1E6C'
where x.ID is null

-- this did the trick.  cannot see the tests in UI until this is inserted (all tests for all students).
-- note: it seems not to show up if the test def is not approrpriate for the grade level

select * from x_LEGACYACCOM.MAP_TestDefID 


select ID = newiD(), InstanceID = '34131D7F-0505-40D3-B78A-814CA8DC1E6C', m.TestDefID, ParticipationDefID = NULL, IsParticipating = 0
from x_LEGACYACCOM.MAP_TestDefID m
left join IepTestParticipation x on m.TestDefID = x.TestDefID and x.InstanceID = '34131D7F-0505-40D3-B78A-814CA8DC1E6C'
where x.ID is null

x_datateam.findguid 'FDADC456-9911-47DA-89F5-6DD8F1C717E1'


--select * from Student where ID = '5553B53F-9FD8-4947-92F2-E83B1799E8B1'
--select * from PrgItem where ID = '74E32240-FD3E-4DFC-A08C-7D10CD8943C6'
select * from dbo.PrgSection where ID = 'FDADC456-9911-47DA-89F5-6DD8F1C717E1'
select * from dbo.IepAssessments where ID = 'FDADC456-9911-47DA-89F5-6DD8F1C717E1'
	--select * from dbo.IepJustification where InstanceID = 'FDADC456-9911-47DA-89F5-6DD8F1C717E1' -- ID = newid(), InstanceID, DefID = '1CBE17DF-CEFA-446B-A203-8B0955ADECE0', IsEnabled = 0
select * from dbo.IepTestParticipation where InstanceID = 'FDADC456-9911-47DA-89F5-6DD8F1C717E1'

-- x_datateam.findguid '1CBE17DF-CEFA-446B-A203-8B0955ADECE0'

--select * from dbo.IepJustificationDef where ID = '1CBE17DF-CEFA-446B-A203-8B0955ADECE0' -- State Testing Participation	Provide reason for student to not participate in any particular state assessments




select * from IepTestParticipation 


select * 
from IepAssessments







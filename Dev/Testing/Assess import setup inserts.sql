
if not exists (select 1 from IepAccommodationCategory where ID = 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E')
insert dbo.IepAccommodationCategory values ('B90D4D56-4A20-4901-BD7B-2FC99BF5D42E', 'Excent Online Assess Accom (DO NOT USE)', 0)
-- insert dbo.IepAccommodationDef (ID, CategoryID, Text, IsValidWithoutTest, IsNonStandard, IsModification, DeletedDate) values ('FE35256C-C18A-4B09-9AF6-11E1762268AF', 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E', 'Extended Breaks', 0, 0, 0, getdate())


-- THIS QUERY GENERATES THE ABOVE DEF RECORDS
-- this may be built from a view of accom data on the remote server (for speed)
insert IepAccommodationDef (ID, CategoryID, Text, IsValidWithoutTest, IsNonStandard, IsModification, DeletedDate)
select t.*
from (
select ID = NewID(), CategoryID = 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E', Text = convert(varchar(100), aa.AccomDesc), IsValidWithoutTest = 0, IsNonstandard = 0, 
	IsModification = case when aa.AccomCode like '%MOD%' then 1 else 0 end, -- set this correctly based on the accomcode
	DeletedDate = getdate()
from LEGACYSPED.MAP_IEPStudentRefID s
join LEGACYSPED.EO_ICIEPAccomModTbl_RAW a on s.IEPRefID = a.iepcomplseqnum
join LEGACYSPED.EO_ICIEPAccomModListTbl_SC_RAW aa on a.iepcomplseqnum = aa.iepcomplseqnum and a.iepaccomseq = aa.iepaccomseq
group by convert(varchar(100), aa.AccomDesc), case when aa.AccomCode like '%MOD%' then 1 else 0 end
) t 
left join IepAccommodationDef x on t.CategoryID = x.CategoryID and t.text = x.Text
where x.id is null



-- why do only 6 show in the UI? There are 11 in the db
select ID, InstanceID, TestDefID, ParticipationDefID, IsParticipating from IepTestParticipation p --where exists (select 1 from IepAllowedTestParticipation a where a.TestDefID = p.TestDefID)
--and p.InstanceID = '34131D7F-0505-40D3-B78A-814CA8DC1E6C'





insert IepTestParticipation
select ID = newiD(), InstanceID = '34131D7F-0505-40D3-B78A-814CA8DC1E6C', m.TestDefID, ParticipationDefID = NULL, IsParticipating = 0
from LEGACYSPED.MAP_TestDefID m
left join IepTestParticipation x on m.TestDefID = x.TestDefID and x.InstanceID = '34131D7F-0505-40D3-B78A-814CA8DC1E6C'
where x.ID is null

-- this did the trick.  cannot see the tests in UI until this is inserted (all tests for all students).
-- note: it seems not to show up if the test def is not approrpriate for the grade level

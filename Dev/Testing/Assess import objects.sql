if object_id('LEGACYSPED.StateDistrictParticipationDef ') is not null
drop view LEGACYSPED.StateDistrictParticipationDef 
go

create view LEGACYSPED.StateDistrictParticipationDef
as
/* 
	There are 2 Participation Def records with the name "Alternate", one for District and one for State tests
	Where there is an Alternate participation in the legacy data, we need to associate it with the proper participation def in Enrich
	To do so, we will create a view that identifies which is which 
	Then we will use this view in Transform_IepTestParticipation to get the correct ParticipationDef ID
	If the same participation def ID is used for both State and District test, as in the case of "Regular" no harm done
*/
select 
	ParticipationTypeCode = case pd.text
		when 'Standard' then 1 -- arbitrary values in a logical order, to avoid spelling issues in joins
		when 'Std w/ Accom' then 2
		when 'Non-Standard' then 3
		when 'Alternate' then 4
		when 'Not in group' then 5
	end,
	td.IsState,
	ParticipationType = pd.Text, 
	DistrictParticipationDefID = max(convert(varchar(36), pdd.ID)),
	StateParticipationDefID = max(convert(varchar(36), pds.ID))
from IepAllowedTestParticipation atp 
join IepTestDef td on atp.TestDefID = td.ID
join IepTestParticipationDef pd on atp.ParticipationDefID = pd.ID -- one row each
left join IepTestParticipationDef pdd on atp.ParticipationDefID = pdd.ID and td.IsState = 0
left join IepTestParticipationDef pds on atp.ParticipationDefID = pds.ID and td.IsState = 1
where pd.text in ('Not in group', 'Standard', 'Std w/ Accom', 'Alternate', 'Non-Standard')  -- these are the only ones coming from Excent Online
group by pd.Text, td.IsState
go




if object_id('LEGACYSPED.MAP_TestDefID') is not null -- this does not follow naming convention. this is a view, not a table
drop view LEGACYSPED.MAP_TestDefID
go

create view LEGACYSPED.MAP_TestDefID
as
select TestDefID = td.ID, t.*
from LEGACYSPED.MAP_TestNames t
join IepTestDef td on t.EnrichTestName = td.Name
go








-- temporary data fill to see in UI
insert IepTestParticipation
select ID = NewID(), Instance = s.ID, m.TestDefID, ParticipationDefID = NULL, IsParticipating = 0
from PrgItem i 
join PrgSection s on i.ID = s.ItemID
join IepAssessments a on s.ID = a.ID
cross join LEGACYSPED.MAP_TestDefID m
left join IepTestParticipation x on m.TestDefID = x.TestDefID and s.id = x.InstanceID 
where i.DefID = (select ID from PrgItemDef where name = 'Converted Data')
and x.ID is null



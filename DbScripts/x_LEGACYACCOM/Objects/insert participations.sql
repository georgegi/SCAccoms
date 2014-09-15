--select * from x_LEGACYACCOM.EO_StateAccomParticipation_LOCAL

insert IepTestParticipation
select ID = newiD(), InstanceID = '34131D7F-0505-40D3-B78A-814CA8DC1E6C', m.TestDefID, ParticipationDefID = NULL, IsParticipating = 0
from x_LEGACYACCOM.MAP_TestDefID m
left join IepTestParticipation x on m.TestDefID = x.TestDefID and x.InstanceID = '34131D7F-0505-40D3-B78A-814CA8DC1E6C'
where x.ID is null



select * from IepTestParticipation

insert IepTestParticipation (ID, InstanceID, TestDefID, ParticipationDefID, IsParticipating)
select ID = newid(), sap.InstanceID, sap.TestDefID, ParticipationDefID = sap.StateParticipationDefID, IsParticipating = case isnull(sap.Participation,'Not in group') when 'Not in group' then 0 else 1 end
from x_LEGACYACCOM.EO_StateAccomParticipation_LOCAL sap
left join IepTestParticipation itp on sap.InstanceID = itp.InstanceID and sap.TestDefID = itp.TestDefID
where itp.ID is null


select *from legacysped.student 



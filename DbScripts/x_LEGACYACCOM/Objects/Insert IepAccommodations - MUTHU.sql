select * from IepAccommodation


select * 
from x_LEGACYACCOM.Transform_PrgSectionFormInstance


create x_LEGACYACCOM.Transform_IepAccommodation

select DestID, Explanation = NULL, TrackDetails = 0, TrackForAssessments = 0, NoAccommodationsRequired = something, NoModificationsRequired = somethingelse
from LEGACYSPED.Transform_PrgSection where DefID = '43CD5045-8083-4534-AD66-A81C43A42F26'
go

if object_id('x_LEGACYACCOM.Transform_IepAccommodations') is not null
drop view x_LEGACYACCOM.Transform_IepAccommodations
go

create view x_LEGACYACCOM.Transform_IepAccommodations
as
select s.DestID, Explanation = cast (NULL as VARCHAR(max)), TrackDetails = 0, TrackForAssessments = 0, 
	NoAccommodationsRequired = case when isnull(c.Accoms, 'NA') in ('NA', 'N/A', '', 'None') then 1 else 0 end,
	NoModificationsRequired = abs(1-c.ModifyYN)
	--, c.Accoms, c.Mods -- testing only
from LEGACYSPED.MAP_PrgSectionID s 
join LEGACYSPED.MAP_PrgVersionID v on s.VersionID = v.DestID
join x_LEGACYACCOM.ClassroomAccomMod_LOCAL c on v.IepRefID = c.IEPRefID
where s.DefID = '43CD5045-8083-4534-AD66-A81C43A42F26'
go

insert IepAccommodations (ID, Explanation, TrackDetails, TrackForAssessments, NoAccommodationsRequired, NoModificationsRequired)
select t.DestID, t.Explanation, t.TrackDetails, t.TrackForAssessments, t.NoAccommodationsRequired, t.NoModificationsRequired
from x_LEGACYACCOM.Transform_IepAccommodations t
left join IepAccommodations a on t.DestID = a.ID
where a.id is null
go




select *
from x_LEGACYACCOM.ClassroomAccomMod_LOCAL



-- select * from PrgSectionDef where ID = '43CD5045-8083-4534-AD66-A81C43A42F26'

select * from PrgSectionDef where ID = '43CD5045-8083-4534-AD66-A81C43A42F26'
select * from PrgSectionType where ID = '265AC4EC-2325-4CA8-A428-5361DC7F83F0'

select * from IepAccommodations

select * from FormTemplate where ID = '876CF1E1-2E04-4F96-B15C-CB4B9D305FF9'

select * from PrgSectionDef where FormTemplateID = '876CF1E1-2E04-4F96-B15C-CB4B9D305FF9'





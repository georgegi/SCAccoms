if object_id('LEGACYSPED.MAP_TestDefID') is not null -- this does not follow naming convention. this is a view, not a table
drop view LEGACYSPED.MAP_TestDefID
go

create view LEGACYSPED.MAP_TestDefID
as
select TestDefID = td.ID, t.*
from LEGACYSPED.MAP_TestNames t
join IepTestDef td on t.EnrichTestName = td.Name
go

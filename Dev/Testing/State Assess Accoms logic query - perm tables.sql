set nocount on
-- declare @tests table (TestGroup varchar(5), Test varchar(5)) ; insert @tests
--select case when EnrichTestName like 'SC PASS %' then 'PASS' when EnrichTestName like 'EOC %' then 'EOC' when EnrichTestName = 'ELDA' then 'ELDA' when EOTestCode = 'GTTP' then 'GTTP' end, m.EOTestCode
--from LEGACYSPED.MAP_TestDefID m
--where 1=1
----and EnrichTestName like 'SC PASS %' 
---- and EOTestCode = 'AC3'
--order by 1, 2

if object_id('LEGACYSPED.TestGroupSelection') is not null
drop table LEGACYSPED.TestGroupSelection
go

create table LEGACYSPED.TestGroupSelection (
Num int not null primary key,
Label varchar(20) not null
)

if object_id('LEGACYSPED.SCAltSelection') is not null
drop table LEGACYSPED.SCAltSelection
go

create table LEGACYSPED.SCAltSelection (
Num int not null primary key,
Label varchar(20) not null
)

if object_id('LEGACYSPED.TakingTest') is not null
drop table LEGACYSPED.TakingTest
go

create table LEGACYSPED.TakingTest (
Num int not null primary key,
Label varchar(20) not null
)

if object_id('LEGACYSPED.ConditionsSelection') is not null
drop table LEGACYSPED.ConditionsSelection
go

create table LEGACYSPED.ConditionsSelection (
Num int not null primary key,
Label varchar(20) not null
)


-- test group selections (PASS, EOC, ELDA, GTTP) 
insert LEGACYSPED.TestGroupSelection values (0, 'not selected')
insert LEGACYSPED.TestGroupSelection values (1, 'Yes')
insert LEGACYSPED.TestGroupSelection values (2, 'No')
insert LEGACYSPED.TestGroupSelection values (3, 'NA')

-- SC Alternate test (as opposed to the regular test)
insert LEGACYSPED.SCAltSelection values (0, 'not selected')
insert LEGACYSPED.SCAltSelection values (1, 'Yes')
insert LEGACYSPED.SCAltSelection values (2, 'No')
insert LEGACYSPED.SCAltSelection values (3, 'NA')

-- Taking the test or not (this is a checkbox 0 is unchecked, 1 is checked, indicating Yes, taking test)
insert LEGACYSPED.TakingTest values (0, 'No')
insert LEGACYSPED.TakingTest values (1, 'Yes')

-- Conditions. For each test, user should select standard (with or w/o accoms) or non-standard
insert LEGACYSPED.ConditionsSelection values (0, 'not selected')
insert LEGACYSPED.ConditionsSelection values (1, 'Std')
insert LEGACYSPED.ConditionsSelection values (2, 'Std w/ Accom')
insert LEGACYSPED.ConditionsSelection values (3, 'Non-Standard')
go

if object_id ('LEGACYSPED.LOGIC_EOTestParticipation') is not null
drop view LEGACYSPED.LOGIC_EOTestParticipation
go


create view LEGACYSPED.LOGIC_EOTestParticipation
as
select t.TestGroup, 
	t.GroupYNna, t.GroupYNnaDesc, 
	t.AltYNna, t.AltYNnaDesc, 
	t.TestYN, t.TestYNDesc, 
	t.Conditions, t.ConditionsDesc, 
	Participation = p.ParticipationType
from (
select TestGroup, EOTestCode, 
	GroupYNna = tg.num, AltYNna = alt.num, TestYN = tkt.num, Conditions = cnd.num,
	GroupYNnaDesc = tg.label, AltYNnaDesc = alt.label, TestYNDesc = tkt.label, ConditionsDesc = cnd.label,
	Participation = 
		case TestGroup --- TEST GROUP
		when 'PASS' then
			case tg.num -- PASS ANSWER
				when 2 then -- PASS N
					case alt.num 
						when 1 then -- SC ALT Y
							4 -- Alternate
						else 5 -- PASS N & SC Alt N or NA, so Not in group
					end -- SC ALT Y
				when 1 then -- PASS Y
				case tkt.num -- Taking the test Y/N (math, ela, etc.)
					when 0 then -- student not taking the subject (math, ela, etc.)
						NULL -- reflecting what's in EO
					else cnd.num -- 
				end
			when 0 then NULL -- this reflects EO data
			else 5 -- case 3 
			end -- -- TEST GROUP ANSWER
		when 'EOC' then 
			case tg.num -- EOC ANSWER
				when 1 then -- EOC Y
				case tkt.num
					when 0 then
						NULL
					else cnd.num -- 1 Std, 2 Std w/accom, 3 Non-std
				end
				when 0 then -- EOC N
					NULL -- this reflects EO data
			else 5 -- 0 (nothing selected), 2 No and 3 NA
			end -- -- EOC ANSWER
		else -- ELDA or GTTP
		case tg.num -- 8
			when 0 
				then NULL
			else
				case EOTestCode -- 6
				when 'AC14' then -- ELDA
					case tkt.num -- case 7
					when 1 then -- ELDA Y
						cnd.num -- 1 Std, 2 Std w/Accom
					when 2 then -- ELDA N
						3 -- non-std
					when 0 then
						NULL
					else -- -- ELDA NA
						5 -- Not in group
					end -- case 7
				when 'GTTP' then -- This is the same as ELDA, but we must derive some data for this logic, so we separated it here to be able to comment the code
					case tkt.num -- case 8
					when 1 then -- GTTP Y
						cnd.num -- for GTTP, this will have to be derived from the contents of the text boxes
					when 2 then -- GTTP N
						3 -- non-standard
					else -- GTTP NA
						5
					end
				end -- 6
			end
		end --- TEST GROUP
from (
	select TestGroup = case when EnrichTestName like 'SC PASS %' then 'PASS' when EnrichTestName like 'EOC %' then 'EOC' when EnrichTestName = 'ELDA' then 'ELDA' when EOTestCode = 'GTTP' then 'GTTP' end, m.EOTestCode
	from LEGACYSPED.MAP_TestDefID m
	where 1=1
	) t 
cross join LEGACYSPED.TestGroupSelection tg
cross join LEGACYSPED.SCAltSelection alt
cross join LEGACYSPED.TakingTest tkt
cross join LEGACYSPED.ConditionsSelection cnd
-- there is a cleaner way to assure logical combinations, but for sake of time we'll just exclude some invalid or unimportant ones
where 1=1
and not (alt.num = 1 and TestGroup <> 'PASS') -- Alt only applicable to PASS
and not (t.TestGroup = 'ELDA' and cnd.num = 3) -- There is no "non-standard" condition for ELDA
--and not (t.TestGroup in ('ELDA', 'GTTP') and tg.num <> 1) -- This is not a test group, we just pretend it is
--and not (t.TestGroup in ('ELDA', 'GTTP') and alt.num <> 0) -- This is not a test group, we just pretend it is
and not (alt.Num = 1 and t.EOTestCode = 'AC7') -- there is no Writing for the SC Alt
) t
left join LEGACYSPED.StateDistrictParticipationDef p on t.Participation = p.ParticipationTypeCode
where 1=1
-- TakingTestGroupDesc = 'Yes'
-- and t.GroupYNna = 1
--and t.TestGroup in ('GTTP', 'ELDA')
--and p.ParticipationType = 'Standard'
-- and p.ParticipationType is null
--and GroupYNna <> 1
group by t.TestGroup, 
	t.GroupYNna, t.GroupYNnaDesc, 
	t.AltYNna, t.AltYNnaDesc, 
	t.TestYN, t.TestYNDesc, 
	t.Conditions, t.ConditionsDesc, 
	p.ParticipationType
-- order by 6, 2, 3, 4
go


-- select * from LEGACYSPED.MAP_TestDefID



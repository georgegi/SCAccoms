
set nocount on
declare @tests table (TestGroup varchar(5), Test varchar(5)) ; insert @tests
select case when EnrichTestName like 'SC PASS %' then 'PASS' when EnrichTestName like 'EOC %' then 'EOC' when EnrichTestName = 'ELDA' then 'ELDA' when EOTestCode = 'GTTP' then 'GTTP' end, m.EOTestCode
from LEGACYSPED.MAP_TestDefID m
where 1=1
--and EnrichTestName like 'SC PASS %' 
-- and EOTestCode = 'AC3'
order by 1, 2

-- test group selections (PASS, EOC, ELDA, GTTP) 
declare @tgdesc table (num int not null, label varchar(20) not null)
insert @tgdesc values (0, 'not selected')
insert @tgdesc values (1, 'Yes')
insert @tgdesc values (2, 'No')
insert @tgdesc values (3, 'NA')

-- SC Alternate test (as opposed to the regular test)
declare @altdesc table (num int not null, label varchar(20) not null)
insert @altdesc values (0, 'not selected')
insert @altdesc values (1, 'Yes')
insert @altdesc values (2, 'No')
insert @altdesc values (3, 'NA')

-- Taking the test or not (this is a checkbox 0 is unchecked, 1 is checked, indicating Yes, taking test)
declare @tktdesc table (num int not null, label varchar(20) not null)
insert @tktdesc values (0, 'No')
insert @tktdesc values (1, 'Yes')

-- Conditions. For each test, user should select standard (with or w/o accoms) or non-standard
declare @cnddesc table (num int not null, label varchar(20) not null)
insert @cnddesc values (0, 'not selected')
insert @cnddesc values (1, 'Std')
insert @cnddesc values (2, 'Std w/ Accom')
insert @cnddesc values (3, 'Non-Standard')

select t.TestGroup, t.GroupYNnaDesc, t.AltYNnaDesc, t.TestYNDesc, t.ConditionsDesc, Participation = p.ParticipationType
from (
select TestGroup, Test, 
	GroupYNna = tgd.num, AltYNna = altd.num, TestYN = tktd.num, Conditions = cndd.num,
	GroupYNnaDesc = tgd.label, AltYNnaDesc = altd.label, TestYNDesc = tktd.label, ConditionsDesc = cndd.label,
	Participation = 
		case TestGroup --- TEST GROUP
		when 'PASS' then
			case tgd.num -- PASS ANSWER
				when 2 then -- PASS N
					case altd.num 
						when 1 then -- SC ALT Y
							4 -- Alternate
						else 5 -- PASS N & SC Alt N or NA, so Not in group
					end -- SC ALT Y
				when 1 then -- PASS Y
				case tktd.num -- Taking the test Y/N (math, ela, etc.)
					when 0 then -- student not taking the subject (math, ela, etc.)
						NULL -- reflecting what's in EO
					else cndd.num -- 
				end
			when 0 then NULL -- this reflects EO data
			else 5 -- case 3 
			end -- -- TEST GROUP ANSWER
		when 'EOC' then 
			case tgd.num -- EOC ANSWER
				when 1 then -- EOC Y
				case tktd.num
					when 0 then
						NULL
					else cndd.num -- 1 Std, 2 Std w/accom, 3 Non-std
				end
				when 0 then -- EOC N
					NULL -- this reflects EO data
			else 5 -- 0 (nothing selected), 2 No and 3 NA
			end -- -- EOC ANSWER
		else -- ELDA or GTTP
		case tgd.num -- 8
			when 0 
				then NULL
			else
				case Test -- 6
				when 'AC14' then -- ELDA
					case tktd.num -- case 7
					when 1 then -- ELDA Y
						cndd.num -- 1 Std, 2 Std w/Accom
					when 2 then -- ELDA N
						3 -- non-std
					else -- -- ELDA NA
						5 -- Not in group
					end -- case 7
				when 'GTTP' then -- This is the same as ELDA, but we must derive some data for this logic, so we separated it here to be able to comment the code
					case tktd.num -- case 8
					when 1 then -- GTTP Y
						cndd.num -- for GTTP, this will have to be derived from the contents of the text boxes
					when 2 then -- GTTP N
						3 -- non-standard
					else -- GTTP NA
						5
					end
				end -- 6
			end
		end --- TEST GROUP
from @tests t 
cross join @tgdesc tgd 
cross join @altdesc altd 
cross join @tktdesc tktd 
cross join @cnddesc cndd 

where not (altd.num = 1 and TestGroup <> 'PASS') -- example of an expected combination (er, excluding unexpected combinations)
and not (t.TestGroup = 'ELDA' and cndd.num = 3)
) t
left join LEGACYSPED.StateDistrictParticipationDef p on t.Participation = p.ParticipationTypeCode
where 1=1
-- TakingTestGroupDesc = 'Yes'
and t.GroupYNna = 1
--and t.TestGroup = 'EOC'
and p.ParticipationType = 'Non-standard'
-- and p.ParticipationType is null
group by t.TestGroup, t.GroupYNnaDesc, t.AltYNnaDesc, t.TestYNDesc, t.ConditionsDesc, p.ParticipationType

order by 4, 5





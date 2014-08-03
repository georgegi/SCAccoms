-- '643808237000' grade 11
-- '189770934100' grade 02

-- select * from x_datateam.FindProgramData


declare @s varchar(20) ; set @s = '155563610500'

select ParticipationTypeCode, ParticipationType from LEGACYSPED.StateDistrictParticipationDef p where ParticipationTypeCode <> 4 order by ParticipationTypeCode
select m.*, MinGrade = gmin.Name, MaxGrade = gmax.Name
from LEGACYSPED.MAP_TestDefID m
join IepTestDef td on m.TestDefID = td.ID
left join GradeLevel gmin on td.MinGradeID = gmin.ID
left join GradeLevel gmax on td.MaxGradeID = gmax.ID

where EnrichTestName like 'SC PASS%' 

order by EnrichTestName

;
with participationCTE
as (
select m.StudentRefID, s.StudentLocalID, s.Firstname, s.Lastname, GradeLevel = stu.GradeLevelCode,
	m.IEPRefID, a2.IEPAccomSeq,
	a2.PACT, -- PACT = PASS
	a2.PACTAlt,
		a2.PACTEnglish, a2.PACTEnglishCond,
		a2.PACTMath, a2.PACTMathCond,
		a2.PACTSocStudies, a2.PACTSocialCond,
		a2.PACTScience, a2.PACTScienceCond,
		a2.PASSWriting, a2.PASSWritingCond,
	--
	a2.ELDA, a2.ELDAStandard,
	a2.GTTP, GTTPAccom = convert(varchar(max), a2.GTTPAccom), 
	--
	a2.DistAssess, a2.DistAssessTitle, a2.AltAssess,
	--
	a2.EOCTest,
		a2.EOCAlgMath, a2.EOCMathCond,
		a2.EOCEnglish, a2.EOCEnglishCond,
		a2.EOCPhysicalSci, a2.EOCPhysicalSciCond,
		a2.EOCBiology, a2.EOCBiologyCond,
		a2.EOCUSHistory, a2.EOCUSHistoryCond
from LEGACYSPED.MAP_IEPStudentRefID m 
	join LEGACYSPED.Student s on m.StudentRefID = s.StudentRefID
--join LEGACYSPED.EO_IEPAccomModTbl_RAW a on m.StudentRefID = a.GStudentID
--join LEGACYSPED.EO_IEPAccomModTbl_SC_RAW a2 on a.IEPAccomSeq = a2.IEPAccomSeq 
--join LEGACYSPED.Student stu on m.StudentRefID = stu.StudentRefID
join Dev2005.QASCConvert2005.dbo.IEPAccomModTbl a on m.StudentRefID = a.GStudentID
join Dev2005.QASCConvert2005.dbo.IEPAccomModTbl_SC a2 on a.IEPAccomSeq = a2.IEPAccomSeq 
join LEGACYSPED.Student stu on m.StudentRefID = stu.StudentRefID

-- where /* a2.PACT = 2 and */ a2.GTTP = 1
)



--PASS
	--a2.PACT, -- PACT = PASS
	--a2.PACTAlt,



		--a2.PACTEnglish, a2.PACTEnglishCond,


----- English language arts (ELA)
select c.StudentRefID, c.StudentLocalID, c.Firstname, c.LastName, c.GradeLevel, c.IepRefID, c.IEPAccomSeq, 
	EOTestCode = 'AC3',
	TestYN = c.PACT, Course = c.PACTEnglish, Condition = c.PACTEnglishCond, 
	Participation = 
		case c.PACT when 1 then
			case isnull(c.PACTEnglish,0) when 1 then
				case isnull(c.PACTEnglishCond,0) 
					when 0 then 5 -- not in group
					else c.PACTEnglishCond
				end
			else 5
			end
		else 5
		end
from participationCTE c
where c.StudentLocalID = @s

union all

		--a2.PACTMath, a2.PACTMathCond,


----- Mathematics
select c.StudentRefID, c.StudentLocalID, c.Firstname, c.LastName, c.GradeLevel, c.IepRefID, c.IEPAccomSeq, 
	EOTestCode = 'AC4',
	TestYN = c.PACT, Course = c.PACTMath, Condition = c.PACTMathCond, 
	Participation = 
		case c.PACT when 1 then
			case isnull(c.PACTMath,0) when 1 then
				case isnull(c.PACTMathCond,0) 
					when 0 then 5 -- not in group
					else c.PACTMathCond
				end
			else 5
			end
		else 5
		end
from participationCTE c
where c.StudentLocalID = @s

union all

		--a2.PACTSocStudies, a2.PACTSocialCond,

----- Social studies
select c.StudentRefID, c.StudentLocalID, c.Firstname, c.LastName, c.GradeLevel, c.IepRefID, c.IEPAccomSeq, 
	EOTestCode = 'AC5',
	TestYN = c.PACT, Course = c.PACTSocStudies, Condition = c.PACTSocialCond, 
	Participation = 
		case c.PACT when 1 then
			case isnull(c.PACTSocStudies,0) when 1 then
				case isnull(c.PACTSocialCond,0) 
					when 0 then 5 -- not in group
					else c.PACTSocialCond
				end
			else 5
			end
		else 5
		end
from participationCTE c
where c.StudentLocalID = @s

union all


		--a2.PACTScience, a2.PACTScienceCond,

----- Science
select c.StudentRefID, c.StudentLocalID, c.Firstname, c.LastName, c.GradeLevel, c.IepRefID, c.IEPAccomSeq, 
	EOTestCode = 'AC6',
	TestYN = c.PACT, Course = c.PACTScience, Condition = c.PACTScienceCond, 
	Participation = 
		case c.PACT when 1 then
			case isnull(c.PACTScience,0) when 1 then
				case isnull(c.PACTScienceCond,0) 
					when 0 then 5 -- not in group
					else c.PACTScienceCond
				end
			else 5
			end
		else 5
		end
from participationCTE c
where c.StudentLocalID = @s

union all

		--a2.PASSWriting, a2.PASSWritingCond,

----- Writing
select c.StudentRefID, c.StudentLocalID, c.Firstname, c.LastName, c.GradeLevel, c.IepRefID, c.IEPAccomSeq, 
	EOTestCode = 'AC7',
	TestYN = c.PACT, Course = c.PASSWriting, Condition = c.PASSWritingCond, 
	Participation = 
		case c.PACT when 1 then
			case isnull(c.PASSWriting,0) when 1 then
				case isnull(c.PASSWritingCond,0) 
					when 0 then 5 -- not in group
					else c.PASSWritingCond
				end
			else 5
			end
		else 5
		end
from participationCTE c
where c.StudentLocalID = @s

union all

---------------------------------------- Page 2
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------


select c.StudentRefID, c.StudentLocalID, c.Firstname, c.LastName, c.GradeLevel, c.IepRefID, c.IEPAccomSeq, 
	EOTestCode = 'AC14', -- ELDA
	TestYN = case isnull(c.ELDA, 0) when 1 then 1 when 2 then 1 else 0 end, -- simulate the EOC radio buttons
	CourseYN = cast(NULL as bit), -- does not apply here, so we won't try
	Condition = case isnull(c.ELDA, 0) when 2 then 3 else c.ELDAStandard end, -- simulate the EOC radio buttons -- 1 = Standard or 2 = Std w/ Accom
	Participation = 
		case isnull(c.Elda, 0)
			when 2 then 3
			when 3 then 5
			when 0 then 5
			else c.ELDAStandard -- 1 = Standard, 2 = Std w/ Accom
		end
from participationCTE c
where c.StudentLocalID = @s

union all

select c.StudentRefID, c.StudentLocalID, c.Firstname, c.LastName, c.GradeLevel, c.IepRefID, c.IEPAccomSeq, 
	EOTestCode = 'GTTP',
	TestYN = case isnull(c.GTTP, 0) when 1 then 1 when 2 then 1 else 0 end,
	CourseYN = c.GTTP, 
	Condition = case when isnull(c.GTTPAccom,'') in ('', 'NA', 'N/A', 'None', 'No') then 0 -- converted GTTPAccom in the CTE
				else 1
			end, 
	Participation = 
	case isnull(c.GTTP,0)
		when 2 then 3
		when 3 then 5
		when 0 then 5
		when 1 then
			case when isnull(c.GTTPAccom,'') in ('', 'NA', 'N/A', 'None', 'No') then 1 -- converted GTTPAccom in the CTE
				else 2
			end
	end
from participationCTE c
where c.StudentLocalID = @s


union all



----- algebra
select c.StudentRefID, c.StudentLocalID, c.Firstname, c.LastName, c.GradeLevel, c.IepRefID, c.IEPAccomSeq, 
	EOTestCode = 'AC8',
	TestYN = c.EOCTest, Course = c.EOCAlgMath, Condition = c.EOCMathCond, 
	Participation = 
		case c.EOCTest when 1 then
			case isnull(c.EOCAlgMath,0) when 1 then
				case isnull(c.EOCMathCond,0) 
					when 0 then 5 -- not in group
					else c.EOCMathCond
				end
			else 5
			end
		else 5
		end
from participationCTE c
where c.StudentLocalID = @s

union all

-- english
select c.StudentRefID, c.StudentLocalID, c.Firstname, c.LastName, c.GradeLevel, c.IepRefID, c.IEPAccomSeq, 
	EOTestCode = 'AC10',
	c.EOCTest, c.EOCEnglish, EOCEnglishCond, 
	Participation = 
		case EOCTest when 1 then
			case isnull(c.EOCEnglish,0) when 1 then
				case isnull(c.EOCEnglishCond,0) 
					when 0 then 5 -- not in group
					else c.EOCEnglishCond
				end
			else 5
			end
		else 5
		end
from participationCTE c
where c.StudentLocalID = @s

--union all --- not in Enrich

---- physical science
--select c.StudentRefID, c.StudentLocalID, c.Firstname, c.LastName, c.GradeLevel, c.IepRefID, c.IEPAccomSeq, 
--	EOTestCode = 'xxxxxxxxxxxxxxxxxxxxxx',
--	c.EOCTest, c.EOCPhysicalSci, EOCPhysicalSciCond, 
--	Participation = 
--		case EOCTest when 1 then
--			case isnull(c.EOCPhysicalSci,0) when 1 then
--				case isnull(c.EOCPhysicalSciCond,0) 
--					when 0 then 5 -- not in group
--					else c.EOCPhysicalSciCond
--				end
--			else 5
--			end
--		else 5
--		end
--from participationCTE c
--where c.StudentLocalID = @s


union all

---- biology
select c.StudentRefID, c.StudentLocalID, c.Firstname, c.LastName, c.GradeLevel, c.IepRefID, c.IEPAccomSeq, 
	EOTestCode = 'AC9',
	c.EOCTest, c.EOCBiology, EOCBiologyCond, 
	Participation = 
		case EOCTest when 1 then
			case isnull(c.EOCBiology,0) when 1 then
				case isnull(c.EOCBiologyCond,0) 
					when 0 then 5 -- not in group
					else c.EOCBiologyCond
				end
			else 5
			end
		else 5
		end
from participationCTE c
where c.StudentLocalID = @s

union all

---- history
select c.StudentRefID, c.StudentLocalID, c.Firstname, c.LastName, c.GradeLevel, c.IepRefID, c.IEPAccomSeq, 
	EOTestCode = 'AC13',
	c.EOCTest, c.EOCUSHistory, EOCUSHistoryCond, 
	Participation = 
		case EOCTest when 1 then
			case isnull(c.EOCUSHistory,0) when 1 then
				case isnull(c.EOCUSHistoryCond,0) 
					when 0 then 5 -- not in group
					else c.EOCUSHistoryCond
				end
			else 5
			end
		else 5
		end
from participationCTE c
where c.StudentLocalID = @s



----------------------------------------------------------------------------------------------------



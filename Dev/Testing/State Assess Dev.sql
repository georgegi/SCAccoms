-- '643808237000' grade 11
-- '189770934100' grade 02
-- '159480484600' grade 09
-- select * from x_datateam.FindProgramData



-- delcare and populate table variables mimicking the remote tables so I can take advantage of intellisense (not available over linked server)
declare @IEPAccomModTbl table (
GStudentID uniqueidentifier	NOT NULL,
IEPAccomSeq bigint	NOT NULL,
CreateID nvarchar(40),
CreateDate datetime,
ModifyID nvarchar(40),
ModifyDate datetime,
DeleteID nvarchar(40),
DeleteDate datetime,
Del_Flag bit)

declare @IEPAccomModTbl_SC table (IEPAccomSeq bigint	NOT NULL,
BSAP int,
BSAPRead bit,
BSAPMath bit,
BSAPWriting bit,
HSAP int,
HSAPEnglish bit,
HSAPAlt int,
PACT int,
PACTEnglish bit,
PACTEnglishGrade nvarchar(80),
PACTMath bit,
PACTMathGrade nvarchar(80),
PACTSocStudies bit,
PACTSocStudiesGrade nvarchar(80),
PACTScience bit,
PACTScienceGrade nvarchar(80),
PACTAlt int,
SCRA int,
SCRAAlt int,
DistAssess int,
DistAssessTitle nvarchar(160),
AltAssess ntext,
EOCTest int,
EOCTitles ntext,
AccomMod int,
AccomModSheet ntext,
NormRef ntext,
CreateID nvarchar(40),
CreateDate datetime,
ModifyID nvarchar(40),
ModifyDate datetime,
DeleteID nvarchar(40),
Deletedate datetime,
Del_Flag bit	NOT NULL,
HSAPMath bit,
MAP int,
Other int,
OtherDesc nvarchar(160),
HSAPStandard int,
HSAPEnglishAccom ntext,
HSAPMathAccom ntext,
HSAPAltEnglish bit,
HSAPAltMath bit,
PACTStandard int,
PACTEnglishAccom ntext,
PACTMathAccom ntext,
PACTSocialAccom ntext,
PACTScienceAccom ntext,
PACTAltEnglish bit,
PACTAltMath bit,
PACTAltSocial bit,
PACTAltScience bit,
ELDA int,
ELDAStandard int,
ELDAAccom ntext,
EOCAlgMath bit,
EOCAlgMathAccom ntext,
EOCBiology bit,
EOCBioAccom ntext,
EOCEnglish bit,
EOCEnglishAccom ntext,
EOCPhysicalSci bit,
EOCPhysicalAccom ntext,
DistAssessAccom ntext,
EOCStandard int,
HSAPEnglishCond int,
HSAPMathCond int,
PACTEnglishCond int,
PACTMathCond int,
PACTSocialCond int,
PACTScienceCond int,
EOCMathCond int,
EOCBiologyCond int,
EOCEnglishCond int,
EOCPhysicalSciCond int,
EOCUSHistory bit,
EOCUSHistoryCond int,
SCAltReason ntext,
HSAPEngTestTaken int,
HSAPMathTestTaken int,
EOCUSHistTestTaken int,
PACTAltAgeQual int,
SCRAAltReason ntext,
PASSWriting bit,
PASSWritingCond int,
PartTesting nvarchar(8),
DuringEffDates nvarchar(8),
SubjAreaAccom ntext,
GTTP int,
GTTPAccom ntext,
GTTPData ntext,
SB int,
SBELA bit,
SBELACond int,
SBMath bit,
SBMathCond int)

insert @IEPAccomModTbl 
select a.*
from LEGACYSPED.MAP_IEPStudentRefID m 
join Dev2005.QASCConvert2005.dbo.IEPAccomModTbl a on m.StudentRefID = a.GStudentID -- notice that intellisense not working here. That's why we use table variables, to leverage intellisense on queries below
join Dev2005.QASCConvert2005.dbo.IEPAccomModTbl_SC a2 on a.IEPAccomSeq = a2.IEPAccomSeq 

insert @IEPAccomModTbl_SC 
select a2.*
from LEGACYSPED.MAP_IEPStudentRefID m 
join Dev2005.QASCConvert2005.dbo.IEPAccomModTbl a on m.StudentRefID = a.GStudentID
join Dev2005.QASCConvert2005.dbo.IEPAccomModTbl_SC a2 on a.IEPAccomSeq = a2.IEPAccomSeq 

------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------

select * from LEGACYSPED.StateDistrictParticipationDef p order by ParticipationTypeCode

select m.*, MinGrade = gmin.Name, MaxGrade = gmax.Name
from LEGACYSPED.MAP_TestDefID m
join IepTestDef td on m.TestDefID = td.ID
left join GradeLevel gmin on td.MinGradeID = gmin.ID
left join GradeLevel gmax on td.MaxGradeID = gmax.ID
--where EnrichTestName not like 'SC PASS%' 
order by m.Sequence


declare @s varchar(20) ; set @s = '189770934100'




;
with participationCTE
as (
select m.IEPRefID, a2.IEPAccomSeq,
	PACT = isnull(a2.PACT,0), -- PACT = PASS
	PACTAlt = isnull(a2.PACTAlt,0),
		a2.PACTEnglish, PACTEnglishCond = isnull(a2.PACTEnglishCond,0),
		a2.PACTMath, PACTMathCond = isnull(a2.PACTMathCond,0),
		a2.PACTSocStudies, PACTSocialCond = isnull(a2.PACTSocialCond,0),
		a2.PACTScience, PACTScienceCond = isnull(a2.PACTScienceCond,0),
		a2.PASSWriting, PASSWritingCond = isnull(a2.PASSWritingCond,0),
	--
	ELDA = isnull(a2.ELDA,0), ELDAStandard = isnull(a2.ELDAStandard,0),
	GTTP = isnull(a2.GTTP,0), 
		-- here we will derive a value for Std or Std w/ Accom 
		GTTPCond = case when isnull(convert(varchar(max), a2.GTTPAccom),'') in ('', 'NA', 'N/A', 'None', 'No') -- check for either no text or text that indicates no accoms
			then 1 -- standard
			else 2 -- standard w/ accoms, because there is text in the accoms text box
		end,
		GTTPAccom = convert(varchar(max), a2.GTTPAccom), 
	--
	a2.DistAssess, a2.DistAssessTitle, a2.AltAssess,
	--
	EOCTest = isnull(a2.EOCTest,0),
		a2.EOCAlgMath, EOCMathCond = isnull(a2.EOCMathCond,0),
		a2.EOCEnglish, EOCEnglishCond = isnull(a2.EOCEnglishCond,0),
		a2.EOCPhysicalSci, EOCPhysicalSciCond = isnull(a2.EOCPhysicalSciCond,0),
		a2.EOCBiology, EOCBiologyCond = isnull(a2.EOCBiologyCond,0),
		a2.EOCUSHistory, EOCUSHistoryCond = isnull(a2.EOCUSHistoryCond,0)
from LEGACYSPED.MAP_IEPStudentRefID m 
--join LEGACYSPED.EO_IEPAccomModTbl_RAW a on m.StudentRefID = a.GStudentID
--join LEGACYSPED.EO_IEPAccomModTbl_SC_RAW a2 on a.IEPAccomSeq = a2.IEPAccomSeq 
--join LEGACYSPED.Student stu on m.StudentRefID = stu.StudentRefID
join @IEPAccomModTbl a on m.StudentRefID = a.GStudentID
join @IEPAccomModTbl_SC a2 on a.IEPAccomSeq = a2.IEPAccomSeq 
-- where /* a2.PACT = 2 and */ a2.GTTP = 1
)


-- simulate a view

select 
	s.StudentLocalID, s.Firstname, s.Lastname, s.GradeLevelCode,
	stp.IepRefID, stp.IEPAccomSeq, 
	stp.TestGroup, 
	stp.EOTestCode, td.EnrichTestName, td.TestDefID,
	GroupSelection = logic.GroupYNnaDesc, 
	AltSelection = logic.AltYNnaDesc, 
	TestYN = logic.TestYNDesc,
	Conditions = logic.ConditionsDesc,
	Logic.Participation, p.StateParticipationDefID
	--, stp.GroupYNna, stp.AltYNna, stp.TestYN, stp.Conditions
from (

-- PASS
----- English language arts (ELA)
-- Note: Alternate pass applies to ELA, Math, Social Studies and Science, but not writing. If they take one Alt, they take all 4.
select c.IepRefID, c.IEPAccomSeq, TestGroup = 'PASS', EOTestCode = 'AC3', GroupYNna = c.PACT, AltYNna = c.PActAlt, TestYN = c.PACTEnglish,  Conditions = c.PACTEnglishCond
from participationCTE c

union all

------- Mathematics
select c.IepRefID, c.IEPAccomSeq, 'PASS', 'AC4', c.PACT, c.PActAlt, c.PACTMath, c.PACTMathCond 
from participationCTE c

union all

----- Social studies
select c.IepRefID, c.IEPAccomSeq, 'PASS', 'AC5', c.PACT, c.PActAlt, c.PACTSocStudies, c.PACTSocialCond
from participationCTE c

union all

----- Science
select c.IepRefID, c.IEPAccomSeq, 'PASS', 'AC6', c.PACT, c.PActAlt, c.PACTScience, c.PACTScienceCond
from participationCTE c

union all

--- Writing --------------------------------------------- DOES NOT APPLY TO ALTERNATE. Alternate is for students that use pictures and objects, so they can't write at all.
select c.IepRefID, c.IEPAccomSeq, 'PASS', 'AC7', c.PACT, c.PActAlt, c.PASSWriting, c.PASSWritingCond
from participationCTE c

union all

--------------------------------------------------------------------------------------------
--                                          Page 2
--------------------------------------------------------------------------------------------

-- ELDA
select c.IepRefID, c.IEPAccomSeq, 'ELDA', 'AC14', 
	GroupYNna = isnull(c.ELDA, 0), -- simulate the EOC radio buttons
	AltYNna = 0,
	TestYN = case isnull(c.ELDA, 0) when 1 then 1 when 2 then 1 else 0 end, -- simulate the EOC checkbox. 1 is checked, 2 is checked, else not checked.
	Condition = case isnull(c.ELDA, 0) when 2 then 3 else isnull(c.ELDAStandard,0) end -- simulate non-standard radio button. Assuming ELDA 2 means non-standard? Enrich has non-std for ELDA
from participationCTE c

union all

-- Grade 2 Gifted
select c.IepRefID, c.IEPAccomSeq, 'GTTP', 'GTTP', -- we made up the EO test code. accoms are in a text box.  We'll put 'See PDF' in the Enrich UI
	GroupYNna = case isnull(c.GTTP, 0) when 1 then 1 when 2 then 1 else 0 end,
	AltYNna = 0,
	TestYN = c.GTTP, 
	Condition = c.GTTPCond
from participationCTE c

union all

------- algebra
select c.IepRefID, c.IEPAccomSeq, 'EOC', 'AC8', c.EOCTest, AltYNna = 0, c.EOCAlgMath, c.EOCMathCond
from participationCTE c

union all

---- english
select c.IepRefID, c.IEPAccomSeq, 'EOC', 'AC10', c.EOCTest, AltYNna = 0, c.EOCEnglish, EOCEnglishCond
from participationCTE c

union all

---- biology
select c.IepRefID, c.IEPAccomSeq, 'EOC', 'AC9', c.EOCTest, AltYNna = 0, c.EOCBiology, EOCBiologyCond
from participationCTE c

union all

---- history
select c.IepRefID, c.IEPAccomSeq, 'EOC', 'AC13', c.EOCTest, AltYNna = 0, c.EOCUSHistory, EOCUSHistoryCond
from participationCTE c

) stp
join LEGACYSPED.MAP_IepStudentRefID ms on stp.IEPRefID = ms.IEPRefID
join LEGACYSPED.Student s on ms.StudentRefID = s.StudentRefID
left join LEGACYSPED.MAP_TestDefID td on stp.EOTestCode = td.EOTestCode
left join LEGACYSPED.LOGIC_EOTestParticipation logic on 
	stp.TestGroup = logic.TestGroup and
	stp.GroupYNna = logic.GroupYNna and 
	stp.AltYNna = logic.AltYNna and 
	stp.TestYN = logic.TestYN and 
	stp.Conditions = logic.Conditions
left join LEGACYSPED.StateDistrictParticipationDef p on logic.Participation = p.ParticipationType

where s.StudentLocalID = @s

order by StudentLocalID, EOTestCode



--select * from LEGACYSPED.LOGIC_EOTestParticipation where TestGroup in ('ELDA', 'GTTP') 

-- select * from LEGACYSPED.LOGIC_EOTestParticipation logic



--union all --- not in Enrich
---- physical science
--select c.IepRefID, c.IEPAccomSeq, 'EOC', EOTestCode = 'xxxxxxxxxxxxxxxxxxxxxx', c.EOCTest, c.EOCPhysicalSci, EOCPhysicalSciCond
--from participationCTE c





--create view LEGACYSPED.StateDistrictParticipationDef
--as
--/* 
--	There are 2 Participation Def records with the name "Alternate", one for District and one for State tests
--	Where there is an Alternate participation in the legacy data, we need to associate it with the proper participation def in Enrich
--	To do so, we will create a view that identifies which is which 
--	Then we will use this view in Transform_IepTestParticipation to get the correct ParticipationDef ID
--	If the same participation def ID is used for both State and District test, as in the case of "Regular" no harm done
--*/
--select 
--	ParticipationTypeCode = case pd.text
---- arbitrary values in a logical order, to avoid spelling issues in joins. Must be spelled in this view the same as in IepTestParticipationDef
--		when 'Standard' then 1 
--		when 'Std w/ Accom' then 2
--		when 'Non-Standard' then 3
--		when 'Alternate' then 4
--		when 'Not in group' then 5
--	end,
--	td.IsState,
--	ParticipationType = pd.Text, 
--	DistrictParticipationDefID = max(convert(varchar(36), pdd.ID)),
--	StateParticipationDefID = max(convert(varchar(36), pds.ID))
--from IepAllowedTestParticipation atp 
--join IepTestDef td on atp.TestDefID = td.ID -- seems odd to have test def in from clause but only isstate in select clause. This view is about participations...
--join IepTestParticipationDef pd on atp.ParticipationDefID = pd.ID -- one row each
--left join IepTestParticipationDef pdd on atp.ParticipationDefID = pdd.ID and td.IsState = 0
--left join IepTestParticipationDef pds on atp.ParticipationDefID = pds.ID and td.IsState = 1
--where pd.text in ('Not in group', 'Standard', 'Std w/ Accom', 'Alternate', 'Non-Standard')  -- these are the only ones coming from Excent Online
--group by pd.Text, td.IsState


----------------------------------------------------------------------------------------------------




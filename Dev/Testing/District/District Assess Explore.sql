



--- step 1: get a list of accoms from legacy system

--select * from MemoLook where usageID = 'TestingAccommodations'


---- test accoms (and Mods)
--select b.*, m.Code
--from (
--	select AM, AccomDesc, count(*) tot2
--	from (
--		select aa.AccomCode, AccomDesc = convert(varchar(1000), aa.AccomDesc), AM = case when aa.AccomCode like '%ACC%' then 'ACC' when aa.AccomCode like '%MOD%' then 'MOD' else '' end, count(*) tot1
--		from (select IEPSeqNum = max(iepseqnum) from LEGACYSPED.EO_IEPCompleteTbl_RAW group by gstudentid) s -- specialedstudentsandieps 
--		join LEGACYSPED.EO_ICIEPAccomModTbl_RAW a on s.iepseqnum = a.iepcomplseqnum
--		join LEGACYSPED.EO_ICIEPAccomModListTbl_SC_RAW aa on a.iepcomplseqnum = aa.iepcomplseqnum and a.iepaccomseq = aa.iepaccomseq
--		group by aa.AccomCode, convert(varchar(1000), aa.AccomDesc), case when aa.AccomCode like '%ACC%' then 'ACC' when aa.AccomCode like '%MOD%' then 'MOD' else '' end
--	) am
--	group by AM, AccomDesc
--) b
--left join MemoLook m on b.AccomDesc = convert(varchar(1000), m.Memo) and m.UsageID = 'TestingAccommodations'
--	and b.AM = case when m.Code like '%ACC%' then 'ACC' when m.Code like '%MOD%' then 'MOD' else '' end
--where m.code is not null
--order by Code desc, AM, AccomDesc


	
-- does it matter if we have several codes for the same accom?



--select *, case when m.Code like '%ACC%' then 'ACC' when m.Code like '%MOD%' then 'MOD' else '' end
--from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.MemoLook m
--where UsageID = 'TestingAccommodations' 

---- how many do we have that don't match description in MemoLook?
--select aa.AccomCode, 
--	AccomDesc = convert(varchar(1000), aa.AccomDesc), 
--	AM = case when aa.AccomCode like '%ACC%' then 'ACC' when aa.AccomCode like '%MOD%' then 'MOD' else '' end, 
--	m.Code
--from (select IEPSeqNum = max(iepseqnum) from LEGACYSPED.EO_IEPCompleteTbl_RAW group by gstudentid) s -- specialedstudentsandieps 
--join LEGACYSPED.EO_ICIEPAccomModTbl_RAW a on s.iepseqnum = a.iepcomplseqnum
--join LEGACYSPED.EO_ICIEPAccomModListTbl_SC_RAW aa on a.iepcomplseqnum = aa.iepcomplseqnum and a.iepaccomseq = aa.iepaccomseq
--left join [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.MemoLook m on 
--	convert(varchar(1000), aa.AccomDesc) = convert(varchar(1000), m.Memo) and 
--	case when aa.AccomCode like '%ACC%' then 'ACC' when aa.AccomCode like '%MOD%' then 'MOD' else '' end = case when m.Code like '%ACC%' then 'ACC' when m.Code like '%MOD%' then 'MOD' else '' end and 
--	m.UsageID = 'TestingAccommodations'
--where m.Code is null
---- order by 3, 2


--- assign these codes or call them custom?
select aa.AccomCode, 
	AccomDesc = convert(varchar(1000), aa.AccomDesc), 
	AM = case when aa.AccomCode like '%ACC%' then 'ACC' when aa.AccomCode like '%MOD%' then 'MOD' else '' end,
	count(*) tot
from (select IEPSeqNum = max(iepseqnum) from LEGACYSPED.EO_IEPCompleteTbl_RAW group by gstudentid) s -- specialedstudentsandieps 
join LEGACYSPED.EO_ICIEPAccomModTbl_RAW a on s.iepseqnum = a.iepcomplseqnum
join LEGACYSPED.EO_ICIEPAccomModListTbl_SC_RAW aa on a.iepcomplseqnum = aa.iepcomplseqnum and a.iepaccomseq = aa.iepaccomseq
left join [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.MemoLook m on 
	convert(varchar(1000), aa.AccomDesc) = convert(varchar(1000), m.Memo) and 
	case when aa.AccomCode like '%ACC%' then 'ACC' when aa.AccomCode like '%MOD%' then 'MOD' else '' end = case when m.Code like '%ACC%' then 'ACC' when m.Code like '%MOD%' then 'MOD' else '' end and 
	m.UsageID = 'TestingAccommodations'
where m.Code is null
group by aa.AccomCode, 
	convert(varchar(1000), aa.AccomDesc), 
	case when aa.AccomCode like '%ACC%' then 'ACC' when aa.AccomCode like '%MOD%' then 'MOD' else '' end
-- let's call them custom

-- select * from dbo.IepAccommodationDef

--select ac.Name, ac.AllowCustom, ad.Text, ad.ID, IsValidWithoutTest, IsNonStandard, IsModification, DeletedDate
--from dbo.IepAccommodationCategory ac
--join dbo.IepAccommodationDef ad on ac.ID = ad.CategoryID
--where ac.name <> 'NAEP'
--order by 5 desc, 1, 3


--select o.name
--from sys.schemas s 
--join sys.objects o on s.schema_id = o.schema_id
--join sys.columns c on o.object_id = c.object_id
--where s.name = 'dbo'
--and c.name = 'AllowCustom'

--select * from dbo.IepAccommodationCategory where name = 'Presentation'


--update c set AllowCustom = 1 from dbo.IepAccommodationCategory c where name = 'Presentation'


--exec x_DATATEAM.FindGUID 'F423BD51-74FC-4B10-8B6F-D4061C563682'

--select * from dbo.IepAccommodationDef where ID = 'F423BD51-74FC-4B10-8B6F-D4061C563682'
--select * from dbo.IepAllowedTestAccom where AccomDefID = 'F423BD51-74FC-4B10-8B6F-D4061C563682'

--select * from dbo.IepTestDef 




--select 
--dbo.IepAllowedTestAccom 




--Presentation

--         1         2         3         4         5
--12345678901234567890123456789012345678901234567890 (50 char max)
--Excent Online Testing Accommodation (DO NOT USE)




--- where accommodations are not in the state list, add them with category of "Legacy Testing Accommodation (DO NOT USE)"


--what does a custom accom look like in the database?

--select * from dbo.IepAccommodationDef

--select * from dbo.IepAccommodation -- for custom (class accom), DefID is null, CustomText not null


-- new test accom cat :		Excent Online Testing Accommodation (DO NOT USE)
-- new test accom defs :	One each
-- new test / accom association 




select ac.Name, ad.* 
from (
	select AccomText = convert(varchar(max), Text), count(*) tot
	from dbo.IepAccommodationDef
	group by convert(varchar(max), Text)
	having count(*) > 1
) d
join dbo.IepAccommodationDef ad on d.AccomText = convert(varchar(max), ad.Text)
join dbo.IepAccommodationCategory ac on ad.CategoryID = ac.ID
order by AccomText, 1

--------------- use this insert

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


select * from LEGACYSPED.EO_IEPAccomModListTbl_SC_RAW


select * from IepAccommodationDef where CategoryID = 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E'

select * from GradeLevel where Active = 1 order by BitMask

--6061CD90-8BEC-4389-A140-CF645A5D47FE -- PK
--0D7B8529-62C7-4F25-B78F-2A4724BD7990 -- 12

update ad set MinGradeID = '6061CD90-8BEC-4389-A140-CF645A5D47FE', MaxGradeID = '0D7B8529-62C7-4F25-B78F-2A4724BD7990'
-- select * 
from IepAccommodationDef ad where CategoryID = 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E'


select * from iepassessments

select stu.Number, a.* 
from student stu
join prgitem i on stu.id = i.studentid
join prgsection s on s.itemid = i.id
join iepassessments a on s.ID = a.ID
where stu.Number = '930677080000'

select * from ieptestparticipation
--- select * from iepassessments where ID = 'FDADC456-9911-47DA-89F5-6DD8F1C717E1' yes


select *
from LEGACYSPED.MAP_TestNames tn
join IepTestDef td on tn.EnrichTestName = td.Name


select * from LEGACYSPED.MAP_TestNames
select * from IepTestDef where name not like 'NAEP%'





-- let's create a master view so we don't have to keep writing the same code



if object_id('LEGACYSPED.MAP_TestNames') is not null
drop table LEGACYSPED.MAP_TestNames 
go

create table LEGACYSPED.MAP_TestNames (EOTestCode	varchar(5) not null, EnrichTestName	varchar(100) not null)

set nocount on;
insert LEGACYSPED.MAP_TestNames values ('AC3', 'SC PASS ELA') -- 
insert LEGACYSPED.MAP_TestNames values ('AC4', 'SC PASS Math') -- 
insert LEGACYSPED.MAP_TestNames values ('AC5', 'SC PASS SS') -- Social Studies
insert LEGACYSPED.MAP_TestNames values ('AC6', 'SC PASS Science') -- 
insert LEGACYSPED.MAP_TestNames values ('AC7', 'SC PASS Writing') -- 
insert LEGACYSPED.MAP_TestNames values ('AC8', 'EOC Algebra') -- Algebra 1/Mathematics for the Technologies 2
insert LEGACYSPED.MAP_TestNames values ('AC9', 'EOC Biology') -- 
insert LEGACYSPED.MAP_TestNames values ('AC10', 'EOC English') -- 
insert LEGACYSPED.MAP_TestNames values ('AC11', 'Physical Science') -- not used in Enrich?
insert LEGACYSPED.MAP_TestNames values ('AC13', 'EOC History') -- US History and Constitution
insert LEGACYSPED.MAP_TestNames values ('AC14', 'ELDA') -- English Language Development Assessment (ELDA)

insert LEGACYSPED.MAP_TestNames values ('AC12', 'District Assessments') -- separate in Enrich, and no accoms in IEPAccomModListTbl_SC
insert LEGACYSPED.MAP_TestNames values ('GTTP', '2nd Grade GT') -- No accommodations stored in IEPAccomModListTbl_SC
set nocount off;

alter table LEGACYSPED.MAP_TestNames 
	add constraint PK_LEGACYSPED_MAP_TestNames primary key (EOTestCode)
go


if object_id('LEGACYSPED.EO_MasterTestAccomView') is not null
drop view LEGACYSPED.EO_MasterTestAccomView
go

create view LEGACYSPED.EO_MasterTestAccomView
as
select s.StudentRefID, 
	s.IepRefID,
	TestParticipationRefID = a.IEPAccomSeq,
	TestParticipation = '',
		-- columns needed to determine test participation:
		a.ELDA,
	TestCode = aa.AccomType, -- this is a code. we will use a map to show the description 
	TestName = tn.EnrichTestName,
	AccomModRefID = aa.RecNum,
	IsModification = case when aa.AccomCode like '%MOD%' then 1 when aa.AccomCode is NULL then NULL else 0 end,
	AccomModText = convert(varchar(100), aa.AccomDesc)
-- select s.*
from LEGACYSPED.MAP_IEPStudentRefID s
join LEGACYSPED.EO_IEPAccomModTbl_RAW a on s.StudentRefID = a.GStudentID
join LEGACYSPED.EO_IEPAccomModTbl_SC_RAW a2 on a.IEPAccomSeq = a2.IEPAccomSeq and isnull(a.del_flag,0)=0 and isnull(a2.del_flag,0)=0
left join LEGACYSPED.EO_IEPAccomModListTbl_SC_RAW aa on a.iepaccomseq = aa.iepaccomseq and isnull(aa.del_flag,0)=0 
	and aa.AccomType not in (
		--'AC12', -- District assessments, which are imported separately
		'AC1', 'AC2', -- HSAP, which we are not importing, per Peter Keup at SCDE
		'AC11' -- Physical Science, not used in Enrich
	) 
left join LEGACYSPED.MAP_TestNames tn on aa.AccomType = tn.EOTestCode
go


select * from LEGACYSPED.EO_MasterTestAccomView


--if object_id('LEGACYSPED.EO_IEPAccomModTbl_SC_RAW') is not null
--drop table LEGACYSPED.EO_IEPAccomModTbl_SC_RAW
--go

--select a3.*
--into LEGACYSPED.EO_IEPAccomModTbl_SC_RAW
--from LEGACYSPED.EO_ICIEPAccomModTbl_RAW a
--join LEGACYSPED.EO_ICIEPAccomModTbl_SC_RAW a2 on a.IEPComplSeqNum = a2.IEPComplSeqNum and a.IEPAccomSeq = a2.IEPAccomSeq
--join [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPAccomModTbl_SC a3 on a.IEPAccomSeq = a3.IEPAccomSeq -- 2109



--exec sp_addlinkedserver  
--		@server = 'DEV2005' 
--		, @provider =N'SQLNCLI'
--		, @srvproduct = N''
--		, @datasrc = '10.0.1.8\SQLSERVER2005' 
--		--, @location = 'location' 
--		--, @provstr = '10.0.1.8\SQLSERVER2005' 
--		--, @catalog = 'catalog'  

--exec sp_addlinkedsrvlogin
--		'DEV2005', 'false', NULL, 'sa', 'sqlserver'

--select * 
--into LEGACYSPED.EO_Student_RAW
--from DEV2005.QASCConvert2005.dbo.student
--where spedstat = 1


-- how do I know they are taking a given test?

--one big wide view of all tests
select m.StudentRefID, s.StudentLocalID, s.Firstname, s.Lastname,
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
		a2.EOCUSHistory, a2.EOCUSHistoryCond,
--
	PASS = 0,
	PASSAlt = 0

from LEGACYSPED.MAP_IEPStudentRefID m 
	join LEGACYSPED.Student s on m.StudentRefID = s.StudentRefID
join LEGACYSPED.EO_IEPAccomModTbl_RAW a on m.StudentRefID = a.GStudentID
join LEGACYSPED.EO_IEPAccomModTbl_SC_RAW a2 on a.IEPAccomSeq = a2.IEPAccomSeq 
where /* a2.PACT = 2 and */ a2.GTTP = 1

go


select * from student where Number= '930677080000'
select * from PrgItem where StudentID = '12BED733-12F2-4104-90E5-CE9DC571A4F7'
select t.Name, s.* 
from PrgSection s
join PrgSectionDef d on s.DefID= d.ID
join PrgSectionType t on d.TypeID = t.ID
where itemID = '32388CC7-3908-48D9-82AE-6DED01413B98'

select * from IepAssessments where ID = '34131D7F-0505-40D3-B78A-814CA8DC1E6C'

exec x_datateam.findguid 'A0C84AE0-4F46-4DA5-9F90-D57AB212ED64'
select * from dbo.IepAssessmentsSectionDef where ID = 'A0C84AE0-4F46-4DA5-9F90-D57AB212ED64'
--select * from LEGACYSPED.ImportPrgSections where SectionDefID = 'A0C84AE0-4F46-4DA5-9F90-D57AB212ED64'
--select * from LEGACYSPED.MAP_FormInstanceID where SectionDefID = 'A0C84AE0-4F46-4DA5-9F90-D57AB212ED64'
--select * from LEGACYSPED.MAP_PrgSectionID_NonVersioned where DefID = 'A0C84AE0-4F46-4DA5-9F90-D57AB212ED64'
select * from dbo.PrgSection where DefID = 'A0C84AE0-4F46-4DA5-9F90-D57AB212ED64'
select * from dbo.PrgSectionDef where ID = 'A0C84AE0-4F46-4DA5-9F90-D57AB212ED64'
--select * from dbo.SecurityTask where TargetID = 'A0C84AE0-4F46-4DA5-9F90-D57AB212ED64'
--select * from dbo.SecurityTaskCategory where OwnerID = 'A0C84AE0-4F46-4DA5-9F90-D57AB212ED64'


select * from LEGACYSPED.StateDistrictParticipationDef

select * from dbo.ieptestdef where name not like '%NAEP%'


--Test status	: 1 Yes, 2 No, 3 NA
--Standard		: 1 Yes, 0 No (in EO No means non-std with mods)
--Participation	: 
--	Standard
--		Yes
--			2 Accoms
--			1 No Accoms
--		No
--			3 Modifications

--Participation: 1 Standard, 2 Std w/Accom, 3 Non-standard


-- note:  I am interpreting "N/A" in EO to equal "Not in group" in Enrich (seems incorrect - I was thinking of ELDA)

-- elda
select s.IEPComplSeqNum, s.IEPAccomSeq, 
	s.ELDA, s.ELDAStandard,
	t.EOTestCode, t.EnrichTestName,
	Participation = 
		case s.ELDA when 3 then 'Not in group' -- ELDA Assessment Not Applicable
			when 2 then 'Non-standard' -- When No is clicked, it seems to indicate that they are take the test, just not the standard version of it. (there is an NA button)
			when 1 then 
				case s.ELDAStandard when 1 then 'Standard' else 'Std w/Accom' end
	end
from LEGACYSPED.EO_ICIEPAccomModTbl_SC_RAW s
cross join LEGACYSPED.MAP_TestNames t 
where t.EOTestCode = 'AC14'
and s.ELDA = 2


union all

-- gttp
select a.IEPComplSeqNum, a.IEPAccomSeq, 
	t.EOTestCode, t.EnrichTestName,
	Participation = 
		case s.GTTP when '3' then 'Not in group' -- GTTP Assessment Not Applicable
			when '2' then 'Non-standard' -- When No is clicked, it seems to indicate that they are taking the test, just not the standard version of it. (there is an NA button)
			when '1' then 
				case when isnull(convert(varchar(max), s.GTTPAccom),'') in ('', 'NA', 'N/A', 'None', 'No') then 'Standard' else 'Std w/Accom' end
		end --, GTTP, GTTPAccom, GTTPData
from LEGACYSPED.EO_ICIEPAccomModTbl_RAW a -- select count(*) from LEGACYSPED.EO_ICIEPAccomModTbl_RAW a -- 2109
join LEGACYSPED.EO_IEPAccomModTbl_SC_RAW s on a.IEPAccomSeq = s.IEPAccomSeq -- 2109
cross join LEGACYSPED.MAP_TestNames t 
where t.EOTestCode = 'GTTP'
-- select * from LEGACYSPED.MAP_TestNames
union all
-- select * from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPAccomModTbl_SC 
select s.IEPComplSeqNum, s.IEPAccomSeq, 
	TestCode = t.EOTestCode, 
	DistAssessTitle = case s.DistAssess when 2 then s.AltAssess when 1 then s.DistAssessTitle end,
	Participation = 
		case s.DistAssess when 3 then NULL -- District Assessment Not Applicable
			when 2 then 'Non-standard with modifications'
			when 1 then 
				case when acc.Accommodations is null then 'Standard, no accommodations' else 'Standard, with accommodations' end
		end
from LEGACYSPED.EO_ICIEPAccomModTbl_SC_RAW s
join (
	select a1.IEPComplSeqNum,
		Accommodations = (
			select li = t1.AccomDesc -- column name will be used as a tag
			from LEGACYSPED.EO_ICIEPAccomModListTbl_SC_RAW t1
			where a1.IEPComplSeqNum = t1.IEPComplSeqNum and a1.IEPAccomSeq = t1.IEPAccomSeq 
			and t1.AccomType = 'AC12' 
			and isnull(a1.del_flag,0)=0 and isnull(t1.del_flag,0)=0
			for xml path('')
			)
	from LEGACYSPED.EO_ICIEPAccomModTbl_RAW a1 
) acc on s.IEPComplSeqNum = acc.IEPComplSeqNum
join (-- pretend this is spedstudentsandieps view
	select GStudentID, IEPSeqNum = max(r.iepseqnum) 
	from LEGACYSPED.EO_IEPCompleteTbl_RAW r
	where isnull(del_flag,0)=0
	group by GStudentID
) i on s.IEPComplSeqNum = i.IEPSeqNum
cross join LEGACYSPED.MAP_TestNames t 
where 1=1
-- and a.GStudentID = '0488EAF3-8C46-43CC-8FB3-A4F56808DF1D' 
and isnull(s.del_flag,0)=0
and t.EOTestCode = 'AC12'



-- distinct list of tests
select TestCode, TestName
from LEGACYSPED.EO_MasterTestAccomView
group by TestCode, TestName

-- distinct list of accom / mods
select AccomModText, IsModification
from LEGACYSPED.EO_MasterTestAccomView
group by AccomModText, IsModification


-- distinct list of tests and accom / mod combinations
select TestCode, TestName, AccomModText, IsModification
from LEGACYSPED.EO_MasterTestAccomView
group by TestCode, TestName, AccomModText, IsModification




insert IepAllowedTestAccom
select TestDefID = td.ID, AccomDefID = ad.ID
from LEGACYSPED.EO_MasterTestAccomView v
left join IepTestDef td on v.TestName = td.Name
left join IepAccommodationDef ad on convert(varchar(100), v.AccomModText) = ad.Text and ad.CategoryID = 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E'
left join IepAllowedTestAccom ata on td.ID = ata.TestDefID and ad.ID = ata.AccomDefID
where ata.TestDefID is null
group by td.ID, ad.ID

-- try again
select v.TestName, v.IsModification, AccomModText = convert(varchar(100), v.AccomModText),
	td.ID, ad.ID
from LEGACYSPED.EO_MasterTestAccomView v
left join IepTestDef td on v.TestName = td.Name
left join IepAccommodationDef ad on convert(varchar(100), v.AccomModText) = ad.Text and ad.CategoryID = 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E'
left join IepAllowedTestAccom ata on td.ID = ata.TestDefID and ad.ID = ata.AccomDefID
where isnull(Testname,'')  not in ('', 'District Assessments')
	and ata.TestDefID is null -------------------------------------------------------------- only insert if not exists
group by v.TestName, v.IsModification, convert(varchar(100), v.AccomModText), td.ID, ad.ID
-- why not make this a view?  this is inserting a table. we can put the test for existance in the where clause of the view

--select TestDefID = td.ID, AccommodationDefID = ad.ID
--from IepTestDef td
--join LEGACYSPED.MAP_TestNames m on td.Name = m.EnrichTestName
--cross join IepAccommodationDef ad
--where ad.CategoryID = 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E'

--- all accoms from EO, only the accomdesc is needed, later we will associate with tests 
--select AccomDesc = convert(varchar(100), aa.AccomDesc)
--from LEGACYSPED.MAP_IEPStudentRefID s
--join LEGACYSPED.EO_ICIEPAccomModTbl_RAW a on s.IEPRefID = a.iepcomplseqnum
--join LEGACYSPED.EO_ICIEPAccomModListTbl_SC_RAW aa on a.iepcomplseqnum = aa.iepcomplseqnum and a.iepaccomseq = aa.iepaccomseq
--group by convert(varchar(100), aa.AccomDesc)


---- to be fastidious about it, we're ensuring that only the legacy test and accoms relationships in EO are considered "Allowed" in Enrich
--select a.TestDefID, a.AccomDefID
--from (
--select TestDefName = aa.AccomType, AccommodationText = convert(varchar(100), aa.AccomDesc), TestDefID = td.ID, AccomDefID = ad.ID
--from LEGACYSPED.MAP_IEPStudentRefID s
--join LEGACYSPED.EO_ICIEPAccomModTbl_RAW a on s.IEPRefID = a.iepcomplseqnum
--join LEGACYSPED.EO_ICIEPAccomModListTbl_SC_RAW aa on a.iepcomplseqnum = aa.iepcomplseqnum and a.iepaccomseq = aa.iepaccomseq
--left join LEGACYSPED.MAP_TestNames m on aa.AccomType = m.EOTestCode -- AccomType in EO
--left join IepTestDef td on m.EnrichTestName = td.Name
--left join IepAccommodationDef ad on convert(varchar(100), aa.AccomDesc) = ad.Text and ad.CategoryID = 'B90D4D56-4A20-4901-BD7B-2FC99BF5D42E'
--where aa.AccomType not in (
--	'AC1', 'AC2', -- HSAP, which we are not importing, per Peter Keup at SCDE
--	'AC11', -- Physical Science, not used in Enrich
--	'AC12' -- District assessments, which are imported separately
--	) 
--group by aa.AccomType, convert(varchar(100), aa.AccomDesc), ad.ID, td.ID
--) a
--left join IepAllowedTestAccom x on a.TestDefID = x.TestDefID and a.AccomDefID = x.AccomDefID
--where x.TestDefID is null



select * from IepTestParticipation

select * from PrgSection where ID = 'FDADC456-9911-47DA-89F5-6DD8F1C717E1'
select * from PrgItem where ID = '74E32240-FD3E-4DFC-A08C-7D10CD8943C6'
select * from PrgItemDef where ID = '32DD5426-10E7-4FE7-9FFC-E233382025EC' --- IEP - Transition (13+)


select * from PrgItemDef where name like 'Conve%'
select t.name, d.* from PrgSectionDef d join PrgSectionType t on d.TypeID = t.ID where d.ItemDefID = '1984F017-51CB-4E3C-9B3A-338A9D409EC6' and t.name like '%assess%'

select * from FormTemplate where ID = '9C0BA64E-C848-42F4-9A16-B9B6D37CA85C'


-- not needed ?
-- insert IepAccomQuestion (ID, Text, QuestionCategoryID, Sequence, DeletedDate) values ('82A6C533-ADC3-49F7-8104-4660DE312385', 'Imported from Excent Online', '04DEC8CB-68F7-4AF1-BA16-6A922381737B', 99, getdate())


--insert IepAccomFilteringQuestion (QuestionID, AccomDefID)
--select '82A6C533-ADC3-49F7-8104-4660DE312385', ad.ID -- Accom Question: Imported from Excent Online
--from IepAccommodationDef ad
--left join IepAccomFilteringQuestion fq on ad.ID = fq.AccomDefID and fq.QuestionID = '82A6C533-ADC3-49F7-8104-4660DE312385'
--where ad.CategoryID = '04DEC8CB-68F7-4AF1-BA16-6A922381737B' -- Legacy Excent Online Accommodation
--and fq.AccomDefID is null
--go


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
	ParticipationType = pd.Text, 
	DistrictParticipationDefID = max(convert(varchar(36), pdd.ID)),
	StateParticipationDefID = max(convert(varchar(36), pds.ID))
from IepAllowedTestParticipation atp 
join IepTestDef td on atp.TestDefID = td.ID
join IepTestParticipationDef pd on atp.ParticipationDefID = pd.ID -- one row each
left join IepTestParticipationDef pdd on atp.ParticipationDefID = pdd.ID and td.IsState = 0
left join IepTestParticipationDef pds on atp.ParticipationDefID = pds.ID and td.IsState = 1
where pd.text in ('Not in group', 'Standard', 'Std w/ Accom', 'Alternate', 'Non-Standard')  -- these are the only ones coming from Excent Online
group by pd.Text
go


if object_id('LEGACYSPED.MAP_IepTestParticipationID ') is not null
drop table LEGACYSPED.MAP_IepTestParticipationID 
go

-- not having a unique id for every test participation for the student, we us a multi-column key
create table LEGACYSPED.MAP_IepTestParticipationID (
TestAccomRefID	int	not null,
TestName	varchar(200)	not null,
IsState	bit	not null,
ParticipationType	varchar(200) not null,
DestID	uniqueidentifier not null 
)
-- not sure about this map table yet. we are getting the instance ID from MAP_PrgSection, of course
go

--select * from IepTestParticipation

-- prereq for the ieptestpart view

-- LEGACYSPED.Encore_TestParticipation
--select IEPRefID = i.id, t.* 
--from (
--	select TestAccommRefID = i8.ID, EventGroupID = i8.lngEventGroupID, TestName = 'Reading', OtherDesc = '', IsState = cast(1 as bit), 
-- ParticipationType = 'Regular', AccomOkay = cast(1 as bit) from x_WalkIEP.Encore_CO_IEP_Page08_RAW i8 where i8.lngStatusId = 1727 and i8.chkCSAP1 = 1 UNION ALL
select TestAccommRefID = al.IEPAccomSeq, IEPRefID = al.IEPComplSeqNum, TestName = tn.EnrichTestName, OtherDesc = '', IsState = 1, ParticipationType = '', AccomOkay = 1
from LEGACYSPED.EO_ICIEPAccomModListTbl_SC_RAW al
join LEGACYSPED.MAP_TestNames tn on al.AccomType = tn.EOTestCode



select * from LEGACYSPED.MAP_TestNames 


if object_id('LEGACYSPED.Transform_IepTestParticipation') is not null
drop view LEGACYSPED.Transform_IepTestParticipation
go

create view LEGACYSPED.Transform_IepTestParticipation
as
select 
	etp.IepRefID,
	etp.TestAccommRefID,
	etp.EventGroupID, 
	etp.TestName, 
	etp.OtherDesc, 
	etp.IsState, 
	etp.ParticipationType, 
	-- IepTestParticipation
	DestID = m.DestID,
	InstanceID = m.DestID,
	TestDefID = itd.ID, 
	ParticipationDefID = case etp.IsState when 0 then tpd.DistrictParticipationDefID when 1 then tpd.StateParticipationDefID end
from LEGACYSPED.Transform_PrgIep iep join 
	LEGACYSPED.EO_TestParticipation etp on iep.IepRefID = etp.IEPRefID join -- test and participation from legacy data
	dbo.IepTestDef itd on etp.TestName = itd.Name and etp.IsState = itd.IsState join -- "other 2" from Encore is not represented in Enrich
	LEGACYSPED.StateDistrictParticipationDef tpd on etp.ParticipationType = tpd.ParticipationType join 
	LEGACYSPED.MAP_PrgSectionID m on 
		m.DefID = '6B65D022-365A-42F3-979E-73F7A887C2C4' and -- Iep Assessments
		m.VersionID = iep.VersionDestID left join 
	IepTestParticipation tp on 
		itd.id = tp.TestDefID and
		m.DestID = tp.InstanceID
--where tp.ID is null 
go







--drop table LEGACYSPED.EO_IEPCompleteTbl_RAW 
--go

--select ic.* 
--into LEGACYSPED.EO_IEPCompleteTbl_RAW 
--from (select gstudentid, iepseqnum = max(iepseqnum) from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPCompleteTbl where isnull(del_flag,0)=0 group by gstudentid) si
--join [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPCompleteTbl ic on si.IEPSeqNum = ic.IEPSeqNum






--select top 10 * from LEGACYSPED.EO_ICIEPAccomModListTbl_SC_RAW 


-- are the following not in EO?
--2nd Grade GT
--ELDA







-- select * from LEGACYSPED.MAP_TestNames 

--create MAP tables for all records inserted into Enrich database (Accom category, def.)
--not for associating the inserteed accoms and defs with tests, though




-- test accommodations per student / IEP
select a.GStudentID, a.IEPComplSeqNum, a.IEPAccomSeq, tn.EOTestCode, tn.EOTestName, aa.AccomDesc
from (-- pretend this is spedstudentsandieps view
select IEPSeqNum = max(iepseqnum) from LEGACYSPED.EO_IEPCompleteTbl_RAW group by gstudentid --- where gstudentid = '0488EAF3-8C46-43CC-8FB3-A4F56808DF1D'
) s
join LEGACYSPED.EO_ICIEPAccomModTbl_RAW a on s.iepseqnum = a.iepcomplseqnum
join LEGACYSPED.EO_ICIEPAccomModListTbl_SC_RAW aa on a.iepcomplseqnum = aa.iepcomplseqnum and a.iepaccomseq = aa.iepaccomseq
join LEGACYSPED.MAP_TestNames tn on aa.AccomType = tn.EOTestCode
where isnull(a.Del_flag,0)=0 and isnull(aa.Del_Flag, 0) = 0 



select tn.EOTestName, AccomDesc = convert(varchar(100), aa.AccomDesc), count(*) tot
from (-- pretend this is spedstudentsandieps view
select IEPSeqNum = max(iepseqnum) from LEGACYSPED.EO_IEPCompleteTbl_RAW group by gstudentid --- where gstudentid = '0488EAF3-8C46-43CC-8FB3-A4F56808DF1D'
) s
join LEGACYSPED.EO_ICIEPAccomModTbl_RAW a on s.iepseqnum = a.iepcomplseqnum
join LEGACYSPED.EO_ICIEPAccomModListTbl_SC_RAW aa on a.iepcomplseqnum = aa.iepcomplseqnum and a.iepaccomseq = aa.iepaccomseq
join LEGACYSPED.MAP_TestNames tn on aa.AccomType = tn.EOTestCode
group by convert(varchar(100), aa.AccomDesc), tn.EOTestName


-- select * from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.Student where StudentID = '168607582900'

-- 0488EAF3-8C46-43CC-8FB3-A4F56808DF1D

---- district assessment and accoms
--select s.DistAssessTitle, Participation = 'Standard, with accommodations', t.AccomDesc
--from IEPAccomModTbl a 
--join IEPAccomModTbl_SC s on a.IEPAccomSeq = s.IEPAccomSeq and isnull(s.del_flag,0)=0
--join IEPAccomModListTbl_SC t on a.IEPAccomSeq = t.IEPAccomSeq and t.AccomType = 'AC12' and isnull(t.del_flag,0)=0
--where a.GStudentID = 'AD97EFDC-0D0E-44E3-A2CC-E0BC43573EE2' 
--and isnull(a.del_flag,0)=0





------ District assessments completed IEPs
--select a.gstudentid, 
--	DistAssessTitle = case s.DistAssess when 2 then s.AltAssess when 1 then s.DistAssessTitle end,
--	Participation = 
--		case s.DistAssess when 3 then NULL -- District Assessment Not Applicable
--			when 2 then 'Non-standard with modifications'
--			when 1 then 
--				case when acc.Accommodations is null then 'Standard, no accommodations' else 'Standard, with accommodations' end
--		end,
--	Accommodations = case s.DistAssess when 3 then NULL else '<ul>'+acc.Accommodations+'</ul>' end
--from LEGACYSPED.EO_ICIEPAccomModTbl_RAW a 
--join LEGACYSPED.EO_ICIEPAccomModTbl_SC_RAW s on a.IEPComplSeqNum = s.IEPComplSeqNum and a.IEPAccomSeq = s.IEPAccomSeq and isnull(s.del_flag,0)=0
--join (
--	select a1.IEPComplSeqNum,
--		Accommodations = (
--			select li = t1.AccomDesc -- column name will be used as a tag
--			from LEGACYSPED.EO_ICIEPAccomModListTbl_SC_RAW t1
--			where a1.IEPComplSeqNum = t1.IEPComplSeqNum and a1.IEPAccomSeq = t1.IEPAccomSeq 
--			and t1.AccomType = 'AC12' 
--			and isnull(a1.del_flag,0)=0 and isnull(t1.del_flag,0)=0
--			for xml path('')
--			)
--	from LEGACYSPED.EO_ICIEPAccomModTbl_RAW a1 
--) acc on a.IEPComplSeqNum = acc.IEPComplSeqNum
--join (-- pretend this is spedstudentsandieps view
--	select GStudentID, IEPSeqNum = max(r.iepseqnum) 
--	from LEGACYSPED.EO_IEPCompleteTbl_RAW r
--	where isnull(del_flag,0)=0
--	group by GStudentID
--) i on a.IEPComplSeqNum = i.IEPSeqNum
--where 1=1
---- and a.GStudentID = '0488EAF3-8C46-43CC-8FB3-A4F56808DF1D' 
--and isnull(a.del_flag,0)=0
----and a.IEPComplSeqNum = 18235







---- district assessments

--select DistAssess, DistAssessTitle, AltAssess, * from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPAccomModTbl_SC where IEPAccomSeq = 3269
--select * from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPAccomModListTbl_SC where IEPAccomSeq = 3269

------ District assessments TESTING
--select a.gstudentid, 
--	DistAssessTitle = case s.DistAssess when 2 then s.AltAssess when 1 then s.DistAssessTitle end,
--	Participation = 
--		case s.DistAssess when 3 then NULL -- District Assessment Not Applicable
--			when 2 then 'Non-standard with modifications'
--			when 1 then 
--				case when acc.Accommodations is null then 'Standard, no accommodations' else 'Standard, with accommodations' end
--		end,
--	Accommodations = case s.DistAssess when 3 then NULL else '<ul>'+acc.Accommodations+'</ul>' end
--from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPAccomModTbl a 
----join [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPAccomModTbl_SC s on a.IEPComplSeqNum = s.IEPComplSeqNum and a.IEPAccomSeq = s.IEPAccomSeq and isnull(s.del_flag,0)=0
--join [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPAccomModTbl_SC s on a.IEPAccomSeq = s.IEPAccomSeq and isnull(s.del_flag,0)=0
--join (
--	--select a1.IEPComplSeqNum,
--	select a1.gstudentid,
--		Accommodations = (
--			select li = t1.AccomDesc -- column name will be used as a tag
--			from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPAccomModListTbl_SC t1
--			--where a1.IEPComplSeqNum = t1.IEPComplSeqNum and a1.IEPAccomSeq = t1.IEPAccomSeq 
--			where a1.iepaccomseq = t1.iepaccomseq
--			and t1.AccomType = 'AC12' 
--			and isnull(a1.del_flag,0)=0 and isnull(t1.del_flag,0)=0
--			for xml path('')
--			)
--	from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPAccomModTbl a1 
----) acc on a.IEPComplSeqNum = acc.IEPComplSeqNum
--) acc on a.gstudentid = acc.gstudentid
----join (-- pretend this is spedstudentsandieps view
----	select GStudentID, IEPSeqNum = max(r.iepseqnum) 
----	from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPCompleteTbl r
----	where isnull(del_flag,0)=0
----	group by GStudentID
----) i on a.IEPComplSeqNum = i.IEPSeqNum
--where 1=1
---- and a.GStudentID = '0488EAF3-8C46-43CC-8FB3-A4F56808DF1D' 
--and isnull(a.del_flag,0)=0
---- and a.IEPComplSeqNum = 18235
--and a.gstudentid = '010DF00C-8F35-4920-9662-002632D600E2'


























--select * from LEGACYSPED.EO_ICIEPAccomModTbl_RAW where IEPComplSeqNum = 18235
select DistAssess, DistAssessTitle, AltAssess, * from LEGACYSPED.EO_ICIEPAccomModTbl_SC_RAW where IEPComplSeqNum = 18235
--select * from LEGACYSPED.EO_ICIEPAccomModListTbl_SC_RAW where IEPComplSeqNum = 18235

--select * from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.Student where gstudentid = '010DF00C-8F35-4920-9662-002632D600E2'
--select * from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPAccomModTbl where GStudentID = '010DF00C-8F35-4920-9662-002632D600E2'
select DistAssess, DistAssessTitle, AltAssess, * from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPAccomModTbl_SC where IEPAccomSeq = 3269





-- select * from LEGACYSPED.EO_IEPCompleteTbl_RAW where GStudentID = '0488EAF3-8C46-43CC-8FB3-A4F56808DF1D' 
-- 17076

select * from LEGACYSPED.EO_ICIEPAccomModTbl_RAW where GStudentID = '0488EAF3-8C46-43CC-8FB3-A4F56808DF1D' 
select * from LEGACYSPED.EO_ICIEPAccomModTbl_SC_RAW where IEPComplSeqNum = 17076

select * from DEV2005.QASCConvert2005.dbo.ICIEPAccomModTbl_SC where IEPComplSeqNum = 17076


update am set DistAssessTitle = 'George'
-- select * 
from LEGACYSPED.EO_ICIEPAccomModTbl_SC_RAW am
where IEPComplSeqNum = 17076


--insert LEGACYSPED.EO_ICIEPAccomModListTbl_SC_RAW
--select * 
--from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.ICIEPAccomModListTbl_SC 
--where IEPComplSeqNum = 17076 and AccomType = 'AC12'





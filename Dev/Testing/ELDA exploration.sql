
------ ELDA is a STATE assessment. 

-- select * from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPAccomModListTbl_SC where IEPAccomSeq = 3269
--select ELDA, ELDAStandard, * from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPAccomModTbl_SC where IEPAccomSeq = 3269


---- ELDA assessments TESTING
select a.gstudentid, 
	TestCode = 'AC14',
	StateAssessTitle = 'ELDA',
	Participation = 
		case s.ELDA when 3 then 'Not in group' -- ELDA Assessment Not Applicable
			when 2 then 'Non-standard' -- When No is clicked, it seems to indicate that they are take the test, just not the standard version of it. (there is an NA button)
			when 1 then 
				case s.ELDAStandard when 1 then 'Standard' else 'Std w/Accom' end
	end
	--	,
	--Accommodations = case s.ELDA when 3 then NULL else '<ul>'+acc.Accommodations+'</ul>' end
from LEGACYSPED.EO_IEPAccomModTbl_RAW a 
--join LEGACYSPED.EO_IEPAccomModTbl_SC_RAW s on a.IEPComplSeqNum = s.IEPComplSeqNum and a.IEPAccomSeq = s.IEPAccomSeq and isnull(s.del_flag,0)=0
join LEGACYSPED.EO_IEPAccomModTbl_SC_RAW s on a.IEPAccomSeq = s.IEPAccomSeq and isnull(s.del_flag,0)=0
--join (
--	--select a1.IEPComplSeqNum,
--	select a1.gstudentid,
--		Accommodations = (
--			select li = t1.AccomDesc -- column name will be used as a tag
--			from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPAccomModListTbl_SC t1
--			--where a1.IEPComplSeqNum = t1.IEPComplSeqNum and a1.IEPAccomSeq = t1.IEPAccomSeq 
--			where a1.iepaccomseq = t1.iepaccomseq
--			and t1.AccomType = 'AC14' 
--			and isnull(a1.del_flag,0)=0 and isnull(t1.del_flag,0)=0
--			for xml path('')
--			)
--	from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPAccomModTbl a1 
--) acc on a.IEPComplSeqNum = acc.IEPComplSeqNum
--) acc on a.gstudentid = acc.gstudentid
--join (-- pretend this is spedstudentsandieps view
--	select GStudentID, IEPSeqNum = max(r.iepseqnum) 
--	from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPCompleteTbl r
--	where isnull(del_flag,0)=0
--	group by GStudentID
--) i on a.IEPComplSeqNum = i.IEPSeqNum
where 1=1
-- and a.GStudentID = '0488EAF3-8C46-43CC-8FB3-A4F56808DF1D' 
and isnull(a.del_flag,0)=0
-- and a.IEPComplSeqNum = 18235
--and a.gstudentid = '010DF00C-8F35-4920-9662-002632D600E2'


--- ELDA accoms


-- let's do all of the test accoms in 1 big view
select m.IEPRefID, a1.IEPAccomSeq, SubRefID = t1.RecNum, t1.AccomType, t1.AccomDesc
from LEGACYSPED.MAP_IEPStudentRefID m
join LEGACYSPED.EO_IEPAccomModTbl_RAW a on m.StudentRefID = a.GStudentID
join LEGACYSPED.EO_IEPAccomModTbl_SC_RAW a1 on a.IEPAccomSeq = a1.IEPAccomSeq and isnull(a.del_flag,0)=0 and isnull(a1.del_flag,0)=0 
join LEGACYSPED.EO_IEPAccomModListTbl_SC_RAW t1 on a1.IEPAccomSeq = t1.IEPAccomSeq and isnull(t1.del_flag,0)=0
--where a1.IEPComplSeqNum = t1.IEPComplSeqNum and a1.IEPAccomSeq = t1.IEPAccomSeq 
where a1.iepaccomseq = t1.iepaccomseq
and t1.AccomType not in ('AC1', 'AC2', 'AC12') -- not used
go

select * from LEGACYSPED.StateDistrictParticipationDef


select * from LEGACYSPED.EO_MasterTestAccomView




--select GTTP, GTTPAccom, GTTPData, * from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPAccomModTbl_SC where IEPAccomSeq = 3269
--select * from [10.0.1.8SQLServer2005DEMO].QASCConvert2005.dbo.IEPAccomModListTbl_SC where IEPAccomSeq = 3269


---- GTTP assessments TESTING
select a.GStudentID, 
	TestCode = 'NONE', -- to match with other EO records (None for GTTP because there are no accommodations stored in IEPAccomModListTbl_SC)
	StateAssessTitle = '2nd Grade GT', -- to match with Enrich records (based on name)
	Participation = 
		case s.GTTP when '3' then 'Not in group' -- GTTP Assessment Not Applicable
			when '2' then 'Non-standard' -- When No is clicked, it seems to indicate that they are taking the test, just not the standard version of it. (there is an NA button)
			when '1' then 
				case when isnull(convert(varchar(max), s.GTTPAccom),'') in ('', 'NA', 'N/A', 'None', 'No') then 'Standard' else 'Std w/Accom' end
		end --, GTTP, GTTPAccom, GTTPData
from LEGACYSPED.EO_IEPAccomModTbl_RAW a 
join LEGACYSPED.EO_IEPAccomModTbl_SC_RAW s on a.IEPAccomSeq = s.IEPAccomSeq and isnull(s.del_flag,0)=0
where 1=1
and isnull(a.del_flag,0)=0
--and a.GStudentID = '010DF00C-8F35-4920-9662-002632D600E2'


--Msg 402, Level 16, State 1, Line 29
--The data types ntext and varchar are incompatible in the equal to operator.


--- create schema LEGACYACCOM


select a.*
from LEGACYSPED.MAP_IEPStudentRefID m 
join Dev2005.QASCConvert2005.dbo.IEPAccomModTbl a on m.StudentRefID = a.GStudentID -- notice that intellisense not working here. That's why we use table variables, to leverage intellisense on queries below
join Dev2005.QASCConvert2005.dbo.IEPAccomModTbl_SC a2 on a.IEPAccomSeq = a2.IEPAccomSeq 
where isnull(a.del_flag,0)=0

select a2.*
from LEGACYSPED.MAP_IEPStudentRefID m 
join Dev2005.QASCConvert2005.dbo.IEPAccomModTbl a on m.StudentRefID = a.GStudentID
join Dev2005.QASCConvert2005.dbo.IEPAccomModTbl_SC a2 on a.IEPAccomSeq = a2.IEPAccomSeq 
where isnull(a.del_flag,0)=0 and isnull(a2.del_flag,0)=0

select aa.*
from LEGACYSPED.MAP_IEPStudentRefID m 
join Dev2005.QASCConvert2005.dbo.IEPAccomModTbl a on m.StudentRefID = a.GStudentID
join Dev2005.QASCConvert2005.dbo.IEPAccomModTbl_SC a2 on a.IEPAccomSeq = a2.IEPAccomSeq 
join Dev2005.QASCConvert2005.dbo.IEPAccomModListTbl_SC aa on a.IEPAccomSeq = aa.IEPAccomSeq 
where isnull(a.del_flag,0)=0 and isnull(a2.del_flag,0)=0 and isnull(aa.del_flag,0)=0






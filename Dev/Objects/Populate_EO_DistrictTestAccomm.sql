IF EXISTS (SELECT 1 FROM sys.schemas s JOIN sys.objects o on s.schema_id = o.schema_id WHERE s.name = 'x_LEGACYACCOM' AND o.name = 'Populate_DistrictTestAccomm_LOCAL')
DROP PROC x_LEGACYACCOM.Populate_DistrictTestAccomm_LOCAL
GO

CREATE PROC x_LEGACYACCOM.Populate_DistrictTestAccomm_LOCAL
AS
BEGIN

insert x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL 
select m.IEPRefID, SubRefID = a.IEPAccomSeq,
	DistAssessTitle = case isnull(a2.DistAssess,0) when 2 then cast(a2.AltAssess as varchar(100)) when 1 then a2.DistAssessTitle end,
	Participation = 
		case isnull(a2.DistAssess,0) when 3 then NULL -- District Assessment Not Applicable
			when 2 then '1A5FC3E2-4C97-4323-976A-D9D129D92414' --1A5FC3E2-4C97-4323-976A-D9D129D92414	Non-standard with modifications
			when 1 then 
				case 
					when acc.Accommodations is null then '024F58CF-A177-426B-AE43-7F758962752F' --024F58CF-A177-426B-AE43-7F758962752F	Standard, no accommodations
					else '5D3D44BA-3348-4E5A-A321-5253F76DFEC8' --5D3D44BA-3348-4E5A-A321-5253F76DFEC8	Standard, with accommodations
				end
		end,
	Accommodations = 
		case isnull(a2.DistAssess,0) when 3 then NULL -- N/A in the EO UI
			when 0 then NULL
			else '<ul>'+acc.Accommodations+'</ul>' -- 1 Accommodations, 2 Modifications (non-standard means Alternate district assessment, with modifications, per Enrich UI drop-down)
		end,
	Sequence = 0 -- hard coding to cheat here - we only have 1 district assessment in EO
from LEGACYSPED.MAP_IEPStudentRefID m
join x_LEGACYACCOM.EO_IEPAccomModTbl_RAW a on m.StudentRefID = a.GStudentID
join x_LEGACYACCOM.EO_IEPAccomModTbl_SC_RAW a2 on a.IEPAccomSeq = a2.IEPAccomSeq and isnull(a2.del_flag,0)=0 and isnull(a.del_flag,0)=0
join (
	select a1.IEPAccomSeq,
		Accommodations = (
			select li = t1.AccomDesc -- column name will be used as a tag 
			from x_LEGACYACCOM.EO_IEPAccomModListTbl_SC_RAW t1
			where a1.IEPAccomSeq = t1.IEPAccomSeq 
			and t1.AccomType = 'AC12' 
			and isnull(a1.del_flag,0)=0 and isnull(t1.del_flag,0)=0
			for xml path('')
			)
	from x_LEGACYACCOM.EO_IEPAccomModTbl_RAW a1 
) acc on a.IEPAccomSeq = acc.IEPAccomSeq
END
GO

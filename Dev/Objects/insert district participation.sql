

select * from x_DATATEAM.ImportPrgSections20140918

select * from PrgItemDef where name like 'conv%'


select sdf.Sequence, SectionDefID = sdf.ID, sdf.FormTemplateID, sdf.HeaderFormTemplateID, SectionType = stf.Name
from dbo.PrgSectionDef sdf 
left join dbo.PrgSectionType stf on sdf.TypeID = stf.ID
where sdf.ItemDefID = '1984F017-51CB-4E3C-9B3A-338A9D409EC6'



select curr.*, prev.SectionDefID
from (
	select sdf.Sequence, SectionDefID = sdf.ID, sdf.FormTemplateID, sdf.HeaderFormTemplateID, SectionType = stf.Name
	from dbo.PrgSectionDef sdf 
	left join dbo.PrgSectionType stf on sdf.TypeID = stf.ID
	where sdf.ItemDefID = '1984F017-51CB-4E3C-9B3A-338A9D409EC6') curr 
left join x_DATATEAM.ImportPrgSections20140918 prev on curr.SectionDefID = prev.sectiondefid

select * from FormTemplate where ID = '9C0BA64E-C848-42F4-9A16-B9B6D37CA85C' -- now Deleted!

select * from FormTemplate where name like '%Assess%'


select * from PrgSectionDef where FormTemplateID = '9C0BA64E-C848-42F4-9A16-B9B6D37CA85C'

x_datateam.findguid '9C0BA64E-C848-42F4-9A16-B9B6D37CA85C'

select * from dbo.FormInstance where TemplateId = '9C0BA64E-C848-42F4-9A16-B9B6D37CA85C'
select * from dbo.FormTemplate where Id = '9C0BA64E-C848-42F4-9A16-B9B6D37CA85C'
select * from dbo.FormTemplateFormInterval where TemplateId = '9C0BA64E-C848-42F4-9A16-B9B6D37CA85C'
select * from dbo.FormTemplateLayout where TemplateId = '9C0BA64E-C848-42F4-9A16-B9B6D37CA85C'
select * from x_DATATEAM.ImportPrgSections20140918 where HeaderFormTemplateID = '9C0BA64E-C848-42F4-9A16-B9B6D37CA85C'

select fi.* 
from dbo.FormInstance fi 
join PrgItemForm pif on fi.id = pif.ID
join PrgItem i on pif.ItemID = i.ID
left join PrgSection ps on i.id = ps.ItemID and fi.Id = ps.HeaderFormInstanceID
where fi.TemplateId = '9C0BA64E-C848-42F4-9A16-B9B6D37CA85C'

select * from FormTemplate where ID = '9C0BA64E-C848-42F4-9A16-B9B6D37CA85C'


x_datateam.findguid 'A09FF042-89C2-4A02-8CF8-248B26616702'
select * from dbo.FormInstance where Id = 'A09FF042-89C2-4A02-8CF8-248B26616702'
select * from dbo.FormInstanceInterval where InstanceId = 'A09FF042-89C2-4A02-8CF8-248B26616702'
select * from LEGACYSPED.MAP_FormInstanceID where HeaderFormInstanceID = 'A09FF042-89C2-4A02-8CF8-248B26616702'
select * from dbo.PrgItemForm where ID = 'A09FF042-89C2-4A02-8CF8-248B26616702'



select * from FormTemplate where name like '%Assess%'

-- update FormTemplate set name = 'Assessments' where ID = '9C0BA64E-C848-42F4-9A16-B9B6D37CA85C'

x_datateam.findguid '9C0BA64E-C848-42F4-9A16-B9B6D37CA85C'

select * from dbo.FormInstance where TemplateId = '9C0BA64E-C848-42F4-9A16-B9B6D37CA85C'
select * from dbo.FormTemplate where Id = '9C0BA64E-C848-42F4-9A16-B9B6D37CA85C'
select * from dbo.FormTemplateFormInterval where TemplateId = '9C0BA64E-C848-42F4-9A16-B9B6D37CA85C'
select * from dbo.FormTemplateLayout where TemplateId = '9C0BA64E-C848-42F4-9A16-B9B6D37CA85C'
select * from x_DATATEAM.ImportPrgSections20140918 where HeaderFormTemplateID = '9C0BA64E-C848-42F4-9A16-B9B6D37CA85C'
select * from dbo.PrgSectionDef where HeaderFormTemplateID = '9C0BA64E-C848-42F4-9A16-B9B6D37CA85C'



select * from PrgSectionType
select * from PrgSectionDef where TypeID = '6F3F1C06-64C6-4C70-A834-0941ACCD0F62'

select * from x_DATATEAM.ImportPrgSections20140918

select * from MedicaidAuthorization

DELETE x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL 

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
	Sequence = (select count(*) from x_LEGACYACCOM.EO_IEPAccomModTbl_RAW c where a.GStudentID = c.GStudentID and a.IEPAccomSeq > c.IEPAccomSeq) -- cannot cheat anymore we were getting more than one result per IEP at Oconee.
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
go
































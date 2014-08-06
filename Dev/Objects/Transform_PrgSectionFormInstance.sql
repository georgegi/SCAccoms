--create schema x_LEGACYACCOM


CREATE VIEW x_LEGACYACCOM.Transform_PrgSectionFormInstance
AS
with CTE_Formlets
as (
	select 
		Item = 'IEP',
		itm.IEPRefID,
		ItemID = itm.DestID,
		-- sd.IsVersioned, -- is this needed?  
		--sec.FormPlace,
		sec.SectionDefID,
	-- FormInstance
		sec.FormTemplateID, -------------------------- form template id
		sec.HeaderFormTemplateID,
		mfi.FormInstanceID, -- DestID / FormInstanceID
		mfi.HeaderFormInstanceID, 
	-- PrgItemForm 
		CreatedDate = GETDATE(),
		CreatedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- BuiltIn: Support
		AssociationTypeID = 'DE0AFD97-84C8-488E-94DC-E17CAAA62082', -- PrgItemFormType.ID = Section -- Okay to hard-code
	-- FormInstanceInterval 
		mfi.FormInstanceIntervalID,
		mfi.HeaderFormInstanceIntervalID,
		IntervalID = 'FBE8314C-E0A0-4C5A-9361-7201081BD47D', -- Value 
		CompletedDate = GETDATE(),
		CompletedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB' -- BuiltIn: Support
	FROM -- select itm.IepRefID from
		Legacysped.Transform_PrgIep itm JOIN 
		dbo.PrgSectionDef sd on itm.DefID = sd.ItemDefID and not (sd.FormTemplateID is null and sd.HeaderFormTemplateID is null) join 
		x_LEGACYACCOM.ImportPrgSectionsFormTemplates sec on sd.ID = sec.SectionDefID LEFT JOIN
		x_LEGACYACCOM.MAP_FormInstanceID mfi on itm.IEPRefID = mfi.ItemRefID and sd.id = mfi.SectionDefID 
	-- WHERE NOT (sec.FormtemplateID is null and sec.HeaderFormTemplateID is null)
	) 
select 
	FormTemplate = fft.Name, HeaderFormTemplate = hft.Name,
	c.* 
from CTE_Formlets c 
left join dbo.FormTemplate fft on c.FormTemplateID = fft.Id 
left join dbo.FormTemplate hft on c.HeaderFormTemplateID = hft.Id 

GO


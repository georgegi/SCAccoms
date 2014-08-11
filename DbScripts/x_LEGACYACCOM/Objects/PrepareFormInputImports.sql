
declare @importPrgSections table (Enabled bit not null, SectionDefName varchar(100) not null, SectionDefID uniqueidentifier not null)
insert @importPrgSections values (1,'IEP Assessments','A0C84AE0-4F46-4DA5-9F90-D57AB212ED64')
insert @importPrgSections values (1,'Accommodations & Modifications','4C01FA56-D3F6-47B1-BCDF-EBE7AB08A57C')

insert LEGACYSPED.ImportPrgSections
select * from @importPrgSections where SectionDefID not in (select SectionDefID from LEGACYSPED.ImportPrgSections)
go


if object_id('x_LEGACYACCOM.ImportPrgSectionsFormTemplates', 'V') is not null
DROP VIEW x_LEGACYACCOM.ImportPrgSectionsFormTemplates
GO

create view x_LEGACYACCOM.ImportPrgSectionsFormTemplates
as
select Item = 'IEP', ips.Enabled, sdf.Sequence, ips.SectionDefID, sdf.FormTemplateID, sdf.HeaderFormTemplateID, SectionType = stf.Name
from LEGACYSPED.ImportPrgSections ips 
left join dbo.PrgSectionDef sdf on ips.SectionDefID = sdf.ID
left join dbo.PrgSectionType stf on sdf.TypeID = stf.ID
Go

if object_id('x_LEGACYACCOM.MAP_FormInputValueID') is not null
drop table x_LEGACYACCOM.MAP_FormInputValueID
go

CREATE TABLE [x_LEGACYACCOM].[MAP_FormInputValueID](
	[Item] [varchar](10) NOT NULL,
	[IntervalID] [uniqueidentifier] NOT NULL,
	[InputFieldID] [uniqueidentifier] NOT NULL,
	[DestID] [uniqueidentifier] NOT NULL,
	[Sequence] [int] NOT NULL,
 CONSTRAINT [PK_MAP_FormInputValueID] PRIMARY KEY CLUSTERED 
(
	[IntervalID] ASC,
	[InputFieldID] ASC,
	[Sequence] ASC
)
)

if object_id('x_LEGACYACCOM.MAP_FormInstanceID') is not null
drop table x_LEGACYACCOM.MAP_FormInstanceID
go

CREATE TABLE [x_LEGACYACCOM].[MAP_FormInstanceID](
	[Item] [varchar](10) NOT NULL,
	[ItemRefID] [int] NOT NULL,
	[SectionDefID] [uniqueidentifier] NOT NULL,
	[FormInstanceID] [uniqueidentifier] NULL,
	[HeaderFormInstanceID] [uniqueidentifier] NULL,
	[FormInstanceIntervalID] [uniqueidentifier] NULL,
	[HeaderFormInstanceIntervalID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_MAP_FormInstanceID] PRIMARY KEY CLUSTERED 
(
	[Item] ASC,
	[ItemRefID] ASC,
	[SectionDefID] ASC
)
) ON [PRIMARY]

GO

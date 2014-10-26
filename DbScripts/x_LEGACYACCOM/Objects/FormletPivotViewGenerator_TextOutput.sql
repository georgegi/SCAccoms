
if object_id('x_DATATEAM.FormletPivotViewGenerator_TextOutput') is not null
drop proc x_DATATEAM.FormletPivotViewGenerator_TextOutput
go

create proc x_DATATEAM.FormletPivotViewGenerator_TextOutput
	@Item			varchar(10) = NULL, -- For CO Crosswalk, appropriate values are BIP, Eval and IEP
	@StagingParent	varchar(100) = NULL, -- This is name of a previously-created table or view with 1:1 values
	@StagingChild	varchar(100) = NULL, -- This is name of a previously-created table or view with 1:M values
	@FormTemplate	varchar(100) = NULL, -- This is the Form Template name
	@ViewName		varchar(100) = NULL -- Name stub of the view to be generated with this query (prefix, datatype and "Pivot" will be added to the name)
as

if @Item is null
begin
print '

Parameters:
	@Item			varchar(10), -- IEP
	@StagingParent	varchar(100), -- This is name of a previously-created table or view with 1:1 values
	@StagingChild	varchar(100), -- This is name of a previously-created table or view with 1:M values
	@FormTemplate	varchar(100), -- This is the Form Template name
	@ViewName		varchar(100)  -- Name stub of the view to be generated with this query (prefix, datatype and "Pivot" will be added to the name)

Purpose:
	This stored procedure generates most of the code required create a pivot view that transposes the values in a horizontal presentation of data to be imported into the formlet model, which requires the data to be presented vertically
	Code was written specifically with the Encore crosswalk in mind and may be modified for other uses.

INSTRUCTIONS FOR USE:
	1. Use Ctrl-T in SSMS to output as text
	2. Execute the stored procedure with the required parameters 
	3. Copy the text output to a new SSMS window and save with an appropriate name. 
	4. Remove the last "UNION ALL" from all of the pivot queries
	5. Use Intellisense to change "ColumnNameFromLegacyData" to the appropriate database column
		Hint: The pivot view coolumns are presented in the same order that the values appear in the formlet


'
end
else 
begin

set nocount on;

declare @s table (
Item			varchar(10) not null,
StagingParent	varchar(100) not null,
StagingChild	varchar(100) not null,
FormTemplate	varchar(100) not null
)


declare @q1 varchar(max), @q1text varchar(max), @q1flag varchar(max), @q1date varchar(max), @q1sing varchar(max), @q2 varchar(max), @newline varchar(5) ; -- set @ViewName = 'ServiceDelivery'
set @newline = '
'
select @q1 = 'if object_id(''x_LEGACYACCOM.'+@ViewName+'DATATYPEPivot'', ''V'') is not null
DROP VIEW x_LEGACYACCOM.'+@ViewName+'DATATYPEPivot
GO

create view x_LEGACYACCOM.'+@ViewName+'DATATYPEPivot
as
select u.IEPRefID, u.SubRefID, u.Value, u.Sequence, u.InputFieldID, InputItemType =  iit.Name, InputItemTypeID = iit.ID 
from ('+@newline+@newline,
@q2 = '	) u join
FormTemplateInputItem ftii on u.InputFieldID = ftii.Id join 
FormTemplateInputItemType iit on ftii.TypeId = iit.Id
go
'

set @q1text = replace(@q1, 'DATATYPE', 'Texts')
set @q1flag = replace(@q1, 'DATATYPE', 'Flags')
set @q1date = replace(@q1, 'DATATYPE', 'Dates')
set @q1sing = replace(@q1, 'DATATYPE', 'SingleSelect') 

		-- NOTE: if the exact Form Template name is known, use that as the FormTemplate value (insert below)

insert @s values (@Item, @StagingParent, @StagingChild, @FormTemplate)

print @q1flag
select Stmt = '	select IepRefID, SubRefID = '+ case when ii.ControlIsRepeatable = 0 then 'cast(-99 as int)' else ' x.SubRefID' end +', Value = x.ColumnNameFromLegacyData, InputFieldID = '''+convert(varchar(36), ii.InputFieldID)+''', Sequence = '+ case when ii.ControlIsRepeatable = 0 then ' cast(0 as int) ' else ' x.Sequence ' end +' -- '+case when ii.ControlIsRepeatable = 1 then '(1:M)  ' else '' end +ii.InputItemCode+' - '+ii.InputItemLabel+'
	from '+case when ii.ControlIsRepeatable = 0 then s.StagingParent else s.StagingChild end +' x
	UNION ALL'
from x_DATATEAM.FormInputFields ii
join @s s on ii.TemplateName like s.FormTemplate
and ii.InputItemType = 'Flag'
order by ii.ControlLevel, ii.InputItemSequence

print @q2
print @newline+@newline

print @q1date
select Stmt = '	select IepRefID, SubRefID = '+ case when ii.ControlIsRepeatable = 0 then 'cast(-99 as int)' else ' x.SubRefID' end +', Value = x.ColumnNameFromLegacyData, InputFieldID = '''+convert(varchar(36), ii.InputFieldID)+''', Sequence = '+ case when ii.ControlIsRepeatable = 0 then ' cast(0 as int) ' else ' x.Sequence ' end +' -- '+case when ii.ControlIsRepeatable = 1 then '(1:M)  ' else '' end +ii.InputItemCode+' - '+ii.InputItemLabel+'
	from '+case when ii.ControlIsRepeatable = 0 then s.StagingParent else s.StagingChild end +' x
	UNION ALL'
from x_DATATEAM.FormInputFields ii
join @s s on ii.TemplateName like s.FormTemplate
and ii.InputItemType = 'Date'
order by ii.ControlLevel, ii.InputItemSequence

print @q2
print @newline+@newline

print @q1text
select Stmt = '	select IepRefID, SubRefID = '+ case when ii.ControlIsRepeatable = 0 then 'cast(-99 as int)' else ' x.SubRefID' end +', Value = x.ColumnNameFromLegacyData, InputFieldID = '''+convert(varchar(36), ii.InputFieldID)+''', Sequence = '+ case when ii.ControlIsRepeatable = 0 then ' cast(0 as int) ' else ' x.Sequence ' end +' -- '+case when ii.ControlIsRepeatable = 1 then '(1:M)  ' else '' end +ii.InputItemCode+' - '+ii.InputItemLabel+'
	from '+case when ii.ControlIsRepeatable = 0 then s.StagingParent else s.StagingChild end +' x
	UNION ALL'
from x_DATATEAM.FormInputFields ii
join @s s on ii.TemplateName like s.FormTemplate
and InputItemType = 'Text'
order by ii.ControlLevel, ii.InputItemSequence

print @q2
print @newline+@newline

print @q1sing
select Stmt = '	select IepRefID, SubRefID = '+ case when ii.ControlIsRepeatable = 0 then 'cast(-99 as int)' else ' x.SubRefID' end +', Value = x.ColumnNameFromLegacyData, InputFieldID = '''+convert(varchar(36), ii.InputFieldID)+''', Sequence = '+ case when ii.ControlIsRepeatable = 0 then ' cast(0 as int) ' else ' x.Sequence ' end +' -- '+case when ii.ControlIsRepeatable = 1 then '(1:M)  ' else '' end +ii.InputItemCode+' - '+ii.InputItemLabel+'
	from '+case when ii.ControlIsRepeatable = 0 then s.StagingParent else s.StagingChild end +' x
	UNION ALL'
from x_DATATEAM.FormInputFields ii
join @s s on ii.TemplateName like s.FormTemplate
and InputItemType = 'SingleSelect'
order by ii.ControlLevel, ii.InputItemSequence


print @q2
end
go


/*

select * from x_DATATEAM.FormInputFields where inputitemtype like 'SingleSelect' and TemplateName = 'Assessments'





*/

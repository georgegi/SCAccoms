
if object_id('x_LEGACYACCOM.Transform_FormInputValue', 'V') is not null
DROP VIEW x_LEGACYACCOM.Transform_FormInputValue
GO

create view x_LEGACYACCOM.Transform_FormInputValue
as
--select v.Item, v.IEPRefID, v.SubRefID, v.DestID, v.IntervalID, InputFieldID = v.InputFieldID, v.Sequence, v.InputItemCode, v.InputItemLabel, v.InputItemType, Value = convert(varchar, v.Value, 101)
--from x_LEGACYACCOM.Transform_FormInputDateValue v
--union all
select v.Item, v.IEPRefID, v.SubRefID, v.DestID, v.IntervalID, InputFieldID = v.InputFieldID, v.Sequence, v.InputItemCode, v.InputItemLabel, v.InputItemType, Value = convert(varchar(max), v.Value)
from x_LEGACYACCOM.Transform_FormInputTextValue v
union all
--select v.Item, v.IEPRefID, v.SubRefID, v.DestID, v.IntervalID, InputFieldID = v.InputFieldID, v.Sequence, v.InputItemCode, v.InputItemLabel, v.InputItemType, Value = convert(varchar(max), v.Value)
--from x_LEGACYACCOM.Transform_FormInputFlagValue v
--union all
select v.Item, v.IEPRefID, v.SubRefID, v.DestID, v.IntervalID, InputFieldID = v.InputFieldID, v.Sequence, v.InputItemCode, v.InputItemLabel, v.InputItemType, Value = convert(varchar(max), v.Value)
from x_LEGACYACCOM.Transform_FormInputSingleSelectValue v
go

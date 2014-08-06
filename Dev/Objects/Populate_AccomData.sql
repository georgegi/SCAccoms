IF EXISTS (SELECT 1 FROM sys.schemas s JOIN sys.objects o on s.schema_id = o.schema_id WHERE s.name = 'x_LEGACYACCOM' AND o.name = 'Populate_AccomData')
DROP PROC x_LEGACYACCOM.Populate_AccomData
GO

CREATE PROC x_LEGACYACCOM.Populate_AccomData
AS
BEGIN
/*
To Populate the source data in Enrich database from the EO database
*/
DECLARE @etlRoot varchar(255), @VpnConnectFile varchar(255), @VpnDisconnectFile varchar(255), @PopulateDCSpeedObj varchar(255), @q varchar(8000),@district varchar(50), @vpnYN char(1),@locfolder varchar(250) ; 

DECLARE @ro varchar(100), @et varchar(100), @deleteq NVARCHAR(max), @insertqiep NVARCHAR(max),@insertqph NVARCHAR(max), @insertqco NVARCHAR(max), @LinkedserverAddress VARCHAR(100), @DatabaseOwner VARCHAR(100), @DatabaseName VARCHAR(100), @newline varchar(5) ; set @newline = '
'

SELECT @LinkedserverAddress = LinkedServer, @DatabaseOwner = DatabaseOwner, @DatabaseName = DatabaseName -- SELECT *
FROM VC3ETL.ExtractDatabase 
WHERE ID = '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16'

SELECT @etlRoot = ParamValue FROM x_DATAVALIDATION.ParamValues WHERE ParamName='etlRoot'
SELECT @VpnConnectFile = ParamValue FROM x_DATAVALIDATION.ParamValues WHERE ParamName='VpnConnectFile'
SELECT @VpnDisconnectFile = ParamValue FROM x_DATAVALIDATION.ParamValues WHERE ParamName='VpnDisconnectFile'
SELECT @PopulateDCSpeedObj = ParamValue FROM x_DATAVALIDATION.ParamValues WHERE ParamName='populateDVSpeedObj'
SELECT @district = ParamValue FROM x_DATAVALIDATION.ParamValues WHERE ParamName='district'
SELECT @vpnYN = ParamValue FROM x_DATAVALIDATION.ParamValues WHERE ParamName='vpnYN'
SELECT @locfolder = ParamValue FROM x_DATAVALIDATION.ParamValues WHERE ParamName='locfolder'

SET @q = 'cd '+@etlRoot
SET @VpnConnectFile = '"'+@VpnConnectFile+'"';
SET @PopulateDCSpeedObj = '"'+@PopulateDCSpeedObj+'"';
SET @PopulateDCSpeedObj = @PopulateDCSpeedObj+' '+@locfolder;

PRINT @district
PRINT @q
PRINT @VpnConnectFile
PRINT @PopulateDCSpeedObj
PRINT @VpnDisconnectFile


--SELECT * FROM x_DATAVALIDATION.ParamValues 


IF (@vpnYN = 'Y')
BEGIN
EXEC master..xp_CMDShell @q
EXECUTE AS LOGIN = 'cmdshelluser'
EXEC master..xp_CMDShell @VpnConnectFile
REVERT
END

SET @deleteq = 'DELETE x_LEGACYACCOM.EO_IEPAccomModTbl_RAW'

SET @insertqiep = 'INSERT x_LEGACYACCOM.EO_IEPAccomModTbl_RAW (DocumentRefID,DocumentType,DocumentDate,StudentRefID,StudentLocalID,MimeType,Content)
select a.*
from '+isnull(@LinkedserverAddress,'linkservhere')+'.'+isnull(@DatabaseName,'dbnamehere')+'.dbo.SpecialEdStudentsAndIEPs x
join '+isnull(@LinkedserverAddress,'linkservhere')+'.'+isnull(@DatabaseName,'dbnamehere')+'.[dbo].IEPAccomModTbl a on x.GStudentID = a.GStudentID  
where isnull(a.del_flag,0)=0'

SET @deleteq = 'DELETE x_LEGACYACCOM.EO_IEPAccomModTbl_SC_RAW'
 
SET @insertqph = 'INSERT x_LEGACYACCOM.EO_IEPAccomModTbl_SC_RAW (DocumentRefID,DocumentType,DocumentDate,StudentRefID,StudentLocalID,MimeType,Content) 
select a2.*
from '+isnull(@LinkedserverAddress,'linkservhere')+'.'+isnull(@DatabaseName,'dbnamehere')+'.dbo.SpecialEdStudentsAndIEPs x
join '+isnull(@LinkedserverAddress,'linkservhere')+'.'+isnull(@DatabaseName,'dbnamehere')+'.[dbo].IEPAccomModTbl a on x.GStudentID = a.GStudentID
join '+isnull(@LinkedserverAddress,'linkservhere')+'.'+isnull(@DatabaseName,'dbnamehere')+'.[dbo].IEPAccomModTbl_SC a2 on a.IEPAccomSeq = a2.IEPAccomSeq 
where isnull(a.del_flag,0)=0 and isnull(a2.del_flag,0)=0'
 
SET @deleteq = 'DELETE x_LEGACYACCOM.EO_IEPAccomModListTbl_SC_RAW'

SET @insertqco = 'INSERT x_LEGACYACCOM.EO_IEPAccomModListTbl_SC_RAW (DocumentRefID,DocumentType,DocumentDate,StudentRefID,StudentLocalID,MimeType,Content) 
select aa.*
from '+isnull(@LinkedserverAddress,'linkservhere')+'.'+isnull(@DatabaseName,'dbnamehere')+'.dbo.SpecialEdStudentsAndIEPs x
join '+isnull(@LinkedserverAddress,'linkservhere')+'.'+isnull(@DatabaseName,'dbnamehere')+'.[dbo].IEPAccomModTbl a on x.GStudentID = a.GStudentID
join '+isnull(@LinkedserverAddress,'linkservhere')+'.'+isnull(@DatabaseName,'dbnamehere')+'.[dbo].IEPAccomModTbl_SC a2 on a.IEPAccomSeq = a2.IEPAccomSeq 
join '+isnull(@LinkedserverAddress,'linkservhere')+'.'+isnull(@DatabaseName,'dbnamehere')+'.[dbo].IEPAccomModListTbl_SC aa on a.IEPAccomSeq = aa.IEPAccomSeq 
where isnull(a.del_flag,0)=0 and isnull(a2.del_flag,0)=0 and isnull(aa.del_flag,0)=0'
 
 
 
 EXEC (@deleteq)
 EXEC (@insertqiep)
 EXEC (@insertqph)
 EXEC (@insertqco)
 
 
END
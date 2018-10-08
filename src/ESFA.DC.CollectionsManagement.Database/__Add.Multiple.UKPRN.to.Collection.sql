


SET NOCOUNT ON;
DECLARE @CollectionName VARCHAR(250) ='ILR1819'  -- SELECT [Name] FROM [dbo].[Collection]

DECLARE @Providers TABLE (UKPRN BIGINT PRIMARY KEY ,OrgName VARCHAR(250),OrgEmail VARCHAR(250))

INSERT INTO @Providers( [UKPRN],[OrgName],[OrgEmail])
SELECT DISTINCT [UKPRN],[OrgName],[OrgEmail]
FROM
(
-------------------------------------------------------- PUT DATA - START-------------------------------------------------------- 
	  SELECT 1 AS UKPRN, '' AS OrgName, '' as OrgEmail
UNION SELECT 2 AS UKPRN, '' AS OrgName, '' as OrgEmail
-------------------------------------------------------- PUT DATA - END  -------------------------------------------------------- 
) as NewRecords

DECLARE @UKPRN BIGINT ,@OrgName VARCHAR(250),@OrgEmail VARCHAR(250)

DECLARE Providers_Cursor CURSOR READ_ONLY FOR SELECT * FROM @Providers 

OPEN Providers_Cursor;  
FETCH NEXT FROM Providers_Cursor INTO @UKPRN,@OrgName,@OrgEmail;  
WHILE @@FETCH_STATUS = 0  
   BEGIN  
	SELECT  @UKPRN as UKPRN ,@OrgName as OrgName,@OrgEmail as OrgEmail

	--EXEC [dbo].[usp_Add_UKPRN_to_Collection]
	--		@CollectionName = @CollectionName
	--	   ,@UKPRN = @UKPRN
	--	   ,@OrgName = @OrgName
	--	   ,@OrgEmail = @OrgEmail

      FETCH NEXT FROM Providers_Cursor INTO @UKPRN,@OrgName,@OrgEmail;  
   END;  
CLOSE Providers_Cursor;  
DEALLOCATE Providers_Cursor;  
GO  
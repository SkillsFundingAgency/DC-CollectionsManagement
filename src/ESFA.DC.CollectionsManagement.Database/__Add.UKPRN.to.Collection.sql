

DECLARE @CollectionName VARCHAR(250) ='<CollectioName, VARCAHR(250),ILR1819>'   -- SELECT [Name] FROM [dbo].[Collection]

DECLARE @UKPRN BIGINT = <UKPR, VARCAHR(250),999999999>
DECLARE @OrgName VARCHAR(250) ='<OrgName, VARCAHR(250),Test OrgName>'
DECLARE @OrgEmail VARCHAR(250) ='<OrgEmail, VARCAHR(250),a.a@a.a>'

SET NOCOUNT ON;

IF NOT EXISTS (SELECT * FROM [dbo].[Organisation]  WHERE [Ukprn] = @UKPRN)
BEGIN
	DECLARE @OrgId INT = (SELECT ISNULL(MAX([OrganisationId]),0)+1 FROM [dbo].[Organisation])

	INSERT [dbo].[Organisation] ([OrganisationId], [OrgId], [Ukprn], [Name], [Email])
	VALUES (@OrgId, 'SomeCrap', @UKPRN, @OrgName, @OrgEmail);
	RAISERROR('Added UKPRN : %I64d | Org : %s',10,1,@UKPRN,@OrgName ) WITH NOWAIT;
END


IF NOT EXISTS (
				SELECT 
					   O.[Ukprn] as UKPRN
					  ,C.[CollectionId] as CollectionId
					  ,C.[Name] as CollectionName
					  ,C.[IsOpen] as IsOpen
				FROM [dbo].[Organisation] O
				INNER JOIN [dbo].[OrganisationCollection] OC
					ON OC.[OrganisationId] = O.[OrganisationId]
				INNER JOIN [dbo].[Collection] C
					ON C.[CollectionId] = OC.[CollectionId]
				WHERE O.[Ukprn] = @UKPRN
				  AND C.[Name] = @CollectionName
)
BEGIN
	DECLARE @OrganisationId INT = (SELECT [OrganisationId] FROM [dbo].[Organisation] WHERE [Ukprn] = @UKPRN)
	DECLARE @CollectionId INT = (SELECT [CollectionId] FROM [dbo].[Collection] WHERE [Name] = @CollectionName)

	IF ((@OrganisationId IS NULL )OR(@CollectionId IS NULL)) 
	  BEGIN
		RAISERROR('Error Getting Org or Collection IDs',17,1) WITH NOWAIT;
	  END
	ELSE
	  BEGIN
	    INSERT [dbo].[OrganisationCollection] ([OrganisationId], [CollectionId]) 
	    SELECT @OrganisationId, @CollectionId
		RAISERROR('Added Collection : %s to UKPRN : %I64d - %s',10,1,@CollectionName,@UKPRN,@OrgName ) WITH NOWAIT;
	  END
END

SELECT * FROM [dbo].[vw_CurrentCollectionReturnPeriods] WHERE UKPRN = @UKPRN
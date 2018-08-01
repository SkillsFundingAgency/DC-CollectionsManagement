

DECLARE @SummaryOfChanges_Collection TABLE ([EventId] INT, [Action] VARCHAR(100));

MERGE INTO [dbo].[JobStatusType] AS Target
USING (VALUES
	(1, N'ILR1718', 1, 1),
	(2, N'EAS', 1, 2),
	(3, N'ESF', 1, 3)
	  )
	AS Source([CollectionId], [Name], [IsOpen], [CollectionTypeId])
	ON Target.[CollectionId] = Source.[CollectionId]
	WHEN MATCHED 
			AND EXISTS 
				(		SELECT Target.[Name]
							  ,Target.[IsOpen]
							  ,Target.[CollectionTypeId]
					EXCEPT 
						SELECT Source.[Name]
						      ,Source.[IsOpen]
						      ,Source.[CollectionTypeId]
				)
		  THEN UPDATE SET Target.[Name] = Source.[Name],
			              Target.[IsOpen] = Source.[IsOpen],
			              Target.[CollectionTypeId] = Source.[CollectionTypeId]
	WHEN NOT MATCHED BY TARGET THEN INSERT([CollectionId], [IsOpen], [Name], [CollectionTypeId]) 
								   VALUES ([CollectionId], [IsOpen], [Name], [CollectionTypeId])
	WHEN NOT MATCHED BY SOURCE THEN DELETE
	OUTPUT Inserted.[CollectionId],$action INTO @SummaryOfChanges_Collection([EventId],[Action])
;

	DECLARE @AddCount_JST INT, @UpdateCount_JST INT, @DeleteCount_JST INT
	SET @AddCount_JST  = ISNULL((SELECT Count(*) FROM @SummaryOfChanges_Collection WHERE [Action] = 'Insert' GROUP BY Action),0);
	SET @UpdateCount_JST = ISNULL((SELECT Count(*) FROM @SummaryOfChanges_Collection WHERE [Action] = 'Update' GROUP BY Action),0);
	SET @DeleteCount_JST = ISNULL((SELECT Count(*) FROM @SummaryOfChanges_Collection WHERE [Action] = 'Delete' GROUP BY Action),0);

	RAISERROR('		      %s - Added %i - Update %i - Delete %i',10,1,'JobStatusType', @AddCount_JST, @UpdateCount_JST, @DeleteCount_JST) WITH NOWAIT;


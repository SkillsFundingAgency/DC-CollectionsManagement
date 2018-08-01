

DECLARE @SummaryOfChanges_CollectionType TABLE ([EventId] INT, [Action] VARCHAR(100));

MERGE INTO [dbo].[CollectionType] AS Target
USING (VALUES
		(1, N'ILR', N'ILR Submission'),
		(2, N'EAS', N'EAS Submission'),
		(3, N'ESF', N'ESF Supp Data Submission')
	  )
	AS Source([CollectionTypeId], [Type], [Description])
	ON Target.[CollectionTypeId] = Source.[CollectionTypeId]
	WHEN MATCHED 
			AND EXISTS 
				(		SELECT Target.[Description]
							  ,Target.[Type]
					EXCEPT 
						SELECT Source.[Description]
						      ,Source.[Type]
				)
		  THEN UPDATE SET Target.[Description] = Source.[Description],
			              Target.[Type] = Source.[Type]
	WHEN NOT MATCHED BY TARGET THEN INSERT([CollectionTypeId], [Type], [Description]) 
								   VALUES ([CollectionTypeId], [Type], [Description])
	WHEN NOT MATCHED BY SOURCE THEN DELETE
	OUTPUT Inserted.[CollectionTypeId],$action INTO @SummaryOfChanges_CollectionType([EventId],[Action])
;

	DECLARE @AddCount_JST INT, @UpdateCount_JST INT, @DeleteCount_JST INT
	SET @AddCount_JST  = ISNULL((SELECT Count(*) FROM @SummaryOfChanges_CollectionType WHERE [Action] = 'Insert' GROUP BY Action),0);
	SET @UpdateCount_JST = ISNULL((SELECT Count(*) FROM @SummaryOfChanges_CollectionType WHERE [Action] = 'Update' GROUP BY Action),0);
	SET @DeleteCount_JST = ISNULL((SELECT Count(*) FROM @SummaryOfChanges_CollectionType WHERE [Action] = 'Delete' GROUP BY Action),0);

	RAISERROR('		      %s - Added %i - Update %i - Delete %i',10,1,'CollectionType', @AddCount_JST, @UpdateCount_JST, @DeleteCount_JST) WITH NOWAIT;


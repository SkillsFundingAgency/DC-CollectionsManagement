
BEGIN
	DECLARE @SummaryOfChanges_ReturnPeriod TABLE ([ReturnPeriodId] INT, [Action] VARCHAR(100));

	MERGE INTO [dbo].[ReturnPeriod] AS Target
	USING (
			SELECT NewRecords.[ReturnPeriodId], NewRecords.[StartDateTimeUTC], NewRecords.[EndDateTimeUTC], NewRecords.[PeriodNumber], C.[CollectionId], NewRecords.[CalendarMonth], NewRecords.[CalendarYear]
			FROM 
			( 		       SELECT  1 AS [ReturnPeriodId], CAST(N'2018-07-22T00:00:00.000' AS DateTime) AS [StartDateTimeUTC], CAST(N'2018-08-05T00:00:00.000' AS DateTime) as [EndDateTimeUTC],  7 as PeriodNumber, 'ILR1819' AS [CollectionName],  7 AS [CalendarMonth], 2018 as [CalendarYear]
					 UNION SELECT  2 AS [ReturnPeriodId], CAST(N'2018-08-22T00:00:00.000' AS DateTime) AS [StartDateTimeUTC], CAST(N'2018-09-05T00:00:00.000' AS DateTime) as [EndDateTimeUTC],  8 as PeriodNumber, 'ILR1819' AS [CollectionName],  8 AS [CalendarMonth], 2018 as [CalendarYear]
					 UNION SELECT  3 AS [ReturnPeriodId], CAST(N'2018-09-22T00:00:00.000' AS DateTime) AS [StartDateTimeUTC], CAST(N'2018-10-05T00:00:00.000' AS DateTime) as [EndDateTimeUTC],  9 as PeriodNumber, 'ILR1819' AS [CollectionName],  9 AS [CalendarMonth], 2018 as [CalendarYear]
					 UNION SELECT  4 AS [ReturnPeriodId], CAST(N'2018-10-22T00:00:00.000' AS DateTime) AS [StartDateTimeUTC], CAST(N'2018-11-05T00:00:00.000' AS DateTime) as [EndDateTimeUTC], 10 as PeriodNumber, 'ILR1819' AS [CollectionName], 10 AS [CalendarMonth], 2018 as [CalendarYear]
					 UNION SELECT  5 AS [ReturnPeriodId], CAST(N'2018-11-22T00:00:00.000' AS DateTime) AS [StartDateTimeUTC], CAST(N'2018-12-05T00:00:00.000' AS DateTime) as [EndDateTimeUTC], 11 as PeriodNumber, 'ILR1819' AS [CollectionName], 11 AS [CalendarMonth], 2018 as [CalendarYear]
					 UNION SELECT  6 AS [ReturnPeriodId], CAST(N'2018-12-22T00:00:00.000' AS DateTime) AS [StartDateTimeUTC], CAST(N'2018-01-05T00:00:00.000' AS DateTime) as [EndDateTimeUTC], 12 as PeriodNumber, 'ILR1819' AS [CollectionName], 12 AS [CalendarMonth], 2018 as [CalendarYear]
					 UNION SELECT  7 AS [ReturnPeriodId], CAST(N'2019-01-22T00:00:00.000' AS DateTime) AS [StartDateTimeUTC], CAST(N'2019-02-05T00:00:00.000' AS DateTime) as [EndDateTimeUTC],  1 as PeriodNumber, 'ILR1819' AS [CollectionName],  1 AS [CalendarMonth], 2019 as [CalendarYear]
					 UNION SELECT  8 AS [ReturnPeriodId], CAST(N'2019-02-22T00:00:00.000' AS DateTime) AS [StartDateTimeUTC], CAST(N'2019-03-05T00:00:00.000' AS DateTime) as [EndDateTimeUTC],  2 as PeriodNumber, 'ILR1819' AS [CollectionName],  2 AS [CalendarMonth], 2019 as [CalendarYear]
					 UNION SELECT  9 AS [ReturnPeriodId], CAST(N'2019-03-22T00:00:00.000' AS DateTime) AS [StartDateTimeUTC], CAST(N'2019-04-05T00:00:00.000' AS DateTime) as [EndDateTimeUTC],  3 as PeriodNumber, 'ILR1819' AS [CollectionName],  3 AS [CalendarMonth], 2019 as [CalendarYear]
					 UNION SELECT 10 AS [ReturnPeriodId], CAST(N'2019-04-22T00:00:00.000' AS DateTime) AS [StartDateTimeUTC], CAST(N'2019-05-05T00:00:00.000' AS DateTime) as [EndDateTimeUTC],  4 as PeriodNumber, 'ILR1819' AS [CollectionName],  4 AS [CalendarMonth], 2019 as [CalendarYear]
					 UNION SELECT 11 AS [ReturnPeriodId], CAST(N'2019-05-22T00:00:00.000' AS DateTime) AS [StartDateTimeUTC], CAST(N'2019-06-05T00:00:00.000' AS DateTime) as [EndDateTimeUTC],  5 as PeriodNumber, 'ILR1819' AS [CollectionName],  5 AS [CalendarMonth], 2019 as [CalendarYear]
					 UNION SELECT 12 AS [ReturnPeriodId], CAST(N'2019-06-22T00:00:00.000' AS DateTime) AS [StartDateTimeUTC], CAST(N'2019-07-05T00:00:00.000' AS DateTime) as [EndDateTimeUTC],  6 as PeriodNumber, 'ILR1819' AS [CollectionName],  6 AS [CalendarMonth], 2019 as [CalendarYear]
					 UNION SELECT 13 AS [ReturnPeriodId], CAST(N'2019-07-22T00:00:00.000' AS DateTime) AS [StartDateTimeUTC], CAST(N'2019-08-05T00:00:00.000' AS DateTime) as [EndDateTimeUTC],  7 as PeriodNumber, 'ILR1819' AS [CollectionName],  6 AS [CalendarMonth], 2019 as [CalendarYear]
					 UNION SELECT 14 AS [ReturnPeriodId], CAST(N'2019-08-22T00:00:00.000' AS DateTime) AS [StartDateTimeUTC], CAST(N'2019-09-05T00:00:00.000' AS DateTime) as [EndDateTimeUTC],  8 as PeriodNumber, 'ILR1819' AS [CollectionName],  7 AS [CalendarMonth], 2019 as [CalendarYear]
			)
			AS NewRecords
			INNER JOIN [dbo].[Collection] C
				ON C.[Name] = NewRecords.[CollectionName]
		  )
		AS Source([ReturnPeriodId], [StartDateTimeUTC], [EndDateTimeUTC], [PeriodNumber], [CollectionId], [CalendarMonth], [CalendarYear])
		ON Target.[ReturnPeriodId] = Source.[ReturnPeriodId]
		WHEN MATCHED 
				AND EXISTS 
					(		SELECT Target.[StartDateTimeUTC]
								  ,Target.[EndDateTimeUTC]
								  ,Target.[PeriodNumber]
								  ,Target.[CollectionId]
								  ,Target.[CalendarMonth]
								  ,Target.[CalendarYear]
						EXCEPT 
							SELECT Source.[StartDateTimeUTC]
								  ,Source.[EndDateTimeUTC]
								  ,Source.[PeriodNumber]
								  ,Source.[CollectionId]
								  ,Source.[CalendarMonth]
								  ,Source.[CalendarYear]
					)
			  THEN UPDATE SET Target.[StartDateTimeUTC] = Source.[StartDateTimeUTC],
							  Target.[EndDateTimeUTC] = Source.[EndDateTimeUTC],
							  Target.[PeriodNumber] = Source.[PeriodNumber],
							  Target.[CalendarMonth] = Source.[CalendarMonth],
							  Target.[CalendarYear] = Source.[CalendarYear]
		WHEN NOT MATCHED BY TARGET THEN INSERT([ReturnPeriodId], [StartDateTimeUTC], [EndDateTimeUTC], [PeriodNumber], [CollectionId], [CalendarMonth], [CalendarYear]) 
									   VALUES ([ReturnPeriodId], [StartDateTimeUTC], [EndDateTimeUTC], [PeriodNumber], [CollectionId], [CalendarMonth], [CalendarYear])
		WHEN NOT MATCHED BY SOURCE THEN DELETE
		OUTPUT Inserted.[ReturnPeriodId],$action INTO @SummaryOfChanges_ReturnPeriod([ReturnPeriodId],[Action])
	;

		DECLARE @AddCount_RT INT, @UpdateCount_RT INT, @DeleteCount_RT INT
		SET @AddCount_RT  = ISNULL((SELECT Count(*) FROM @SummaryOfChanges_ReturnPeriod WHERE [Action] = 'Insert' GROUP BY Action),0);
		SET @UpdateCount_RT = ISNULL((SELECT Count(*) FROM @SummaryOfChanges_ReturnPeriod WHERE [Action] = 'Update' GROUP BY Action),0);
		SET @DeleteCount_RT = ISNULL((SELECT Count(*) FROM @SummaryOfChanges_ReturnPeriod WHERE [Action] = 'Delete' GROUP BY Action),0);

		RAISERROR('		      %s - Added %i - Update %i - Delete %i',10,1,'ReturnPeriod', @AddCount_RT, @UpdateCount_RT, @DeleteCount_RT) WITH NOWAIT;

END










DECLARE @SummaryOfChanges_ReturnPeriod TABLE ([EventId] INT, [Action] VARCHAR(100));

MERGE INTO [dbo].[ReturnPeriod] AS Target
USING (VALUES
		( 1, CAST(N'2018-07-22T00:00:00.000' AS DateTime), CAST(N'2018-08-05T00:00:00.000' AS DateTime), 7, 1, 7, 2018),
        ( 2, CAST(N'2018-08-22T00:00:00.000' AS DateTime), CAST(N'2018-09-05T00:00:00.000' AS DateTime), 8, 1, 8, 2018),
        ( 3, CAST(N'2018-09-22T00:00:00.000' AS DateTime), CAST(N'2018-10-05T00:00:00.000' AS DateTime), 9, 1, 9, 2018),
        ( 4, CAST(N'2018-10-22T00:00:00.000' AS DateTime), CAST(N'2018-11-05T00:00:00.000' AS DateTime), 10, 1, 10, 2018),
        ( 5, CAST(N'2018-11-22T00:00:00.000' AS DateTime), CAST(N'2018-12-05T00:00:00.000' AS DateTime), 11, 1, 11, 2018),
        ( 6, CAST(N'2018-12-22T00:00:00.000' AS DateTime), CAST(N'2018-01-05T00:00:00.000' AS DateTime), 12, 1, 12, 2018),
        ( 7, CAST(N'2019-01-22T00:00:00.000' AS DateTime), CAST(N'2019-02-05T00:00:00.000' AS DateTime),  1, 1,  1, 2019),
        ( 8, CAST(N'2019-02-22T00:00:00.000' AS DateTime), CAST(N'2019-03-05T00:00:00.000' AS DateTime),  2, 1,  2, 2019),
        ( 9, CAST(N'2019-03-22T00:00:00.000' AS DateTime), CAST(N'2019-04-05T00:00:00.000' AS DateTime),  3, 1,  3, 2019),
        (10, CAST(N'2019-04-22T00:00:00.000' AS DateTime), CAST(N'2019-05-05T00:00:00.000' AS DateTime),  4, 1,  4, 2019),
        (11, CAST(N'2019-05-22T00:00:00.000' AS DateTime), CAST(N'2019-06-05T00:00:00.000' AS DateTime),  5, 1,  5, 2019),
        (12, CAST(N'2019-06-22T00:00:00.000' AS DateTime), CAST(N'2019-07-05T00:00:00.000' AS DateTime),  6, 1,  6, 2019),
        (13, CAST(N'2019-07-22T00:00:00.000' AS DateTime), CAST(N'2019-08-05T00:00:00.000' AS DateTime),  7, 1,  6, 2019),
        (14, CAST(N'2019-08-22T00:00:00.000' AS DateTime), CAST(N'2019-09-05T00:00:00.000' AS DateTime),  8, 1,  7, 2019)
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
	WHEN NOT MATCHED BY TARGET THEN INSERT([ReturnPeriodId], [StartDateTimeUTC], [EndDateTimeUTC], [PeriodNumber], [CalendarMonth], [CalendarYear]) 
								   VALUES ([ReturnPeriodId], [StartDateTimeUTC], [EndDateTimeUTC], [PeriodNumber], [CalendarMonth], [CalendarYear])
	WHEN NOT MATCHED BY SOURCE THEN DELETE
	OUTPUT Inserted.[ReturnPeriodId],$action INTO @SummaryOfChanges_ReturnPeriod([ReturnPeriodId],[Action])
;

	DECLARE @AddCount_JST INT, @UpdateCount_JST INT, @DeleteCount_JST INT
	SET @AddCount_JST  = ISNULL((SELECT Count(*) FROM @SummaryOfChanges_ReturnPeriod WHERE [Action] = 'Insert' GROUP BY Action),0);
	SET @UpdateCount_JST = ISNULL((SELECT Count(*) FROM @SummaryOfChanges_ReturnPeriod WHERE [Action] = 'Update' GROUP BY Action),0);
	SET @DeleteCount_JST = ISNULL((SELECT Count(*) FROM @SummaryOfChanges_ReturnPeriod WHERE [Action] = 'Delete' GROUP BY Action),0);

	RAISERROR('		      %s - Added %i - Update %i - Delete %i',10,1,'ReturnPeriod', @AddCount_JST, @UpdateCount_JST, @DeleteCount_JST) WITH NOWAIT;


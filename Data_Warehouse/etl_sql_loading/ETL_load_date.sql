USE warehouse
GO

Declare @StartDate date; 
Declare @EndDate date;
SELECT @StartDate = '2023-01-01', @EndDate = '2026-12-31';
Declare @DateInProcess datetime = @StartDate;
/*
IF OBJECT_ID('v_ETL_date') IS NOT NULL
    DROP VIEW v_ETL_date;
GO
CREATE VIEW v_ETL_date;
*/
While @DateInProcess <= @EndDate
	Begin
	--Add a row into the date dimension table for this date
		Insert Into [Date] 
		( [date]
		, [year]
		, [month]
		, [month_no]
		, [day_of_week]
		, [day_of_week_no]
		)
		Values ( 
		  @DateInProcess -- [Date]
		  , Cast( Year(@DateInProcess) as varchar(4)) -- [Year]
		  , Cast( DATENAME(month, @DateInProcess) as varchar(10)) -- [Month]
		  , Cast( Month(@DateInProcess) as int) -- [MonthNo]
		  , Cast( DATENAME(dw,@DateInProcess) as varchar(15)) -- [DayOfWeek]
		  , Cast( DATEPART(dw, @DateInProcess) as int) -- [DayOfWeekNo]
		);  
		-- Add a day and loop again
		Set @DateInProcess = DateAdd(d, 1, @DateInProcess);
	End
go

SELECT * FROM Date;
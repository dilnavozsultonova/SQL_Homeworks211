DECLARE @Year INT = 2025;
DECLARE @Month INT = 6; -- June

-- Generate a list of dates for the given month
WITH Dates (CalendarDate) AS (
    SELECT CAST(DATEFROMPARTS(@Year, @Month, 1) AS DATE)
    UNION ALL
    SELECT DATEADD(DAY, 1, CalendarDate)
    FROM Dates
    WHERE MONTH(DATEADD(DAY, 1, CalendarDate)) = @Month
),
-- Add week number and day name
LabeledDates AS (
    SELECT 
        CalendarDate,
        DATENAME(WEEKDAY, CalendarDate) AS WeekdayName,
        DATEDIFF(WEEK, DATEFROMPARTS(@Year, @Month, 1), CalendarDate) + 1 AS WeekOfMonth
),
-- Pivot the days into week rows
Pivoted AS (
    SELECT 
        WeekOfMonth,
        [Sunday]   = MAX(CASE WHEN DATENAME(WEEKDAY, CalendarDate) = 'Sunday' THEN CalendarDate END),
        [Monday]   = MAX(CASE WHEN DATENAME(WEEKDAY, CalendarDate) = 'Monday' THEN CalendarDate END),
        [Tuesday]  = MAX(CASE WHEN DATENAME(WEEKDAY, CalendarDate) = 'Tuesday' THEN CalendarDate END),
        [Wednesday]= MAX(CASE WHEN DATENAME(WEEKDAY, CalendarDate) = 'Wednesday' THEN CalendarDate END),
        [Thursday] = MAX(CASE WHEN DATENAME(WEEKDAY, CalendarDate) = 'Thursday' THEN CalendarDate END),
        [Friday]   = MAX(CASE WHEN DATENAME(WEEKDAY, CalendarDate) = 'Friday' THEN CalendarDate END),
        [Saturday] = MAX(CASE WHEN DATENAME(WEEKDAY, CalendarDate) = 'Saturday' THEN CalendarDate END)
    FROM LabeledDates
    GROUP BY WeekOfMonth
)

SELECT * FROM Pivoted
ORDER BY WeekOfMonth
OPTION (MAXRECURSION 1000);

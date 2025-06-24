declare @Year int=2025
declare @Month int=6

declare @date date='20250606'

declare @startdate date=datefromparts(year(@date),month(@date),1)  -- get the first day of month
declare @enddate   date=eomonth(@startdate)  -- get the last day of month

;with dates as(
  select @startdate as calendardate
  union all
  select dateadd(day,1,calendardate)
  from dates
  where calendardate<@enddate
),
weekgroups as (
  select calendardate,                 
    datepart(week, dateadd(day,-datepart(weekday, calendardate)+1,calendardate)) --2025-06-05  , -- 2025-06-01
    + datediff(month, 0, calendardate) as weekgroup,
    datename(weekday,calendardate) as dayname,
    datepart(weekday, calendardate) as dayofweek
  from dates
)
select  
    max(case when datepart(weekday,calendardate)=1 then calendardate else null end) as Sunday,
    max(case when datepart(weekday,calendardate)=2 then calendardate else null end) as Monday,
    max(case when datepart(weekday,calendardate)=3 then calendardate else null end) as Tuesday,
    max(case when datepart(weekday,calendardate)=4 then calendardate else null end) as Wednesday,
    max(case when datepart(weekday,calendardate)=5 then calendardate else null end) as Thursday,
    max(case when datepart(weekday,calendardate)=6 then calendardate else null end) as Friday,
    max(case when datepart(weekday,calendardate)=7 then calendardate else null end) as Saturday
from weekgroups
group by weekgroup
order by min(calendardate)
option (maxrecursion 1000);

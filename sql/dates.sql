select days(current date) - days('2021-07-03')
   from sysibm.sysdummy1;

select date(days(current date) + 1)
   from sysibm.sysdummy1;

select date(days(current date) - 1)
   from sysibm.sysdummy1;

select add_months(current date, 1) 
   from sysibm.sysdummy1;

select months_between(current date, '2021-06-01')
   from sysibm.sysdummy1;

select current date + 1 year from sysibm.sysdummy1;
select current date + 1 month from sysibm.sysdummy1;
select current date + 1 day from sysibm.sysdummy1;

select current date - 1 year from sysibm.sysdummy1;
select current date - 1 month from sysibm.sysdummy1;
select current date - 1 day from sysibm.sysdummy1;


select curdate() from sysibm.sysdummy1;
select curtime() from sysibm.sysdummy1;
select now() from sysibm.sysdummy1;  -- a timestamp based on a reading of the time-of-day clock 

select day(current date) from sysibm.sysdummy1;
select month(current date) from sysibm.sysdummy1;
select year(current date) from sysibm.sysdummy1;

select dayname(current date) from sysibm.sysdummy1;
select dayofmonth(current date) from sysibm.sysdummy1;  -- same as day function
select dayofweek(current date) from sysibm.sysdummy1; --  1 is Sunday and 7 is Saturday
select dayofweek_iso(current date) from sysibm.sysdummy1; --  1 is Monday and 7 is Sunday
select dayofyear(current date) from sysibm.sysdummy1;  -- returns an integer between 1 and 366 

select monthname(current date) from sysibm.sysdummy1;

select julian_day(current date) from sysibm.sysdummy1;
select last_day(current date) from sysibm.sysdummy1;  --a date or timestamp that represents the last day of the month
select next_day(current date, 'TUE') from sysibm.sysdummy1;  -- first tuesday after given date


select quarter(current date) from sysibm.sysdummy1;
select week(current date) from sysibm.sysdummy1;  -- an integer between 1 and 54 that represents the week of the year
select week_iso(current date) from sysibm.sysdummy1;  -- returns an integer between 1 and 53 that represents the week of the year
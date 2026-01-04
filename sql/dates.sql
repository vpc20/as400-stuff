-- convert value to date
select date('1988-12-25')
   from sysibm.sysdummy1;
   
select date('12/25/1988')
   from sysibm.sysdummy1;
   
select date('25.12.1988')
   from sysibm.sysdummy1;

select substr(char(19881225), 1, 4) || '-' || substr(char(19881225), 5, 2) ||
      '-' || substr(char(19881225), 7, 2)
   from sysibm.sysdummy1;

-- substring function also works with numbers
select substr(19881225, 1, 4) || '-' || substr(19881225, 5, 2) ||
      '-' || substr(19881225, 7, 2)
   from sysibm.sysdummy1;     

select left(19881225,4) || '-' || substr(char(19881225), 5, 2) ||
      '-' || right(19881225)
         from sysibm.sysdummy1;

-- date arithmetic   
select days(current date) - days(date('2023-08-01'))  -- diff in days
  from sysibm.sysdummy1;

select months_between(current date, '2021-06-01')  -- diff in months
   from sysibm.sysdummy1;

select year(current date - date('1943-05-23')) -- diff in years
from sysibm.sysdummy1;

select year(current date - date('2023-12-01')) -- diff in years
from sysibm.sysdummy1;

select current date + 1 year from sysibm.sysdummy1;   -- add 1 year
select current date + 1 month from sysibm.sysdummy1;  -- add 1 month (does not change day of month)
select current date + 1 day from sysibm.sysdummy1;    -- add 1 day

select ADD_MONTHS('2000-2-28', 1) from sysibm.sysdummy1; -- add 1 month (last day is returned if input is last day of month)
select ADD_MONTHS('2000-2-29', 1) from sysibm.sysdummy1; -- add 1 month but returns last day of month
select date('2000-2-29') + 1 month from sysibm.sysdummy1;  -- add 1 month (does not change day of month)


select current date - 1 year from sysibm.sysdummy1;     -- subtract 1 year
select current date - 1 month from sysibm.sysdummy1;    -- subtract 1 month
select current date - 1 day from sysibm.sysdummy1;      -- subtract 1 day

-- get system date/time
select curdate() from sysibm.sysdummy1;
select curtime() from sysibm.sysdummy1;
select now() from sysibm.sysdummy1;  -- a timestamp based on a reading of the time-of-day clock 

-- various date functions
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
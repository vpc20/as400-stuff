create or replace table vpcrzkh1.agthist (polnum integer not null, 
                                agtnum integer not null,
                                strdte integer not null);
                                
insert into  vpcrzkh1.agthist values(111, 777, 20220101);                          
insert into  vpcrzkh1.agthist values(111, 888, 20220201);                          
insert into  vpcrzkh1.agthist values(111, 999, 20220301);                          
insert into  vpcrzkh1.agthist values(222, 777, 20220401);                          
insert into  vpcrzkh1.agthist values(222, 888, 20220501);                          
insert into  vpcrzkh1.agthist values(222, 999, 20220601);     

select * from  vpcrzkh1.agthist;

create table vpcrzkh1.tmp1 as (
select polnum, agtnum, strdte,
   ROW_NUMBER() OVER (PARTITION BY polnum
                      ORDER BY polnum, strdte DESC) rn
from  vpcrzkh1.agthist) with data;

create table vpcrzkh1.tmp2 as (
select * from vpcrzkh1.tmp1
where rn in (1,2)) with data;

select * from vpcrzkh1.tmp2;

-- select polnum 
-- from vpcrzkh1.tmp2 a,
-- lateral( select agtnum 
--          from vpcrzkh1.tmp2 b
--          where a.polnum = b.polnum);
         
SELECT polnum,
       MAX(CASE WHEN rn = 1
           THEN agtnum END) AS agtcurr,
       MAX(CASE WHEN rn = 2
           THEN agtnum END) AS agtprev
FROM vpcrzkh1.tmp2
GROUP BY polnum



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

select polnum, agtnum, strdte,
   ROW_NUMBER() OVER (PARTITION BY polnum
                      ORDER BY transaction_time DESC) 
from  vpcrzkh1.agthist; 


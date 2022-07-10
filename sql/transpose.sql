
with empproj as (   
select empno, projno,
   ROW_NUMBER() OVER (PARTITION BY empno
                      ORDER BY empno, projno) rn
from empprojact) 
select empno,
       MAX(CASE WHEN rn = 1
           THEN projno END) AS proj1,
       MAX(CASE WHEN rn = 2
           THEN projno END) AS proj2
FROM empproj
GROUP BY empno;
   
        
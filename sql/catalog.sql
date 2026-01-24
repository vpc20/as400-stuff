SET current schema vpcrzkh1;

SELECT *
FROM qsys2.systables
WHERE table_schema = 'VPCRZKH1';

SELECT *
FROM qsys2.systables
WHERE table_owner = 'VPCRZKH';


-- output similar to dspfd command
select * from qsys2.sysfiles
where table_schema = 'VPCRZKH1';


-- field names
SELECT *
FROM qsys2.syscolumns
WHERE table_schema = 'VPCRZKH1'
  AND table_name = 'EMPLOYEE';


-- key fields
SELECT *
  FROM qsys.qadbkatr
  WHERE dbkfil = 'MSGPF'
        AND dbklib = 'VPCRZKH1';


-- store procedures
SELECT *
FROM qsys2.sysroutines
WHERE routine_schema = 'VPCRZKH1';

SELECT *
FROM qsys2.sysroutines
WHERE routine_schema = 'QSYS2'
  AND routine_name LIKE '%INFO%';


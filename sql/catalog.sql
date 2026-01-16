SET current schema vpcrzkh1;

SELECT *
FROM qsys2.systables
WHERE table_owner = 'VPCRZKH';

SELECT *
FROM qsys2.syscolumns
WHERE table_schema = 'VPCRZKH1'
  AND table_name = 'EMPLOYEE';

SELECT *
FROM qsys2.sysroutines
WHERE routine_schema = 'VPCRZKH1';

SELECT *
FROM qsys2.sysroutines
WHERE routine_schema = 'QSYS2'
  AND routine_name LIKE '%INFO%';


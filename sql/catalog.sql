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
  AND table_name = 'CUSMSTL3';

-- key fields
SELECT *
  FROM qsys.qadbkatr
  WHERE dbkfil = 'CUSMSTL3'
        AND dbklib = 'VPCRZKH1';


-- key fields
SELECT dbk.dbklib, dbk.dbkfil, dbk.dbkfmt, dbk.dbkfld, dbk.dbkpos, dbk.dbkord, col.data_type,
       col.length, col.numeric_scale, col.long_comment, col.column_heading
  FROM qsys.qadbkatr dbk
       INNER JOIN qsys2.syscolumns col
         ON dbk.dbkfil = col.table_name
           AND dbk.dbkfld = col.column_name
  WHERE dbk.dbklib = 'VPCRZKH1'
        AND dbk.dbkfil = 'CUSMSTL3'
        AND col.table_schema = 'VPCRZKH1'
        AND col.table_name = 'CUSMSTL3';


-----------------------------------------------------------------------------------------------------------------------
-- SYSMEMBERSTAT view
-- The SYSMEMBERSTAT view contains one row for every table partition or table member, including rows for
-- program described files.
-----------------------------------------------------------------------------------------------------------------------
SELECT *
  FROM qsys2.sysmemberstat
  WHERE table_schema = 'VPCRZKH1'
        AND table_name = 'QCLSRC';

-----------------------------------------------------------------------------------------------------------------------
-- SYSPARTITIONSTAT
-- The SYSPARTITIONSTAT view contains one row for every table partition or table member. If the table is
-- a distributed table, the partitions that reside on other database nodes are not contained in this catalog
-- view. They are contained in the catalog views of the other database nodes.
-----------------------------------------------------------------------------------------------------------------------
SELECT table_schema, table_name, table_partition AS member_name, number_rows, number_deleted_rows, last_source_update_timestamp
  FROM qsys2.syspartitionstat
  WHERE table_schema = 'VPCRZKH1'
        AND table_name = 'QCLSRC';


-- SYSROUTINES
-- The SYSROUTINES table contains one row for each procedure created by the CREATE PROCEDURE
-- statement and each function created by the CREATE FUNCTION statement.
SELECT *
FROM qsys2.sysroutines
WHERE routine_schema = 'VPCRZKH1';

-- 
SELECT *
FROM qsys2.sysroutines
WHERE routine_schema = 'QSYS2'
  AND routine_name LIKE '%OBJECT%';

SELECT *
  FROM qsys2.sysparms
  WHERE specific_schema = 'QSYS2'
        AND specific_name LIKE '%OBJECT%';

-- SYSFUNCS
-- The SYSFUNCS view contains one row for each function created by the CREATE FUNCTION statement.
SELECT *
  FROM qsys2.sysfuncs
  WHERE specific_schema = 'QSYS2'
        AND specific_name LIKE '%OBJECT%'

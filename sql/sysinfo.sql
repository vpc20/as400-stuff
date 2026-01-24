
-- object info
SELECT *
  FROM TABLE (
      qsys2.object_statistics('VPCRZKH1', '*ALL')
    );

SELECT *
  FROM TABLE (
      qsys2.object_statistics('VPCRZKH1', '*PGM *SRVPGM')
    );


SELECT *
  FROM TABLE (
      qsys2.object_statistics('VPCRZKH1', '*PGM', 'WRK*')
    );


-- member info
SELECT *
  FROM qsys2.sysmemberstat
  WHERE table_schema = 'VPCRZKH1'
        AND table_name = 'QCLSRC';

-- member info
SELECT table_schema, table_name, table_partition AS member_name, number_rows, number_deleted_rows, last_source_update_timestamp
  FROM qsys2.syspartitionstat
  WHERE table_schema = 'VPCRZKH1'
        AND table_name = 'QCLSRC';


-- job info
SELECT *
  FROM TABLE (
      qsys2.get_job_info('*')
    ) AS x;


-- job info
SELECT *
  FROM TABLE (
      qsys2.job_info(job_user_filter => 'VPCRZKH', 
      job_status_filter => '*ALL')
    ) x;
-- WHERE JOB_TYPE NOT IN ('SBS','SYS','RDR','WTR');

SELECT *
  FROM TABLE (
      qsys2.job_info(
        job_status_filter => '*ALL', 
        job_type_filter => '*ALL', 
        job_user_filter => 'VPCRZKH', 
        job_name_filter => 'QPADEV0029')
    );


SELECT *
  FROM TABLE (
      qsys2.job_info(job_status_filter => '*ALL', 
      job_type_filter => '*ALL', 
      job_user_filter => 'QUSER')
    );

--
SELECT *
  FROM TABLE (
      qsys2.job_info(
        job_status_filter => '*ALL', 
        job_type_filter => '*ALL', 
        job_user_filter => '*ALL', 
        job_name_filter => 'QZDASOINIT')
    );


-- default job_status_filter is *all
-- default job_type_filter is *all
-- default job_user_filter is current user
SELECT *
  FROM TABLE (
      qsys2.job_info()
    );


-- active jobs
SELECT *
  FROM TABLE (
      qsys2.active_job_info()
    ) AS x;


-- Use the RELATED_OBJECTS Table Function (SYSTOOLS schema):
-- This is excellent for database files, showing views, or other files that depend on your input file,
-- recursively finding indirect dependencies.
-- This does not show Program References, Non-Database Objects and SQL Routines with Unqualified Names.
SELECT *
  FROM TABLE (
      systools.related_objects('VPCRZKH1', 'MSGLPF')
    );





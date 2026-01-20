-- file info
SELECT *
  FROM qsys2.sysfiles
  WHERE table_schema = 'VPCRZKH1';

-- object info
SELECT *
  FROM TABLE (
      qsys2.object_statistics('VPCRZKH1', '*ALL')
    );

-- field names
SELECT *
  FROM qsys2.syscolumns
  WHERE table_schema = 'VPCRZKH1'
        AND table_name = 'MSGPF'
  ORDER BY ordinal_position;

-- key fields
SELECT *
  FROM qsys.qadbkatr
  WHERE dbkfil = 'MSGPF'
        AND dbklib = 'VPCRZKH1';

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


-- active jobs
SELECT *
  FROM TABLE (
      qsys2.active_job_info()
    ) AS x;




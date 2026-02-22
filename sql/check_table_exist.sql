SET current schema vpcrzkh1;

DROP PROCEDURE table_exists;

CREATE PROCEDURE table_exists(
   IN p_schema_name VARCHAR(128),
   IN p_table_name VARCHAR(128),
   OUT p_exists_flag INT 
)
   LANGUAGE SQL
   SPECIFIC chktblexst
BEGIN
   -- Check if the table exists in the specified schema
   SELECT COUNT(*)
   INTO p_exists_flag
   FROM qsys2.systables
   WHERE table_schema = p_schema_name
     AND table_name = p_table_name;
END;

BEGIN
   DECLARE exists_flag INT DEFAULT 0;
   CALL vpcrzkh1.table_exists('VPCRZKH1', 'EMPLOYEE', exists_flag);
   CALL systools.lprintf('existst flag: ' || CHAR(exists_flag));
   -- CALL systools.lprintf('existst flag: ' || cast(exists_flag as varchar(10)));
END;

SELECT *
FROM TABLE ( qsys2.active_job_info(
  subsystem_list_filter => 'QUSRWRK',
  job_name_filter => 'QZDASOINIT',
  current_user_list_filter => 'VPCRZKH'
  ));

SELECT COUNT(*)
   FROM qsys2.systables
   WHERE table_schema = 'VPCRZKH1'
     AND table_name = 'EMPLOYEE';
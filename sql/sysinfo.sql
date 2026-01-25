-----------------------------------------------------------------------------------------------------------------------
-- OBJECT_STATISTICS table function
-- The OBJECT_STATISTICS table function returns information about objects in a library.
-----------------------------------------------------------------------------------------------------------------------
SELECT *
  FROM TABLE (
      qsys2.object_statistics(object_schema => 'VPCRZKH1', objtypelist => '*ALL')
    );

SELECT *
  FROM TABLE (
      qsys2.object_statistics(object_schema =>'VPCRZKH1', objtypelist => '*PGM *SRVPGM')
    );


SELECT *
  FROM TABLE (
      qsys2.object_statistics(object_schema => 'VPCRZKH1', objtypelist => '*PGM', object_name => 'WRK*')
    );

-----------------------------------------------------------------------------------------------------------------------
-- GET_JOB_INFO table function
-- The GET_JOB_INFO table function returns one row containing the information about a specific job.
-- Authorization: None required for a job where the caller's user profile is the same as the job user identity
-- of the job for which the information is being returned.
-- Otherwise, the caller must have either *JOBCTL special authority, or be authorized to the
-- QIBM_DB_SQLADM or QIBM_DB_SYSMON function usage identifier.
-----------------------------------------------------------------------------------------------------------------------
SELECT *
  FROM TABLE (
      qsys2.get_job_info(v_job_name => '*')
    );

SELECT *
  FROM TABLE (
      qsys2.get_job_info(v_job_name => '708028/QUSER/QZDASOINIT')
    );

-----------------------------------------------------------------------------------------------------------------------
-- JOB_INFO table function
-- The JOB_INFO table function returns one row for each job meeting the selection criteria.
-- It returns information similar to what is returned by the Work with User Jobs (WRKUSRJOB), Work with
-- Subsystem Jobs (WRKSBSJOB), and Work with Submitted Jobs (WRKSBMJOB) CL commands and the List
-- Job (QUSLJOB) API.
-----------------------------------------------------------------------------------------------------------------------

-- WRKSBMJOB SBMFROM(*USER)
SELECT *
  FROM TABLE (
      qsys2.job_info(job_submitter_filter => '*USER', job_user_filter => '*ALL')
    );

-- WRKSBSJOB SBS(QBATCH) USER(*ALL)
SELECT *
  FROM TABLE (
      qsys2.job_info(job_subsystem_filter => 'QBATCH', job_user_filter => '*ALL')
    );
 
-- WRKUSRJOB
SELECT *
  FROM TABLE (
      qsys2.job_info(job_user_filter => 'VPCRZKH', job_status_filter => '*ALL')
    ) x;

SELECT *
  FROM TABLE (
      qsys2.job_info(
        job_status_filter => '*ALL', 
        job_type_filter => '*ALL', 
        job_user_filter => 'VPCRZKH', 
        job_name_filter => 'QPADEV002T')
    );


SELECT *
  FROM TABLE (
      qsys2.job_info(job_status_filter => '*ALL', 
      job_type_filter => '*ALL', 
      job_user_filter => 'QUSER')
    );

SELECT *
  FROM TABLE (
      qsys2.job_info(
        job_status_filter => '*ALL', 
        job_type_filter => '*ALL', 
        job_user_filter => '*ALL', 
        job_name_filter => 'QZDASOINIT')
    );

SELECT *
  FROM TABLE (
      qsys2.job_info(
        job_status_filter => '*ALL', 
        job_type_filter => '*INTERACT', 
        job_user_filter => '*ALL') 
    );

SELECT *
  FROM TABLE (
      qsys2.job_info(
        job_status_filter => '*ALL', 
        job_type_filter => '*BATCH', 
        job_user_filter => '*ALL') 
    );

SELECT *
  FROM TABLE (
      qsys2.job_info(
        job_status_filter => '*ACTIVE', 
        job_type_filter => '*BATCH', 
        job_user_filter => '*ALL') 
    );

SELECT *
  FROM TABLE (
      qsys2.job_info(
        job_status_filter => '*JOBQ', 
        job_type_filter => '*BATCH', 
        job_user_filter => '*ALL') 
    );

SELECT *
  FROM TABLE (
      qsys2.job_info(
        job_status_filter => '*OUTQ', 
        job_type_filter => '*BATCH', 
        job_user_filter => '*ALL') 
    );



-- default job_status_filter is *all
-- default job_type_filter is *all
-- default job_user_filter is current user
SELECT *
  FROM TABLE (
      qsys2.job_info()
    );

-----------------------------------------------------------------------------------------------------------------------
-- ACTIVE_JOB_INFO table function
-- The ACTIVE_JOB_INFO table function returns one row for every active job.
-- The information returned is similar to the detail seen from the Work with Active Jobs (WRKACTJOB)
-- command and the List Job (QUSLJOB) API. 
-----------------------------------------------------------------------------------------------------------------------
SELECT *
  FROM TABLE (
      qsys2.active_job_info()
    );


SELECT *
  FROM TABLE (
      qsys2.active_job_info(
        subsystem_list_filter => 'QUSRWRK', job_name_filter => 'QZDASOINIT', current_user_list_filter => 'QUSER')
    );

-----------------------------------------------------------------------------------------------------------------------
-- Use the RELATED_OBJECTS Table Function (SYSTOOLS schema):
-- This is excellent for database files, showing views, or other files that depend on your input file,
-- recursively finding indirect dependencies.
-- This does not show Program References, Non-Database Objects and SQL Routines with Unqualified Names.
-----------------------------------------------------------------------------------------------------------------------
SELECT *
  FROM TABLE (
      systools.related_objects('VPCRZKH1', 'MSGLPF')
    );


-----------------------------------------------------------------------------------------------------------------------
-- OUTPUT_QUEUE_ENTRIES table function
-- The OUTPUT_QUEUE_ENTRIES table function returns one row for each spooled file in an output queue.
-----------------------------------------------------------------------------------------------------------------------
SELECT *
  FROM TABLE (
      qsys2.output_queue_entries(outq_lib => '*LIBL', outq_name => 'VPCRZKH')
    );


-- OUTPUT_QUEUE_ENTRIES view
-- The OUTPUT_QUEUE_ENTRIES view returns one row for each spooled file in every output queue. This
-- view uses the QSYS2.OUTPUT_QUEUE_ENTRIES table function with DETAILED_INFO => 'YES'.
SELECT *
  FROM qsys2.output_queue_entries
  WHERE output_queue_name = 'VPCRZKH'
        AND output_queue_library_name = 'QGPL';


-----------------------------------------------------------------------------------------------------------------------
-- SYSTEM_STATUS_INFO view
-- The SYSTEM_STATUS_INFO view returns a single row containing details about the current partition. This
-- view uses the QSYS2.SYSTEM_STATUS table function with DETAILED_INFO => 'ALL'.
-----------------------------------------------------------------------------------------------------------------------
SELECT active_jobs_in_system, interactive_jobs_in_system, batch_running, main_storage_size, system_asp_storage,
       total_auxiliary_storage, system_asp_used
  FROM qsys2.system_status_info;


-----------------------------------------------------------------------------------------------------------------------
-- SPOOLED_FILE_INFO table function
-- The SPOOLED_FILE_INFO table function returns a list of spooled files on the system.
-- This information is similar to what is returned by the Work with Spooled Files (WRKSPLF) CL command
-- and the Open List of Spooled Files (QGYOLSPL) API.
-----------------------------------------------------------------------------------------------------------------------
SELECT *
  FROM TABLE (
      qsys2.spooled_file_info(user_name => 'VPCRZKH')
    );


-----------------------------------------------------------------------------------------------------------------------
-- SPOOLED_FILE_DATA table function
-- The SPOOLED_FILE_DATA table function returns the content of a spooled file.
-----------------------------------------------------------------------------------------------------------------------
SELECT *
  FROM TABLE (
      systools.spooled_file_data(job_name => '728628/VPCRZKH/QPADEV0010', spooled_file_name => 'QPRTSPLF')
    )
  ORDER BY ordinal_position;
  
  
  
------  
SELECT * FROM QSYS2.ASP_INFO;        




-- Using a Cross Join (No Link)
-- If the tables have no relationship and you just want every possible combination
-- (or they both only have one row), you use a CROSS JOIN.
-- SELECT table1.col1, table2.col2
-- FROM table1
-- CROSS JOIN table2;

with dasoinit as (
      select job_name,
             subsystem,
             authorization_name
        from table (
            qsys2.active_job_info(
              subsystem_list_filter => 'QUSRWRK', job_name_filter => 'QZDASOINIT',
              current_user_list_filter => 'VPCRZKH')
          )
        fetch first 1 rows only)
  select system_asp_used,
         job_name,
         subsystem,
         authorization_name
    from qsys2.system_status_info
         cross join dasoinit;


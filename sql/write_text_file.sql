set current schema vpcrzkh1;

-- The QSYS2.IFS_WRITE procedure allows you to write lines of text directly to a file in the Integrated File System (IFS).
SELECT *
  FROM qsys2.sysroutines
  WHERE routine_schema = 'QSYS2'
        AND routine_name = 'IFS_WRITE';

-------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE write_to_text ()
    LANGUAGE sql
BEGIN
-- This procedure writes a line of text to a file in the /home directory
-- If the file doesn't exist, it creates it; if it does, it appends by default.
  CALL qsys2.ifs_write(path_name => '/home/vpcrzkh/output.txt',
    line => 'This is a sample line of output text.',
    file_ccsid => 1208, -- UTF-8
      overwrite => 'REPLACE' -- Options: 'REPLACE' or 'APPEND'
                     );
END;

-------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE mylib.export_data_to_ifs (
        IN p_path_name VARCHAR(100)
      )
    LANGUAGE sql
    MODIFIES SQL DATA
BEGIN
-- Declare variables
  DECLARE v_line VARCHAR(2000);
  DECLARE v_employee_id CHAR(6);
  DECLARE v_first_name VARCHAR(12);
  DECLARE v_last_name VARCHAR(15);
  DECLARE v_job VARCHAR(9);
  DECLARE end_of_data INT DEFAULT 0;
  -- Declare cursor for the result set
  -- Replace 'EMPLOYEE_TABLE' and column names with your actual table and columns
  DECLARE c1 CURSOR FOR
    SELECT CAST(empno AS CHAR(6)),
           firstnme,
           lastname,
           job
      FROM employee_table;
    -- Declare a handler for "not found" (end of cursor) condition
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET end_of_data = 1;
  -- Open the cursor
  OPEN c1;
  -- Write a header line to the file, overwriting if it exists
  SET v_line = 'EMP_ID,FIRST_NAME,LAST_NAME,JOB';
  CALL qsys2.ifs_write(
    path_name => p_path_name,
    line => v_line,
    file_ccsid => 1208, -- UTF-8 encoding
      overwrite => 'REPLACE'
  );
  -- Loop through the result set and write each row to the file
  WHILE end_of_data = 0 DO
    FETCH c1
      INTO v_employee_id,
           v_first_name,
           v_last_name,
           v_job;
    IF end_of_data = 0 THEN
      -- Format the data as a comma-separated line (adjust as needed)
      SET v_line = TRIM(v_employee_id) || ',' || TRIM(v_first_name) || ',' || TRIM(v_last_name) || ',' || TRIM(v_job);
      -- Append the line to the existing file
      CALL qsys2.ifs_write(
        path_name => p_path_name,
        line => v_line,
        end_of_line => 'APPEND'
      );
    END IF;
  END WHILE;
  -- Close the cursor
  CLOSE c1;
END;

-------------------------------------------------------------------------------
call vpcrzkh1.write_to_text()

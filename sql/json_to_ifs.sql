BEGIN
  -- 1. Declare a variable to hold the generated JSON (up to 2GB)
  DECLARE my_json_output CLOB(2G) CCSID 1208;

  -- 2. Execute your query and store the result in the variable
  SET my_json_output = (
    WITH json_rows (j) AS (
      SELECT JSON_OBJECT(
          KEY 'EMPNO' VALUE empno, KEY 'FIRSTNME' VALUE firstnme,
          KEY 'MIDINIT' VALUE midinit, KEY 'LASTNAME' VALUE lastname,
          KEY 'WORKDEPT' VALUE workdept, KEY 'PHONENO' VALUE phoneno,
          KEY 'HIREDATE' VALUE hiredate, KEY 'JOB' VALUE job,
          KEY 'EDLEVEL' VALUE edlevel, KEY 'SEX' VALUE sex,
          KEY 'BIRTHDATE' VALUE birthdate, KEY 'SALARY' VALUE salary,
          KEY 'BONUS' VALUE bonus, KEY 'COMM' VALUE comm
          ABSENT ON NULL RETURNING CLOB(2G) CCSID 1208 FORMAT JSON
        )
        FROM vpcrzkh1.employee
        ORDER BY lastname)
    SELECT JSON_OBJECT(
        KEY 'VPCRZKH1.EMPLOYEE' VALUE JSON_ARRAYAGG(
          j FORMAT JSON
        ) ABSENT ON NULL RETURNING CLOB(2G) CCSID 1208 FORMAT JSON
      )
      FROM json_rows
  );

  -- 3. Write the variable contents to an IFS file
  CALL QSYS2.IFS_WRITE_UTF8(
    PATH_NAME => '/home/vpcrzkh/employee_data.json',
    LINE => my_json_output,
    OVERWRITE => 'REPLACE',
    END_OF_LINE => 'NONE'
  );
END;

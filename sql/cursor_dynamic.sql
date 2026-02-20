
create or replace procedure vpcrzkh1.dynamic_cursor (
        in p_dept char(3),
        in p_order_by varchar(50)
      )
    dynamic result sets 1
    language sql
begin
  declare sql_text varchar(1000);
  -- Declare the cursor, specifying WITH RETURN if it is intended to return a result set to the caller.
  declare cur1 cursor with return for sql_stmt;

  -- Build dynamic SQL statement
  set sql_text = 'SELECT EMPNO, LASTNAME, WORKDEPT FROM VPCRZKH1.EMPLOYEE ' ||
        'WHERE WORKDEPT = ? ORDER BY ' || p_order_by;
  
  -- Prepare the statement
  prepare sql_stmt from sql_text;

  -- Open the cursor using input parameter for the WHERE clause
  open cur1 using p_dept;
  
end;

call vpcrzkh1.dynamic_cursor('B01', 'EMPNO');

select * from vpcrzkh1.employee;

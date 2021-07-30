drop procedure create_dept_table2;

create procedure create_dept_table2 (in p_dept char(3), 
                                     in schema_name varchar(128) default 'VPCRZKH1')
begin
   declare dynamic_stmt varchar(1000);
   declare message char(20);
   declare table_name varchar(200);
   
   declare continue handler for sqlexception 
      set message = 'ok';
   
   set table_name = '"' || schema_name || '".DEPT_' || p_dept || '_T';
   set dynamic_stmt = 'DROP TABLE ' || table_name;
   execute immediate dynamic_stmt;
   
   set dynamic_stmt = 'CREATE TABLE ' || table_name || '( EMPNO    CHAR(6)     NOT NULL,
                                                          FIRSTNME VARCHAR(12) NOT NULL,
                                                          MIDINIT  CHAR(1)     NOT NULL,
                                                          LASTNAME CHAR(15)    NOT NULL,
                                                          SALARY   DECIMAL(9,2))';
   execute immediate dynamic_stmt;
   
   set dynamic_stmt = 'INSERT INTO ' || table_name || 
                      ' SELECT EMPNO, FIRSTNME, MIDINIT, LASTNAME, SALARY
                          FROM EMPLOYEE 
                          WHERE WORKDEPT = ?';
   prepare insert_into_department_stmt from dynamic_stmt;
   execute insert_into_department_stmt using p_dept;
end;

select * from employee;
call vpcrzkh1.create_dept_table2('B01');
select * from vpcrzkh1.dept_b01_t;
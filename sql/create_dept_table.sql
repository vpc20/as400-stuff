drop procedure create_dept_table;

create procedure create_dept_table (in p_dept char(3))
      language sql
begin
   declare stmt char(1000);
   declare message char(20);
   declare table_name char(30);
   
   declare continue handler for sqlexception 
      set message = 'ok';
   
   set table_name = 'DEPT_' || p_dept || '_T';
   set stmt = 'DROP TABLE ' || table_name;
   prepare s1 from stmt;
   execute s1;
   
   set stmt = 'CREATE TABLE ' || table_name || 
              '( EMPNO CHAR(6) NOT NULL,
                 FIRSTNME VARCHAR(12) NOT NULL,
                 MIDINIT CHAR(1) NOT NULL,
                 LASTNAME CHAR(15) NOT NULL,
                 SALARY DECIMAL(9,2))';
   prepare s2 from stmt;
   execute s2;
   set stmt = 'INSERT INTO ' || table_name || 
              'SELECT EMPNO, FIRSTNME, MIDINIT, LASTNAME, SALARY
                  FROM EMPLOYEE
                  WHERE WORKDEPT = ?';
   prepare s3 from stmt;
   execute s3 using p_dept;
end;

call vpcrzkh1.create_dept_table('C01');
select * from dept_c01_t;
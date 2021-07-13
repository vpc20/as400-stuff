--#SET TERMINATOR #
create procedure reseq_empno ()
      language sql
      modifies sql data
begin
   declare emp_count integer;
   declare stmt varchar(50);
   declare empnum char(6);
   declare eof int default 0;
   
   declare c1 cursor for
      select empno
         from employee
         order by hiredate;
   declare continue handler for not found set eof = 1;
   
   alter table employee drop primary key;
   
   select count(*)
      into emp_count
      from employee;
   set emp_count = emp_count + 1;
   set stmt = 'alter sequence empno_seq restart with ' || char(emp_count);
   prepare s from stmt;
   execute s;
   
   update employee
      set empno = right(digits(next value for empno_seq), 6);
   
   alter sequence empno_seq restart with 1;
   
   open c1;
   fetch c1
      into empnum;
   while eof = 0 do
      update employee
         set empno = right(digits(next value for empno_seq), 6)
         where empno = empnum;
      fetch c1
         into empnum;
   end while;
   close c1;
   
   alter table employee add primary key (empno);
end;
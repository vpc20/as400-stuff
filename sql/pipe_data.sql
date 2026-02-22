set current schema vpcrzkh1;

create function transform()
   returns table (
      employee_name char(20),
      unique_num int
   )
   begin
      declare empname varchar(15);
      declare myrecnum integer default 1;
      declare at_end integer default 0;
      
      declare emp_cursor cursor for
         select lastname
            from employee;
      declare continue handler for sqlstate '02000' 
         set at_end = 1;

      open emp_cursor;

      myloop: loop
         fetch emp_cursor into empname;
         if at_end = 1 then
            leave myloop;
         end if;
         pipe (empname, myrecnum); -- return single row
         set myrecnum = myrecnum + 1;
      end loop;

      close emp_cursor;
      return;
   end;

select * from table(vpcrzkh1.transform());
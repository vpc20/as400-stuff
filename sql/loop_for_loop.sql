drop procedure create_bonus_table;

--#SET TERMINATOR #
create procedure create_bonus_table (in    dept_number char(3), 
                                     inout cnt         int)
      language sql
      modifies sql data
      
-- Compound statements can be made atomic so if an error occurs that is not expected, the statements
-- within the atomic statement are rolled back.
begin atomic
   declare name varchar(30) default null;
   
   -- employee_bonus already exist
   declare continue handler for sqlstate '42710' 
      select count(*) into cnt
         from employee_bonus;
         
   -- duplicate key      
   declare continue handler for sqlstate '23505' 
      set cnt = cnt - 1;

   declare undo handler for sqlexception 
      set cnt = null;
   
   if dept_number is not null then
      create table employee_bonus (fullname varchar(30), 
                                   bonus    decimal(10, 2), 
                                   primary key (fullname));
      for c1 cursor for
         select firstnme, midinit, lastname, bonus
            from employee
            where workdept = dept_number
         do
            if bonus > 0 then
               set name = firstnme || ' ' || midinit || ' ' || lastname;
               insert into employee_bonus
                  values (name, bonus);
               set cnt = cnt + 1;
            end if;
      end for;
   end if;
end;

call vpcrzkh1.create_bonus_table('C01', 0);
select * from employee_bonus;

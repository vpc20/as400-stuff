drop procedure update_salary_1;

create procedure update_salary_1 (in employee_number char(10), 
                                  in rate            decimal(6, 2))
   language sql
   modifies sql data 
--   
   update employee
      set salary = salary * rate
      where empno = employee_number;
      
select * from employee; 
call vpcrzkh1.update_salary_1('000010', 0.5); 

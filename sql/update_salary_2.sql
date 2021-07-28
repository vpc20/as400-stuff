drop procedure update_salary_2;

create procedure update_salary_2 (in employee_number char(6), 
                                  in rating          int)
      language sql
      modifies sql data
      
case rating
   when 1 then 
      update employee
         set salary = salary * 1.10, bonus = 1000
         where empno = employee_number;
   when 2 then 
      update employee
         set salary = salary * 1.05, bonus = 500
         where empno = employee_number;
   else 
      update employee
         set salary = salary * 1.03, bonus = 0
         where empno = employee_number;
end case;

select * from employee;
call vpcrzkh1.update_salary_2('000020', 1);

SET current schema vpcrzkh1;

DROP PROCEDURE return_dept_salary;

create procedure return_dept_salary (
        in dept_number char(3),
        out dept_salary decimal(15, 2),
        out dept_bonus_cnt int
      )
    language sql
    specific retdeptsal
    reads sql data
    set option dbgview = *source
begin
  declare employee_salary decimal(9, 2);
  declare employee_bonus decimal(9, 2);
  declare total_salary decimal(15, 2) default 0;
  declare bonus_cnt int default 0;
  declare end_table int default 0;
--
  declare c1 cursor for
    select salary, bonus
      from employee
      where workdept = dept_number;
  declare continue handler for not found set end_table = 1;
  declare exit handler for sqlexception set dept_salary = null;
--
  open c1;
  fetch c1
    into employee_salary,
         employee_bonus;
  while end_table = 0 do
    set total_salary = total_salary + employee_salary + employee_bonus;
    if employee_bonus > 0 then
      set bonus_cnt = bonus_cnt + 1;
    end if;
    fetch c1
      into employee_salary,
           employee_bonus;
  end while;
--
  close c1;
  set dept_salary = total_salary;
  set dept_bonus_cnt = bonus_cnt;
end;

-- test return_dept_salary
BEGIN
   DECLARE dept_number CHAR(3);
   DECLARE dept_salary DECIMAL(15, 2);
   DECLARE dept_bonus_cnt INT;
   --
   CALL vpcrzkh1.return_dept_salary('C01',
                           dept_salary,
                           dept_bonus_cnt);
   CALL systools.lprintf('salary: ' || CHAR(dept_salary));
   CALL systools.lprintf('bonus: ' || CHAR(dept_bonus_cnt));
END;

SELECT SUM(salary)  + SUM(bonus), COUNT(bonus)
FROM employee
WHERE workdept = 'C01';



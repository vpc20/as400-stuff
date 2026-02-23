DROP PROCEDURE update_salary_1;

CREATE PROCEDURE update_salary_1(
   IN employee_number CHAR(10),
   IN rate DECIMAL(6, 2))
   LANGUAGE SQL
   MODIFIES SQL DATA
--   
UPDATE employee
SET salary = salary * rate
   WHERE empno = employee_number;

SELECT *
   FROM employee;
CALL vpcrzkh1.update_salary_1('000010', 0.5);

SET CURRENT schema vpcrzkh1;

SELECT *
  FROM employee;

SELECT lastname, salary, salary *.05 AS raise
  FROM employee
  WHERE empno = '200140';


SELECT p.*, prendate - prstdate AS diff
  FROM project p
  WHERE INTEGER(prendate - prstdate) > 100;


SELECT workdept, DECIMAL(AVG(salary), 5, 0) AS avg_salary
  FROM employee
  GROUP BY workdept
  ORDER BY workdept;


SELECT majproj, SUM(prstaff)
  FROM project
  GROUP BY majproj
  ORDER BY majproj;


SELECT workdept, sex, DECIMAL(AVG(salary), 5, 0) AS avg_wages
  FROM employee
  GROUP BY workdept, sex;


SELECT workdept, DECIMAL(AVG(salary), 5, 0) AS avg_wages, MIN(edlevel) AS min_educ
  FROM employee
  WHERE sex = 'F'
  GROUP BY workdept
  HAVING MIN(edlevel) >= 16;


SELECT lastname, firstnme, salary
  FROM employee
  WHERE sex = 'F'
  ORDER BY salary DESC;


SELECT TRIM(lastname) || ', ' || TRIM(firstnme) AS fullname
  FROM employee
  ORDER BY fullname;


SELECT CAST(birthdate AS CHAR(10))
  FROM employee;


SELECT DISTINCT job
  FROM employee
  WHERE workdept = 'D11';

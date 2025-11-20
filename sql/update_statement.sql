-- Changing data in a table using the UPDATE statement
UPDATE employee
SET workdept = 'D11',
    phoneno  = '7213',
    job      = 'DESIGNER'
WHERE empno = '000270';


UPDATE employee
SET (workdept, phoneno, job)
      = ('D11', '7213', 'DESIGNER')
WHERE empno = '000270';


-- Updating a table using a scalar-subselect
UPDATE project
SET deptno =
      (SELECT workdept
       FROM employee
       WHERE project.respemp = employee.empno)
WHERE respemp = '000030';


SELECT *
FROM project
WHERE respemp = '000030';

SELECT *
FROM employee
WHERE empno = '000030';


-- Updating a table with rows from another table
-- UPDATE cl_sched
-- SET row =
--       (SELECT *
--        FROM mycopy
--        WHERE cl_sched.class_code = mycopy.class_code);


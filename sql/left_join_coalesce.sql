SELECT *
FROM employee;

SELECT *
FROM department;

CREATE TABLE vpcrzkh1.empdept AS
(
  SELECT empno, workdept
  FROM employee
) WITH NO DATA;

SELECT *
FROM empdept;

INSERT INTO empdept (empno, workdept)
VALUES ('200340', 'X21');

-- error encountered - 'Token EXISTS was not valid'
-- SELECT empno,
--        CASE
--          WHEN EXISTS(SELECT * FROM empdept WHERE empdept.empno = employee.empno)
--            THEN
--            (SELECT workdept
--             FROM empdept
--             WHERE empdept.empno = employee.empno)
--          ELSE
--            workdept
--          END
-- FROM employee;


-- error encountered -  'Comparison operator IN not valid'
-- SELECT empno,
--        CASE
--          WHEN empno IN (SELECT empno FROM empdept)
--            THEN (SELECT workdept FROM empdept WHERE empdept.empno = employee.empno)
--          ELSE workdept
--          END AS final_workdept
-- FROM employee;


-- left join with coalesce function
SELECT e.empno,
       COALESCE(ed.workdept, e.workdept) AS final_workdept
FROM employee e
LEFT JOIN empdept ed
          ON e.empno = ed.empno;

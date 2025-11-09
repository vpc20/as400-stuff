SELECT empno,
       salary,
       RANK() OVER (ORDER BY salary DESC)       AS rank,
       DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank,
       ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_number
FROM employee
  FETCH FIRST 10 ROWS ONLY;


SELECT workdept,
       INT(AVG(salary))                          AS average,
       RANK() OVER (ORDER BY AVG(salary) DESC)   AS avg_salary,
       ntile(3) OVER (ORDER BY AVG(salary) DESC) AS quantile
FROM employee
GROUP BY workdept;


SELECT workdept,
       lastname,
       bonus,
       DENSE_RANK() OVER (PARTITION BY workdept ORDER BY workdept, bonus DESC)
         AS bonus_rank_in_dept
FROM employee
WHERE workdept LIKE 'E%';


SELECT ROW_NUMBER() OVER (ORDER BY salary DESC),
       empno,
       salary,
       deptno,
       deptname
FROM (SELECT empno, workdept, salary
      FROM employee
      ORDER BY salary DESC
        FETCH FIRST 5 ROWS ONLY) emp
INNER JOIN department dep
           ON dep.deptno = emp.workdept
WHERE deptno = workdept;


SELECT empno, lastname, projno
FROM employee
INNER JOIN project
           ON empno = respemp
WHERE lastname > 'S';

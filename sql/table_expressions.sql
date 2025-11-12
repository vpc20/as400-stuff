SELECT dept.mgrno, dept.deptno, maxsal
FROM department dept,
     (SELECT MAX(salary) AS maxsal, workdept
      FROM employee emp
      GROUP BY workdept) t1
WHERE dept.deptno = t1.workdept
ORDER BY dept.deptno;

-- same as sql statement above
WITH t1 AS (SELECT MAX(salary) AS maxsal, workdept
            FROM employee emp
            GROUP BY workdept)
SELECT dept.mgrno, dept.deptno, t1.maxsal
FROM department dept
INNER JOIN t1
           ON dept.deptno = t1.workdept
ORDER BY dept.deptno;


WITH dt AS (SELECT e.workdept AS deptno, AVG(salary) AS avgsal
            FROM department d,
                 employee e
            WHERE d.deptno = e.workdept
            GROUP BY e.workdept)
SELECT 'E' AS deptgrp, MAX(avgsal) AS maxavgsal, CAST(MIN(avgsal) AS DECIMAL(10, 2)) AS minavgsal
FROM dt
WHERE deptno LIKE 'E%'
UNION
SELECT 'D', MAX(avgsal), CAST(MIN(avgsal) AS DECIMAL(10, 2)) AS minavgsal
FROM dt
WHERE deptno LIKE 'D%';


-- multiple common table expressions
-- WITH x AS (SELECT order_id, cust_id
--            FROM orders
--            ORDER BY ord_date DESC
--              FETCH FIRST 1000 ROWS ONLY),
--      y AS (SELECT cust_id, line_id, order_qty
--            FROM x,
--                 orderline
--            WHERE x.order_id = orderline.order_id)
-- SELECT line_id
-- FROM (SELECT line_id
--       FROM y
--       WHERE y.cust_id IN (SELECT DISTINCT cust_id
--                           FROM y
--                           WHERE line.id = 'XXX')
--       GROUP BY line_id
--       ORDER BY SUM(order_qty) DESC)
--   FETCH FIRST 5 ROWS ONLY

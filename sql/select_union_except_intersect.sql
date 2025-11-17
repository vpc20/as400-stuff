SELECT empno
FROM employee
WHERE workdept = 'D11'
UNION
SELECT empno
FROM empprojact
WHERE projno = 'MA2112'
   OR projno = 'MA2113'
   OR projno = 'AD3111'
ORDER BY empno;


-- If you want to keep duplicates in the result of a UNION operation, specify the UNION ALL keyword instead
-- of just UNION
SELECT empno
FROM employee
WHERE workdept = 'D11'
UNION ALL
SELECT empno
FROM empprojact
WHERE projno = 'MA2112'
   OR projno = 'MA2113'
   OR projno = 'AD3111'
ORDER BY empno;


-- The EXCEPT keyword returns the result set of the first subselect minus any matching rows from the
-- second subselect
SELECT empno
FROM employee
WHERE workdept = 'D11'
EXCEPT
SELECT empno
FROM empprojact
WHERE projno = 'MA2112'
   OR projno = 'MA2113'
   OR projno = 'AD3111'
ORDER BY empno;


-- The INTERSECT keyword returns a combined result set that consists of all of the rows existing in both
-- result sets
SELECT empno
FROM employee
WHERE workdept = 'D11'
INTERSECT
SELECT empno
FROM empprojact
WHERE projno = 'MA2112'
   OR projno = 'MA2113'
   OR projno = 'AD3111'
ORDER BY empno;
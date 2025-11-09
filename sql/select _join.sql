SELECT empno, lastname, firstnme, projno, projname
FROM employee emp
INNER JOIN project proj
           ON emp.empno = proj.respemp
WHERE lastname > 'S'
ORDER BY lastname;

-- same as sql statement above
SELECT empno, lastname, firstnme, projno, projname
FROM employee emp,
     project proj
WHERE emp.empno = proj.respemp
  AND lastname > 'S'
ORDER BY lastname;

select * from projact;
select acstdate from projact;

SELECT empno, projact.acstdate
FROM projact
INNER JOIN empprojact
           USING (projno, actno)
WHERE acsdate > '1982-12-31';



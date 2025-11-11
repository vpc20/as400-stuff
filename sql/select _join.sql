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


SELECT empno, acstdate
FROM projact
INNER JOIN empprojact
           USING (projno, actno)
WHERE acstdate > '1982-12-31';


-- same as sql statement above
SELECT empno, acstdate
FROM projact
INNER JOIN empprojact
           ON projact.projno = empprojact.projno AND
              projact.actno = empprojact.actno
WHERE acstdate > '1982-12-31';


SELECT emp.empno, emp.lastname, proj.projno
FROM employee emp
LEFT JOIN project proj
          ON emp.empno = proj.respemp
WHERE lastname > 'S';


-- same as left outer join above
SELECT emp.empno, emp.lastname, proj.projno
FROM project proj
RIGHT OUTER JOIN employee emp
                 ON emp.empno = proj.respemp
WHERE lastname > 'S';


SELECT employee.empno, employee.lastname, project.projno
FROM employee
  EXCEPTION
JOIN project
     ON employee.empno = project.respemp
WHERE lastname > 'S';


-- another way of writing exception join
SELECT emp.empno, emp.lastname
FROM employee emp
WHERE emp.lastname > 'S'
  AND NOT EXISTS
  (SELECT *
   FROM project proj
   WHERE emp.empno = proj.respemp);


CREATE TABLE a
(
  acol1 VARCHAR(10),
  acol2 VARCHAR(10)
);

CREATE TABLE b
(
  bcol1 VARCHAR(10),
  bcol2 VARCHAR(10)
);

INSERT INTO a (acol1, acol2)
VALUES ('A1', 'AA1');
INSERT INTO a (acol1, acol2)
VALUES ('A2', 'AA2');
INSERT INTO a (acol1, acol2)
VALUES ('A3', 'AA3');

SELECT *
FROM a;

INSERT INTO b (bcol1, bcol2)
VALUES ('B1', 'BB1');
INSERT INTO b (bcol1, bcol2)
VALUES ('B2', 'BB2');

SELECT *
FROM b;


SELECT *
FROM a
CROSS JOIN b;


-- another way to write cross join
SELECT *
FROM a,
     b;





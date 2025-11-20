-- Inserting rows using the VALUES clause
INSERT INTO department (deptno, deptname, mgrno, admrdept)
VALUES ('E31', 'ARCHITECTURE', '00390', 'E01');

SELECT *
FROM department;
select * from employee;


INSERT INTO project (projno, projname, deptno, respemp, prstdate)
VALUES ('HG0023', 'NEW NETWORK', 'E11', '200280', CURRENT DATE),
       ('HG0024', 'NETWORK PGM', 'E11', '200310', CURRENT DATE);

SELECT *
FROM project;


CREATE TABLE emptime AS
(
  SELECT empno AS empnumber, projno AS projnumber, emstdate AS startdate, emendate AS enddate
  FROM empprojact
) WITH NO DATA;
-- drop table emptime;


-- Inserting rows using a select-statement
INSERT INTO emptime
  (empnumber, projnumber, startdate, enddate)
SELECT empno, projno, emstdate, emendate
FROM empprojact;

SELECT *
FROM emptime;
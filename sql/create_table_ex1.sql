SET CURRENT schema vpcrzkh1;

CREATE TABLE inventory (
      partno SMALLINT NOT NULL,
      descr VARCHAR(24),
      qonhand INT,
      PRIMARY KEY (partno)
    );
    

CREATE TABLE employee2 LIKE employee;

CREATE TABLE employee3 AS
      (SELECT empno, lastname, job, workdept
          FROM employee
          WHERE workdept = 'D11')
      WITH DATA;
      

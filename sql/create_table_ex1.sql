SET current schema vpcrzkh1;

CREATE TABLE inventory
(
  partno  SMALLINT NOT NULL,
  descr   VARCHAR(24),
  qonhand INT,
  PRIMARY KEY (partno)
);


CREATE TABLE employee2 LIKE employee;

CREATE TABLE employee3 AS
(
  SELECT empno, lastname, job, workdept
  FROM employee
  WHERE workdept = 'D11'
)
  WITH DATA;


-- Creating an identity column and a row change timestamp column
CREATE TABLE orders
(
  orderno             SMALLINT NOT NULL
    GENERATED ALWAYS AS IDENTITY
      (START WITH 500
      INCREMENT BY 1
      CYCLE),
  shipped_to          VARCHAR(36),
  order_date          DATE,
  status              CHAR(1),
  ord_change_type     CHAR(1) GENERATED ALWAYS AS (DATA CHANGE OPERATION),
  ord_change_user     VARCHAR(128) GENERATED ALWAYS AS (SESSION_USER),
  ord_change_applname VARCHAR(255) GENERATED ALWAYS AS (CURRENT CLIENT_APPLNAME),
  ord_change_jobname  VARCHAR(28) GENERATED ALWAYS AS (qsys2.job_name),
  change_ts           TIMESTAMP FOR EACH ROW ON UPDATE AS ROW CHANGE TIMESTAMP NOT NULL
);

DROP TABLE orders;

INSERT INTO orders (shipped_to, order_date, status)
VALUES ('ABC Company', '2025-11-01', 'P');

INSERT INTO orders (shipped_to, order_date, status)
VALUES ('Adrian Abad', '2025-11-05', 'P');

SELECT *
FROM orders;

SELECT CURRENT CLIENT_APPLNAME
FROM sysibm.sysdummy1;



SET CURRENT schema vpcrzkh1;

CREATE SEQUENCE order_seq
  START WITH 500
  INCREMENT BY 1
  MAXVALUE 1000
  CYCLE
  CACHE 24;


CREATE TABLE orders_with_seq (
      orderno SMALLINT NOT NULL,
      custno SMALLINT
    );


INSERT INTO orders_with_seq (orderno, custno)
  VALUES (NEXT VALUE FOR order_seq, 12);
  
select * from orders_with_seq;

SELECT *
  FROM qsys2.syssequences
  WHERE sequence_schema = 'VPCRZKH1';



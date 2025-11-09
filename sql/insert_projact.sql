CREATE TABLE projact
(
  projno   CHAR(6)  NOT NULL,
  actno    SMALLINT NOT NULL,
  acstaff  DECIMAL(5, 2),
  acstdate DATE     NOT NULL,
  acendate DATE,
  PRIMARY KEY (projno, actno, acstdate)
);

insert into projact values ('AD3100', 10 , NULL, '1982-01-01', NULL);
insert into projact values ('AD3110', 10 , NULL, '1982-01-01', NULL);
insert into projact values ('AD3111', 60 , NULL, '1982-01-01', NULL);
insert into projact values ('AD3111', 60 , NULL, '1982-03-15', NULL);
insert into projact values ('AD3111', 70 , NULL, '1982-03-15', NULL);
insert into projact values ('AD3111', 80 , NULL, '1982-04-15', NULL);
insert into projact values ('AD3111', 180, NULL, '1982-10-15', NULL);
insert into projact values ('AD3111', 70 , NULL, '1982-02-15', NULL);
insert into projact values ('AD3111', 80 , NULL, '1982-09-15', NULL);
insert into projact values ('AD3112', 60 , NULL, '1982-01-01', NULL);
insert into projact values ('AD3112', 60 , NULL, '1982-02-01', NULL);
insert into projact values ('AD3112', 60 , NULL, '1983-01-01', NULL);
insert into projact values ('AD3112', 70 , NULL, '1982-02-01', NULL);
insert into projact values ('AD3112', 70 , NULL, '1982-03-15', NULL);
insert into projact values ('AD3112', 70 , NULL, '1982-08-15', NULL);
insert into projact values ('AD3112', 80 , NULL, '1982-08-15', NULL);
insert into projact values ('AD3112', 80 , NULL, '1982-10-15', NULL);
insert into projact values ('AD3112', 180, NULL, '1982-08-15', NULL);
insert into projact values ('AD3113', 70 , NULL, '1982-06-15', NULL);
insert into projact values ('AD3113', 70 , NULL, '1982-07-01', NULL);
insert into projact values ('AD3113', 80 , NULL, '1982-01-01', NULL);
insert into projact values ('AD3113', 80 , NULL, '1982-03-01', NULL);
insert into projact values ('AD3113', 180, NULL, '1982-03-01', NULL);
insert into projact values ('AD3113', 180, NULL, '1982-04-15', NULL);
insert into projact values ('AD3113', 180, NULL, '1982-06-01', NULL);
insert into projact values ('AD3113', 60 , NULL, '1982-03-01', NULL);
insert into projact values ('AD3113', 60 , NULL, '1982-04-01', NULL);
insert into projact values ('AD3113', 60 , NULL, '1982-09-01', NULL);
insert into projact values ('AD3113', 70 , NULL, '1982-09-01', NULL);
insert into projact values ('AD3113', 70 , NULL, '1982-10-15', NULL);
insert into projact values ('IF1000', 10 , NULL, '1982-06-01', NULL);
insert into projact values ('IF1000', 90 , NULL, '1982-10-01', NULL);
insert into projact values ('IF1000', 100, NULL, '1982-10-01', NULL);
insert into projact values ('IF2000', 10 , NULL, '1982-01-01', NULL);
insert into projact values ('IF2000', 100, NULL, '1982-01-01', NULL);
insert into projact values ('IF2000', 100, NULL, '1982-03-01', NULL);
insert into projact values ('IF2000', 110, NULL, '1982-03-01', NULL);
insert into projact values ('IF2000', 110, NULL, '1982-10-01', NULL);
insert into projact values ('MA2100', 10 , NULL, '1982-01-01', NULL);
insert into projact values ('MA2100', 20 , NULL, '1982-01-01', NULL);
insert into projact values ('MA2110', 10 , NULL, '1982-01-01', NULL);
insert into projact values ('MA2111', 50 , NULL, '1982-01-01', NULL);
insert into projact values ('MA2111', 60 , NULL, '1982-06-15', NULL);
insert into projact values ('MA2111', 40 , NULL, '1982-01-01', NULL);
insert into projact values ('MA2112', 60 , NULL, '1982-01-01', NULL);
insert into projact values ('MA2112', 180, NULL, '1982-07-15', NULL);
insert into projact values ('MA2112', 70 , NULL, '1982-06-01', NULL);
insert into projact values ('MA2112', 70 , NULL, '1982-01-01', NULL);
insert into projact values ('MA2112', 80 , NULL, '1982-10-01', NULL);
insert into projact values ('MA2113', 60 , NULL, '1982-07-15', NULL);
insert into projact values ('MA2113', 80 , NULL, '1982-01-01', NULL);
insert into projact values ('MA2113', 70 , NULL, '1982-04-01', NULL);
insert into projact values ('MA2113', 80 , NULL, '1982-10-01', NULL);
insert into projact values ('MA2113', 180, NULL, '1982-10-01', NULL);
insert into projact values ('OP1000', 10 , NULL, '1982-01-01', NULL);
insert into projact values ('OP1010', 10 , NULL, '1982-01-01', NULL);
insert into projact values ('OP1010', 130, NULL, '1982-01-01', NULL);
insert into projact values ('OP2010', 10 , NULL, '1982-01-01', NULL);
insert into projact values ('OP2011', 140, NULL, '1982-01-01', NULL);
insert into projact values ('OP2011', 150, NULL, '1982-01-01', NULL);
insert into projact values ('OP2012', 140, NULL, '1982-01-01', NULL);
insert into projact values ('OP2012', 160, NULL, '1982-01-01', NULL);
insert into projact values ('OP2013', 140, NULL, '1982-01-01', NULL);
insert into projact values ('OP2013', 170, NULL, '1982-01-01', NULL);
insert into projact values ('PL2100', 30 , NULL, '1982-01-01', NULL);

select * from projact;

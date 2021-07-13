create sequence empno_seq
   start with 1
   increment by 1
   no maxvalue
   no cycle;

alter sequence empno_seq restart;

select e.*,
       right(digits(next value for empno_seq), 6)
   from employee e
   order by hiredate;
   
-- sequence is updated for each sql statement, even if there is no update
alter sequence empno_seq restart;   
   
update employee set empno = right(digits(next value for empno_seq), 6);

select * from employee;
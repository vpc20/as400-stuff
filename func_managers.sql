-- SQL table UDF

--#SET TERMINATOR #
create function managers ()
   returns table (
      empno char(6),
      firstnme varchar(12),
      midinit char(1),
      lastname varchar(15),
      workdept char(3)
   )
   begin
      return select empno,
                    firstnme,
                    midinit,
                    lastname,
                    workdept
            from employee
            where job = 'MANAGER';
   end;
   
select * from table(vpcrzkh1.managers());

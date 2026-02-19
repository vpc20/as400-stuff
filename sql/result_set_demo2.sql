set current schema vpcrzkh1;

drop procedure result_set_demo2();

create procedure result_set_demo2()
      language sql
      dynamic result sets 2
begin
   declare c1 cursor for
      select *
         from department
         for read only;
   declare c2 cursor for
      select *
         from employee
         for read only;
   open c1;
   open c2;
   return;
end;

call vpcrzkh1.result_set_demo2();


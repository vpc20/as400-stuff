-- SQL scalar UDF

--#SET TERMINATOR #
create function priority (
         indate date
   )
   returns char(7)
   language sql
   begin
      return (
         case
            when indate > current date-3 days then 'HIGH'
            when indate > current date-7 days then 'MEDIUM'
            else 'LOW'
         end);
   end;

select vpcrzkh1.priority('2021-07-12')
   from sysibm.sysdummy1;
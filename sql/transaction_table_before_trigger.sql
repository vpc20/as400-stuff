--#SET TERMINATOR #
set current schema vpcrzkh1;

create table transactiontable (
         dateoftransaction date,
         fiscalquarter smallint
      );

create or replace trigger transactionbeforetrigger
      before insert on transactiontable
      referencing new as new_row 
      for each row mode db2row
   begin
      declare newmonth smallint;
      set newmonth = month(new_row.dateoftransaction);
      if newmonth < 4 then
         set new_row.fiscalquarter = 3;
      elseif newmonth < 7 then
         set new_row.fiscalquarter = 4;
      elseif newmonth < 10 then
         set new_row.fiscalquarter = 1;
      else 
         set new_row.fiscalquarter = 2;
      end if;
   end;

insert into transactiontable (
         dateoftransaction)
   values
      (current date);

insert into transactiontable (
         dateoftransaction)
   values
      ('2021-03-25');

insert into transactiontable (
         dateoftransaction)
   values
      ('06/15/2021');

insert into transactiontable (
         dateoftransaction)
   values
      ('03.12.2021');

      
select * from transactiontable;
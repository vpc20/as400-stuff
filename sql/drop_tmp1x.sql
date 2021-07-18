--#SET TERMINATOR #
create or replace procedure drop_tmp1x ()
      language sql
begin
   declare dummy int default 0;
   declare continue handler for sqlstate '42704'  -- file not found
      set dummy = 1;                              -- ignore error
   drop table qtemp.tmp1x;
end;

call vpcrzkh1.drop_tmp1x();

--#SET TERMINATOR #
create or replace procedure delete_outfiles_dspfd ()
      language sql
      modifies sql data
begin
--
   declare eof int default 0;
   declare tblnm varchar(128);
   declare stmt varchar(50);
--
   declare c1 cursor for
      select table_name
         from qsys2.systables
         where system_table_schema = 'VPCRZKH1' and
               table_text = 'Output file for DSPFD TYPE(*MBR)';
   declare continue handler for not found set eof = 1;
--
   open c1;
--   
   fetch c1 into tblnm;
   while eof = 0 do
      set stmt = 'drop table ' || tblnm;
      prepare s1 from stmt;
      execute s1;
      fetch c1 into tblnm;
   end while;
--
   close c1;
end;
--
call vpcrzkh1.delete_outfiles_dspfd();

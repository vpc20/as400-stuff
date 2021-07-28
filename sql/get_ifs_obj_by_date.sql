--#SET TERMINATOR #
create or replace procedure get_ifs_obj_by_date( in dirname char(32),
                                                 in alldir  varchar(3),
                                                 in objType varchar(1408))
    language sql
    dynamic result set 1
    modifies sql data
begin

   declare eof       int default 0;
   declare pathname  char(128);

   declare c1 cursor for
       select path_name from table(qsys2.ifs_object_statistics(dirname, alldir, objtype))
--        select path_name from table(qsys2.ifs_object_statistics('/home/VPCRZKH', 'NO', '*ALLSTMF'))
           where days(current date) - days(create_timestamp) > 3 
           and position('/.', path_name) = 0;

   declare continue handler for not found 
      set eof = 1;
   
   open c1;
--    fetch c1 into pathname;
-- 
--    while eof = 0 do
--       CALL QCMDEXC('wrksplf output(*print)') ;
--       fetch c1 into pathname;
--    end while;
-- 
--    close c1;
   
end;

call vpcrzkh1.get_ifs_obj_by_date('/home/VPCRZKH', 'NO', '*ALLSTMF');
call vpcrzkh1.get_ifs_obj_by_date(' ',' ',' ');

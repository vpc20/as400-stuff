create procedure resset ()
      language sql
      dynamic result sets 1  -- a result table associated with a cursor opened in the stored procedure
begin
   declare c1 cursor for
      select *
         from qiws.qcustcdt;
   open c1;
   return;
end;

call vpcrzkh1.resset;


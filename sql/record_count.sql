set current schema vpcrzkh1;

drop function vpcrzkh1.record_count;

create function vpcrzkh1.record_count (
      in_filename char(10), in_libname char(10)
  )
  returns bigint
  language sql
  --
  begin
  --
    declare rec_count bigint;
    declare c1 cursor for
      select number_rows
        from qsys2.syspartitionstat
        where table_schema = upper(in_libname)
              and table_name = upper(in_filename);
    open c1;
    fetch c1
      into rec_count;
    --
    return rec_count;
    --
  end;
  
select vpcrzkh1.record_count('msgpf', 'vpcrzkh1') FROM sysibm.sysdummy1;
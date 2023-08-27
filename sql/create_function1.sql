set current schema vpcrzkh1;

set path = "QSYS","QSYS2","SYSPROC","SYSIBMADM","VPCRZKH","VPCRZKH1";

select year(current date - date('2021-07-03'))
  from sysibm.sysdummy1;

drop function age;

create function age (
      bday decimal(8, 0)
  )
  returns int
  language sql
  --
  begin
    return (year(current date - date(left(bday, 4) || '-' || substr(bday, 5, 2) || '-' || right(bday, 2))));
  end;
  
select age(19720330)
from sysibm.sysdummy1;
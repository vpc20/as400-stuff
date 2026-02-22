set current schema vpcrzkh1;
set path = "QSYS","QSYS2","SYSPROC","SYSIBMADM","VPCRZKH","VPCRZKH1";


-- functions
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

--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
create function age (
      bday date
  )
  returns int
  language sql
  --
  begin
    return (year(current date - bday));
  end;

--------------------------------------------------------------------------------
create function age2 (
      bday decimal(8, 0)
  )
  returns int
  language sql
  --
  begin
    return (year(current date - date(left(bday, 4) || '-' || substr(bday, 5, 2) || '-' || right(bday, 2))));
  end;

-- test functions
select vpcrzkh1.age('1972-03-30')
  from sysibm.sysdummy1;

select vpcrzkh1.age2(19720330)
from sysibm.sysdummy1;

select *
  from table (
      vpcrzkh1.managers()
    );
    

select vpcrzkh1.priority('2021-07-12')
  from sysibm.sysdummy1;
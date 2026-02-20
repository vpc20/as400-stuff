SET current schema vpcrzkh1;

begin
  declare v_dept char(3);
  declare v_deptname varchar(29);
  declare v_admdept char(3);
  declare at_end integer default 0;
  --
  declare not_found condition for sqlstate '02000';
  --
  declare c1 cursor for
    select deptno, deptname, admrdept
      from department
      order by deptno;
    --
  declare continue handler for not_found set at_end = 1;
  --
  open c1;
  ins_loop: loop
    fetch c1
      into v_dept, v_deptname, v_admdept;
    if at_end = 1 then
      leave ins_loop;
    elseif v_dept <> 'D11' then
      iterate ins_loop;
    end if;
    insert into department (
          deptno, deptname, admrdept)
      values ('NEW', v_deptname, v_admdept);
  end loop;
  close c1;
end;


SELECT *
FROM department;

SELECT *
FROM department
WHERE deptno = 'NEW';

DELETE
FROM department
WHERE deptno = 'NEW';

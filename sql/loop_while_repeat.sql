set current schema vpcrzkh1;

drop procedure repeat_stmt;

create procedure repeat_stmt (out counter integer)
    language sql
begin
  declare v_counter integer default 0;
  declare v_firstnme varchar(12);
  declare v_midinit char(1);
  declare v_lastname varchar(15);
  declare at_end smallint default 0;
  --
  declare not_found condition for sqlstate '02000';
  --
  declare c1 cursor for
    select firstnme, midinit, lastname
      from employee;
    --
  declare continue handler for not_found set at_end = 1;
  --
  open c1;
  fetch_loop:
  repeat 
    fetch c1
      into v_firstnme, v_midinit, v_lastname;
    if at_end = 0 then
      set v_counter = v_counter + 1;
    end if;
    until at_end > 0
  end repeat fetch_loop;
  set counter = v_counter;
  close c1;
end;


select * from employee;


-- test repeat_stmt - qsys2.send_message
begin
  declare counter integer;
  declare msg_text varchar(50) default ' ';
  declare msg_len int default 0;
  --
  call vpcrzkh1.repeat_stmt(counter);
  
  set msg_text = 'counter: ' || char(counter);
  set msg_len = length(msg_text);
  
  call qsys2.send_message(
    message_id => 'CPF9898',
    message_length => msg_len,
    message_text => msg_text,
    message_file_library => 'QSYS',
    message_file => 'QCPFMSG',
    message_queue_library => 'QUSRSYS',
    message_queue => 'VPCRZKH');
end;

-- test repeat_stmt - SYSTOOLS.LPRINTF
begin
  declare counter integer;
  --
  call vpcrzkh1.repeat_stmt(counter);
  CALL SYSTOOLS.LPRINTF('counter: ' || char(counter));
end;


select count(*) from employee;



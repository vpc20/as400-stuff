begin
  declare msg_text varchar(50) default 'hello from sql';
  declare msg_len int default 0;
  set msg_len = length(msg_text);
  call qsys2.send_message(
    message_id => 'CPF9898',
    message_length => msg_len,
    message_text => msg_text,
    message_file_library => 'QSYS',
    message_file => 'QCPFMSG',
    message_queue_library => 'QUSRSYS',
    message_queue => 'VPCRZKH'
  );
end;
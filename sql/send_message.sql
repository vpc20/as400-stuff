-- SEND_MESSAGE procedure
-- The SEND_MESSAGE procedure sends an informational message to a message queue.
BEGIN
   DECLARE msg_text CHAR(50) DEFAULT 'hello from sql';
   DECLARE msg_len INT DEFAULT 0;
   CALL qsys2.send_message(
      message_id => 'CPF9897',
      message_length => LENGTH(msg_text),
      message_text => msg_text,
      message_file_library => 'QSYS',
      message_file => 'QCPFMSG',
      message_queue_library => 'QUSRSYS',
      message_queue => 'VPCRZKH');
END;

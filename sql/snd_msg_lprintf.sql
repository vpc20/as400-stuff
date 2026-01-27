-- CALL QSYS2.QCMDEXC('SNDPGMMSG MSG(test1) TOPGMQ(*EXT) MSGTYPE(*INFO)');
-- 
-- CALL QSYS2.SEND_MESSAGE(message_length => 33,  
  -- MESSAGE_TEXT => 'Processing completed successfully',
  -- message_queue => '*EXT'
-- );

CALL SYSTOOLS.LPRINTF('test message');
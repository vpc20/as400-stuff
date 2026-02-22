-- Command SNDPGMMSG not allowed in this setting.
-- SNDPGMMSG has to executed via CL program
-- call qsys2.qcmdexc('SNDPGMMSG MSG(test message via qcmdexc - sndpgmmsg)  TOPGMQ(*EXT) MSGTYPE(*INFO)'); 

CALL SYSTOOLS.LPRINTF('test message lprintf');
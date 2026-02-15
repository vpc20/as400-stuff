**free
ctl-opt main(Main) dftactgrp(*no);

dcl-f errdspf workstn indds(indic) usropn qualified;

dcl-ds recdtl1ds   likerec(errdspf.recdtl1: *all);
dcl-ds msgctlds   likerec(errdspf.msgctl: *all);


dcl-ds indic qualified;
   f3Exit     ind pos(03);
   sflend     ind pos(90);
end-ds;

dcl-s procName varchar(256);

/copy QRPGLESRC,ERRPROTO

dcl-proc Main;

   open errdspf;

   clearErrors();
   sendError('ERR0001' : 'User');
   indic.sflend =  *on;
   sendError('MSG0001' : ' ');

   msgctlds.pgmq = '*';

   //msgctlds.pgmq = pgmPsds.pgmName;   // 'ERRDEMO   '
   // msgctlds.pgmq = 'ERRDEMO   ';
   // msgctlds.pgmq = '*EXT';
   //msgctlds.pgmq = 'Main      ';

   //msgctlds.pgmq = *blanks;
   //procName = %proc();
   //EVAL %SUBST(msgctlds.pgmq :   1 : %len(procName)) = procName;
   //EVAL %SUBST(msgctlds.pgmq : 267 : %len(pgmPsds.pgmName)) = pgmPsds.pgmName;

   //msgctlds.pgmq = *blanks;
   //EVAL %SUBST(msgctlds.pgmq :   1 : 9) = 'SENDERROR';
   //EVAL %SUBST(msgctlds.pgmq : 267 : 7) = 'ERRDEMO';

   write errdspf.msgctl msgctlds;
   exfmt errdspf.recdtl1 recdtl1ds;

   close errdspf;
   *inlr = *on;

end-proc;



/copy QRPGLESRC,ERRLOGIC

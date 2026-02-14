**free
dcl-proc sendError;

  dcl-pi *n;
    p_msgId   char(7)  const;
    p_msgData varchar(256) const;
  end-pi;

  dcl-s msgKey  char(4);
  // Pad manually or use a 20-char constant
  dcl-s msgFile char(20) inz('APPMSGF   *LIBL     ');

  //sndPgmMsg(p_msgId : msgFile : p_msgData : %len(p_msgData) :
  //          '*INFO' : '*' : 1 : msgkey  : apiError);
  sndPgmMsg(p_msgId : msgFile : p_msgData : %len(p_msgData) :
            '*INFO' : '*' : 1 : msgkey  : apiError);

  // msgctlds.pgmq = *blanks;
  // procName = %proc();
  // EVAL %SUBST(msgctlds.pgmq :   1 : %len(procName)) = procName;
  //  EVAL %SUBST(msgctlds.pgmq : 267 : %len(pgmPsds.pgmName)) = pgmPsds.pgmName;

end-proc;

dcl-proc clearErrors;
  dcl-pi *n end-pi;
  //clrPgmMsg('*' : 1: *blanks : '*ALL' : apiError);
  clrPgmMsg('*' : 1: *blanks : '*ALL' : apiError);
end-proc;


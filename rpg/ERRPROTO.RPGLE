**free
// API Prototypes
dcl-pr sndPgmMsg extpgm('QMHSNDPM');
  msgId         char(7)   const;
  msgFile       char(20)  const;
  msgData       char(256) const options(*varsize);
  msgDataLen    int(10)   const;
  msgType       char(10)  const;
  callStack     char(10)  const;
  callStackCtr  int(10)   const;
  msgKey        char(4);
  errorCode     char(32767) options(*varsize);
end-pr;

dcl-pr clrPgmMsg extpgm('QMHRMVPM');
  callStack     char(10)  const;
  callStackCtr  int(10)   const;
  msgKey        char(4)   const;
  msgRemove     char(10)  const;
  errorCode     char(32767) options(*varsize);
end-pr;

// Wrapper Prototypes
dcl-pr sendError;
  p_msgId   char(7)  const;
  p_msgData varchar(256) const;
end-pr;

dcl-pr clearErrors;
end-pr;

// Standard Error Structure
dcl-ds apiError qualified;
  bytesProv     int(10) inz(%size(apiError));
  bytesAvail    int(10);
  exceptionID   char(7);
end-ds;


dcl-ds pgmPsds psds qualified;
  //pgmName char(10) pos(1);    // positions 1-10 = program name
  //procName *proc;              // current procedure name
    pgmName  *proc;              // returns program name
end-ds;


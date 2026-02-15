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

// --- QWVRCSTK API Data Structures -------------------------------------------

// Receiver variable - CSTK0100 format header
// Offsets per IBM doc: 0=bytesReturned, 4=bytesAvail, 8=numEntries,
//                     12=offsetFirst, 16=numReturned, 20=threadId(8),
//                     28=infoStatus(1), 29=reserved
dcl-ds rcvHdr qualified;
  bytesReturned  int(10) inz(0);
  bytesAvailable int(10) inz(0);
  numEntries     int(10) inz(0);
  offsetFirst    int(10) inz(0);
  numReturned    int(10) inz(0);
  threadId       char(8);
  infoStatus     char(1);
  reserved       char(3);
end-ds;

// Each stack entry - variable length, walked via pointer
// Offsets per IBM doc: 0=entryLen, 4=stmtDisp, 8=numStmt,
//                     12=procDisp, 16=procLen, 20=reqLevel,
//                     24=pgmName(10), 34=pgmLib(10)
dcl-ds stackEntry qualified based(pEntry);
  entryLen   int(10);
  stmtDisp   int(10);
  numStmt    int(10);
  procDisp   int(10);
  procLen    int(10);
  reqLevel   int(10);
  pgmName    char(10);
  pgmLib     char(10);
end-ds;

// JIDF0100 format - exactly per IBM doc (56 bytes total)
// offset 0:  CHAR(10) job name    - '*' = current job, user/number = blanks
// offset 10: CHAR(10) user name   - blanks when job name is special value
// offset 20: CHAR(6)  job number  - blanks when job name is special value
// offset 26: CHAR(16) int job id  - MUST BE BLANKS when job name is not *INT
// offset 42: CHAR(2)  reserved    - must be hex zeros
// offset 44: BINARY(4) threadInd  - 1 = current thread
// offset 48: CHAR(8)  thread id   - hex zeros when threadInd is not 0
dcl-ds jobIdInf qualified;
  jobName    char(10) inz('*');          // '*' = this job
  userName   char(10) inz(' ');          // blanks - required for special value
  jobNumber  char(6)  inz(' ');          // blanks - required for special value
  intJobId   char(16) inz(' ');          // BLANKS - not hex zeros!
  reserved   char(2)  inz(*allx'00');    // hex zeros as required
  threadInd  int(10)  inz(1);            // 1 = current thread
  threadId   char(8)  inz(*allx'00');    // hex zeros when threadInd <> 0
end-ds;

// Error code structure
dcl-ds errCode qualified;
  bytesProvided  int(10) inz(0);
  bytesAvailable int(10) inz(0);
  msgId          char(7);
  reserved       char(1);
  msgData        char(256);
end-ds;

// --- Prototype for QWVRCSTK -------------------------------------------------

dcl-pr QWVRCSTK extpgm('QWVRCSTK');
  rcvVar      char(32767) options(*varsize);
  rcvVarLen   int(10)     const;
  fmtName     char(8)     const;
  jobIdInfo   char(56)    const;
  jobIdFmt    char(8)     const;
  errCode     char(32767) options(*varsize);
end-pr;

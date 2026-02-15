**free
// ---------------------------------------------------------------------
dcl-proc sendError;

  dcl-pi *n;
    p_msgId   char(7)  const;
    p_msgData varchar(256) const;
  end-pi;

  dcl-s msgKey  char(4);
  // Pad manually or use a 20-char constant
  dcl-s msgFile char(20) inz('APPMSGF   *LIBL     ');

  sndPgmMsg(p_msgId : msgFile : p_msgData : %len(p_msgData) :
            '*INFO' : '*' : GetStackDepth(%proc) : msgkey  : apiError);

end-proc;

// ---------------------------------------------------------------------
dcl-proc clearErrors;

  dcl-pi *n end-pi;
  //dsply ('GetStackDepth(%proc)');
  //dsply (GetStackDepth(%proc));
  clrPgmMsg('*' : GetStackDepth(%proc) : *blanks : '*ALL' : apiError);

end-proc;

// --- GetStackDepth ----------------------------------------------------------
dcl-proc GetStackDepth;

  dcl-pi *n int(10);
    startProc varchar(256) const;
  end-pi;

  dcl-s rcvBuffer  char(32767) inz(*allx'00');
  dcl-s procName   varchar(256);
  dcl-s depth      int(10) inz(0);
  dcl-s mainFound  ind     inz(*off);
  dcl-s i          int(10);
  dcl-s offset     int(10);
  dcl-s currProc   varchar(256);

  currProc = %proc;
  errCode.bytesProvided = %size(errCode);

  QWVRCSTK( rcvBuffer
           : %size(rcvBuffer)
           : 'CSTK0100'
           : jobIdInf
           : 'JIDF0100'
           : errCode );

  if errCode.bytesAvailable > 0;
    dsply ('API Error: ' + errCode.msgId);
    return -1;
  endif;

  // Map header
  rcvHdr = %subst(rcvBuffer : 1 : %size(rcvHdr));

  // offsetFirst is 0-based byte offset from start of buffer
  offset = rcvHdr.offsetFirst + 1;

  for i = 1 to rcvHdr.numReturned;
    pEntry = %addr(rcvBuffer) + offset - 1;

    if stackEntry.procLen > 0;
      procName = %subst( rcvBuffer
                       : offset + stackEntry.procDisp
                       : stackEntry.procLen );
    else;
      procName = '';
    endif;

    // Stop counting when we reach startProc
    if %upper(%trimr(procName)) = startProc;
      depth += 1;
      leave;
    endif;

    // Skip the GetStackDepth frame itself, count everything else
    if %upper(%trimr(procName)) <> %upper(%trimr(currProc));  //'GETSTACKDEPTH'
      depth += 1;
    endif;

    offset += stackEntry.entryLen;
  endfor;

  return depth;
end-proc;



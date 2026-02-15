**free
ctl-opt dftactgrp(*no) main(MyMain);

dcl-ds pgmPsds psds qualified;
  progName *proc;
end-ds;

// %PROC() is the standard approach for error logging and diagnostic routines where you need
// to identify exactly which procedure is executing.
dcl-proc MyMain;
  dsply ('Pgm: ' + pgmPsds.progName + ' Proc: ' + %proc());
  testSub();
end-proc;

dcl-proc testSub;
  dsply ('Pgm: ' + pgmPsds.progName + ' Proc: ' + %proc());
end-proc;


             PGM        PARM(&FILENAME &LIBNAME)

             DCLF       FILE(QAFDMBRL)

             DCL        VAR(&FILENAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBNAME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRRCD)   TYPE(*DEC)  LEN(15)
             DCL        VAR(&NBRRCDX)  TYPE(*CHAR) LEN(15)

             CHGVAR     VAR(&NBRRCD) VALUE(0)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('Retrieving file member +
                          description ...') TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
             DSPFD      FILE(&LIBNAME/&FILENAME) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/TEMPFD)
             OVRDBF     FILE(QAFDMBRL) TOFILE(TEMPFD)

 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(SNDMSG))
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('Counting records of member : ' +
                          *cat &mLname) TOPGMQ(*EXT) MSGTYPE(*STATUS)
             CHGVAR     VAR(&NBRRCD) VALUE(&NBRRCD + &MLNRCD)
             GOTO       CMDLBL(LOOP)

 SNDMSG:     CHGVAR     VAR(&NBRRCDX) VALUE(&NBRRCD)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Total +
                          number of records ' *cat &nbrrcdx)

             ENDPGM

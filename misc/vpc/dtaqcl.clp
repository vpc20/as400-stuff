             PGM

             DCL        VAR(&DTAQNM) TYPE(*CHAR) LEN(10) +
                          VALUE('TESTDTAQ1')
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10) VALUE('QTEMP')
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(4 0) VALUE(1024)
             DCL        VAR(&FLD) TYPE(*CHAR) LEN(1024)
             DCL        VAR(&WAIT) TYPE(*DEC) LEN(5 0) VALUE(-1)

             DLTDTAQ    DTAQ(&LIB/&DTAQNM)
             MONMSG     MSGID(CPF0000)

             CRTDTAQ    DTAQ(&LIB/&DTAQNM) MAXLEN(1024)

             CALL       PGM(QCLRDTAQ) PARM(&DTAQNM &LIB)

             CHGVAR     VAR(&FLD) VALUE('Sample data queue data')
             CALL       PGM(QSNDDTAQ) PARM(&DTAQNM &LIB &FLDLEN &FLD)

             CALL       PGM(*LIBL/QRCVDTAQ) PARM(&DTAQNM &LIB +
                          &FLDLEN &FLD &WAIT)

             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&FLD)

             ENDPGM

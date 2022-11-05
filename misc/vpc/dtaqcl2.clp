             PGM

             DCL        VAR(&DTAQNM) TYPE(*CHAR) LEN(10) +
                          VALUE('TESTDTAQ1')
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10) +
                          VALUE('KIBVICTOR')
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(4 0) VALUE(1024)
             DCL        VAR(&FLD) TYPE(*CHAR) LEN(1024)
             DCL        VAR(&WAIT) TYPE(*DEC) LEN(5 0) VALUE(-1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

LOOP:        CALL       PGM(QRCVDTAQ) PARM(&DTAQNM &LIB &FLDLEN &FLD +
                          &WAIT)

             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&FLD)

             RTVJOBA    USER(&USER)
             SNDMSG     MSG(&FLD) TOUSR(&USER)

             GOTO       CMDLBL(LOOP)

             ENDPGM

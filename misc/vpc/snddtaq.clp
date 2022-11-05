             PGM        PARM(&DTAQ &DTALEN &DATA)

             DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DTAQNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTALEN) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(4096)

             DCL        VAR(&MSGID)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(256)

             MONMSG     MSGID(CPF0000 CPF9999) EXEC(GOTO CMDLBL(ERROR))


             CHGVAR     VAR(&DTAQNAME) VALUE(%SST(&DTAQ 1 10))
             CHGVAR     VAR(&LIBNAME) VALUE(%SST(&DTAQ 11 10))

             CALL       PGM(QCLRDTAQ) PARM(&DTAQNAME &LIBNAME)

             CALL       PGM(QSNDDTAQ) PARM(&DTAQNAME &LIBNAME +
                          &DTALEN &DATA)
             RETURN

 ERROR:      RCVMSG     MSGTYPE(*DIAG) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF)
             IF         COND(&MSGID *NE ' ') THEN(DO)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA)
             GOTO       CMDLBL(ERROR)
             ENDDO
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA)

             ENDPGM

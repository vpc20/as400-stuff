             PGM        PARM(&DTAQ)

             DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DTAQNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTALEN) TYPE(*DEC) LEN(4 0) VALUE(4096)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(4096)
             DCL        VAR(&WAIT) TYPE(*DEC) LEN(5) VALUE(0)
             DCL        VAR(&SQLSTMT) TYPE(*CHAR) LEN(512)
             DCL        VAR(&SQUOTE) TYPE(*CHAR) LEN(1) VALUE('''')

             DCL        VAR(&MSGID)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(256)

             MONMSG     MSGID(CPF0000 CPF9999) EXEC(GOTO CMDLBL(ERROR))


             CHGVAR     VAR(&DTAQNAME) VALUE(%SST(&DTAQ 1 10))
             CHGVAR     VAR(&LIBNAME) VALUE(%SST(&DTAQ 11 10))

             CALL       PGM(QRCVDTAQ) PARM(&DTAQNAME &LIBNAME +
                          &DTALEN &DATA &WAIT)

             DLTF       FILE(QTEMP/DTAQPF)
             MONMSG     MSGID(CPF0000)

             CRTPF      FILE(QTEMP/DTAQPF) RCDLEN(4096)

             CHGVAR     VAR(&SQLSTMT) VALUE('insert into +
                          qtemp/dtaqpf values(' *TCAT &SQUOTE *TCAT +
                          &DATA *TCAT &SQUOTE *TCAT ')')
             SQL        SQLSTMT(&SQLSTMT)

             DSPPFM     FILE(QTEMP/DTAQPF)


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

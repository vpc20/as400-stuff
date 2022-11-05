             PGM        PARM(&SPLFNAME &SPLFNBR &JOBATTR)

             DCL        VAR(&SPLFNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SPLFNBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOBATTR)  TYPE(*CHAR) LEN(10)

             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNBR)  TYPE(*CHAR) LEN(10)

             DCL        VAR(&MSGID)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(256)

             MONMSG     MSGID(CPF0000 CPF9999) EXEC(GOTO CMDLBL(ERROR))

      /***   Get job attributes   ***/
             RTVJOBA    JOB(&JOBNAME) USER(&USER) NBR(&JOBNBR)

      /***   Get list of spooled files and output to temp file  ***/
             WRKSPLF    OUTPUT(*PRINT)

             DLTF       FILE(QTEMP/TEMPFILE1)
             MONMSG     MSGID(CPF0000)
             CRTPF      FILE(QTEMP/TEMPFILE1) RCDLEN(145)
             CPYSPLF    FILE(QPRTSPLF) TOFILE(QTEMP/TEMPFILE1) +
                          JOB(&JOBNBR/&USER/&JOBNAME) SPLNBR(*LAST)

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

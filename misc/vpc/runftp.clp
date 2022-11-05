             PGM        PARM(&RMTSYS &FILE &MBR &ERRLOG)

             DCL        VAR(&RMTSYS)  TYPE(*CHAR) LEN(15)
             DCL        VAR(&FILE)    TYPE(*CHAR) LEN(20)
             DCL        VAR(&MBR)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERRLOG)  TYPE(*CHAR) LEN(20)

             DCL        VAR(&FILENAME)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBNAME)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERRFILENM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERRLIBNAME) TYPE(*CHAR) LEN(10)

             DCL        VAR(&MSGID)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA)    TYPE(*CHAR) LEN(256)

             MONMSG     MSGID(CPF0000 TCP0000) EXEC(GOTO CMDLBL(ERROR))


      /***   Verify TCP/IP connection   ***/

             PING       RMTSYS(&RMTSYS)


      /***   Get all qualified filenames   ***/

             CHGVAR     VAR(&FILENAME) VALUE(%SST(&FILE 1 10))
             CHGVAR     VAR(&LIBNAME)  VALUE(%SST(&FILE 11 10))

             CHGVAR     VAR(&ERRFILENM)  VALUE(%SST(&ERRLOG 1 10))
             CHGVAR     VAR(&ERRLIBNAME) VALUE(%SST(&ERRLOG 11 10))


      /***   Check if FTP script exists   ***/

             CHKOBJ     OBJ(&LIBNAME/&FILENAME) OBJTYPE(*FILE) +
                          MBR(&MBR)


      /***   Create error log file   ***/

             DLTF       FILE(&ERRLIBNAME/&ERRFILENM)
             MONMSG     MSGID(CPF0000)

             CRTPF      FILE(&ERRLIBNAME/&ERRFILENM) RCDLEN(80)


      /***   Execute FTP Script   ***/

             OVRDBF     FILE(INPUT) TOFILE(&LIBNAME/&FILENAME) +
                          MBR(&MBR)
             OVRDBF     FILE(OUTPUT) TOFILE(&ERRLIBNAME/&ERRFILENM)

             FTP        RMTSYS(&RMTSYS)

             DLTOVR     FILE(*ALL)

             RETURN


      /***   Error handling routine   ***/

 ERROR:      RCVMSG     MSGTYPE(*DIAG) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF)
             MONMSG     MSGID(CPF0000)

             IF         COND(&MSGID *NE ' ') THEN(DO)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(ERROR)
             ENDDO

             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF)
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA)
             MONMSG     MSGID(CPF0000)

             ENDPGM

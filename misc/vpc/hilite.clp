             PGM        PARM(&FILELIB &MBRNAME)

       /***  Variable declaration   ***/

             DCL        VAR(&FILELIB)  TYPE(*CHAR) LEN(20)
             DCL        VAR(&MBRNAME)  TYPE(*CHAR) LEN(10)

             DCL        VAR(&FILENAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBNAME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCTYPE)  TYPE(*CHAR) LEN(10)

             DCL        VAR(&MSGID)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA)    TYPE(*CHAR) LEN(256)


       /***  Global error handler   ***/

             MONMSG     MSGID(CPF0000 CPF9999) EXEC(GOTO CMDLBL(ERROR))


       /***  Only COBOL programs are handled by the hilight pgm   ***/

             CHGVAR     VAR(&FILENAME) VALUE(%SST(&FILELIB 1 10))
             CHGVAR     VAR(&LIBNAME)  VALUE(%SST(&FILELIB 11 10))

             RTVMBRD    FILE(&LIBNAME/&FILENAME) MBR(&MBRNAME) +
                          SRCTYPE(&SRCTYPE)
             IF         COND(&SRCTYPE *NE 'CBL') THEN(DO)
             SNDPGMMSG  MSG('Only COBOL programs are handled by the +
                          hilite utility program.')
             GOTO       CMDLBL(ENDPGM)
             ENDDO


       /***  Call COBOL hilight program   ***/

             OVRDBF     FILE(TEXTFILE) TOFILE(&LIBNAME/&FILENAME) +
                          MBR(&MBRNAME)
             CALL       PGM(HILITECBL)
             DLTOVR     FILE(*ALL)

             SNDPGMMSG  MSG('Comments for COBOL program' *BCAT +
                          &mbrname *BCAT 'has been highlighted.')

             RETURN


       /***  Error handling routine   ***/

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

 ENDPGM:     ENDPGM

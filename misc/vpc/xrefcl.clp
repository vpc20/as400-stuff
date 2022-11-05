             PGM        PARM(&FILELIB &SELALL &REFRESH &USAGE)

             DCL        VAR(&FILELIB)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&FILENAME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBNAME)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&SELALL)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&REFRESH)   TYPE(*CHAR) LEN(1)

             DCL        VAR(&USAGE)     TYPE(*CHAR) LEN(5)
             DCL        VAR(&USGINP)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&USGOUT)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&USGUPD)    TYPE(*CHAR) LEN(1)

             DCL        VAR(&SQLSTMT)   TYPE(*CHAR) LEN(500)
             DCL        VAR(&USAGELIST) TYPE(*CHAR) LEN(50)
             DCL        VAR(&QUOTE) TYPE(*CHAR) LEN(1) VALUE('''')

             DCL        VAR(&MSGID)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA)    TYPE(*CHAR) LEN(256)

             MONMSG     MSGID(CPF0000 CPA0000) EXEC(GOTO CMDLBL(ERROR))

             CHGVAR     VAR(&FILENAME) VALUE(%SST(&FILELIB 1 10))
             CHGVAR     VAR(&LIBNAME)  VALUE(%SST(&FILELIB 11 10))

             CHGVAR     VAR(&USGINP) VALUE(%SST(&USAGE 3 1))
             CHGVAR     VAR(&USGOUT) VALUE(%SST(&USAGE 4 1))
             CHGVAR     VAR(&USGUPD) VALUE(%SST(&USAGE 5 1))

             CHKOBJ     OBJ(&LIBNAME/&FILENAME) OBJTYPE(*FILE)

             CHKOBJ     OBJ(*CURLIB/XPGMREF) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(PGMREF))

             IF         COND(&REFRESH *EQ 'N') THEN(GOTO CMDLBL(QRY))

 PGMREF:     DSPPGMREF  PGM(&LIBNAME/*ALL) OUTPUT(*OUTFILE) +
                          OUTFILE(*CURLIB/XPGMREF)


 QRY:        IF         COND(&USGINP *EQ 'Y') THEN(DO)
               CHGVAR     VAR(&USAGELIST) VALUE(' 1,3,5,7')
             ENDDO

             IF         COND(&USGOUT *EQ 'Y') THEN(DO)
               IF         COND(&USGINP *EQ 'Y') THEN(DO)
               CHGVAR     VAR(&USAGELIST) VALUE(&USAGELIST *BCAT ',')
               ENDDO
               CHGVAR     VAR(&USAGELIST) VALUE(&USAGELIST *BCAT ' +
                          2,3,6,7')
             ENDDO

             IF         COND(&USGUPD *EQ 'Y') THEN(DO)
               IF         COND(&USGINP *EQ 'Y' *OR &USGOUT *EQ 'Y') +
                          THEN(DO)
               CHGVAR     VAR(&USAGELIST) VALUE(&USAGELIST *BCAT ',')
               ENDDO
               CHGVAR     VAR(&USAGELIST) VALUE(&USAGELIST *BCAT ' +
                          4,5,6,7')
             ENDDO

             CHGVAR     VAR(&SQLSTMT) VALUE('SELECT WHFNAM, WHPNAM, +
                          WHTEXT, WHFUSG FROM XPGMREF WHERE WHFUSG +
                          IN (' *BCAT &USAGELIST *BCAT ') ' *BCAT +
                          'AND WHFNAM = ' *BCAT &QUOTE *CAT +
                          &FILENAME *CAT &QUOTE *BCAT 'ORDER BY +
                          WHPNAM')
             SQL        SQLSTMT(&SQLSTMT) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/XPGMREF1)

             CALL       PGM(XREFCBL) PARM(&FILENAME &LIBNAME &SELALL +
                          &USGINP &USGOUT &USGUPD)

             RETURN

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

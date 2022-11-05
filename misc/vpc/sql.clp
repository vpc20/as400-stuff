             PGM        PARM(&SQLSTMT &OUTPUT &OUTFILE &OUTMBR)

             DCL        VAR(&SQLSTMT)   TYPE(*CHAR) LEN(550)
             DCL        VAR(&OUTPUT)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&OUTFILE)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&OUTMBR)    TYPE(*CHAR) LEN(16)

             DCL        VAR(&OUTFILENM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMBER)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&REPLADD)   TYPE(*CHAR) LEN(8)

             DCL        VAR(&CH)        TYPE(*CHAR) LEN(1)
             DCL        VAR(&SQL1X)     TYPE(*CHAR) LEN(55)
             DCL        VAR(&SQL2X)     TYPE(*CHAR) LEN(55)
             DCL        VAR(&SQL3X)     TYPE(*CHAR) LEN(55)
             DCL        VAR(&SQL4X)     TYPE(*CHAR) LEN(55)
             DCL        VAR(&SQL5X)     TYPE(*CHAR) LEN(55)
             DCL        VAR(&SQL6X)     TYPE(*CHAR) LEN(55)
             DCL        VAR(&SQL7X)     TYPE(*CHAR) LEN(55)
             DCL        VAR(&SQL8X)     TYPE(*CHAR) LEN(55)
             DCL        VAR(&SQL9X)     TYPE(*CHAR) LEN(55)
             DCL        VAR(&SQL10X)    TYPE(*CHAR) LEN(55)
             DCL        VAR(&TEMPSTR)   TYPE(*CHAR) LEN(55)
             DCL        VAR(&POS)       TYPE(*DEC)  LEN(2)
             DCL        VAR(&CTR)       TYPE(*DEC)  LEN(2)  VALUE(1)
             DCL        VAR(&STARTPOS)  TYPE(*DEC)  LEN(3)  VALUE(1)

             DCL        VAR(&MSGID)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA)    TYPE(*CHAR) LEN(256)

             MONMSG     MSGID(CPF0000 CPF9999 QWM0000 SQL0000) +
                          EXEC(GOTO CMDLBL(ERROR))


 LOOP:       CHGVAR     VAR(&TEMPSTR) VALUE(%SST(&SQLSTMT &STARTPOS +
                          55))
             CHGVAR     VAR(&POS) VALUE(56)

 SRCH_SPACE: CHGVAR     VAR(&POS) VALUE(&POS - 1)
             CHGVAR     VAR(&CH) VALUE(%SST(&TEMPSTR &POS 1))
             IF         COND(&CH *NE ' ') THEN(GOTO CMDLBL(SRCH_SPACE))

             IF         COND(&CTR *EQ 1) THEN(CHGVAR VAR(&SQL1X) +
                          VALUE(%SST(&SQLSTMT &STARTPOS &POS)))
             IF         COND(&CTR *EQ 2) THEN(CHGVAR VAR(&SQL2X) +
                          VALUE(' ' *CAT %SST(&SQLSTMT &STARTPOS +
                          &POS)))
             IF         COND(&CTR *EQ 3) THEN(CHGVAR VAR(&SQL3X) +
                          VALUE(' ' *CAT %SST(&SQLSTMT &STARTPOS +
                          &POS)))
             IF         COND(&CTR *EQ 4) THEN(CHGVAR VAR(&SQL4X) +
                          VALUE(' ' *CAT %SST(&SQLSTMT &STARTPOS +
                          &POS)))
             IF         COND(&CTR *EQ 5) THEN(CHGVAR VAR(&SQL5X) +
                          VALUE(' ' *CAT %SST(&SQLSTMT &STARTPOS +
                          &POS)))
             IF         COND(&CTR *EQ 6) THEN(CHGVAR VAR(&SQL6X) +
                          VALUE(' ' *CAT %SST(&SQLSTMT &STARTPOS +
                          &POS)))
             IF         COND(&CTR *EQ 7) THEN(CHGVAR VAR(&SQL7X) +
                          VALUE(' ' *CAT %SST(&SQLSTMT &STARTPOS +
                          &POS)))
             IF         COND(&CTR *EQ 8) THEN(CHGVAR VAR(&SQL8X) +
                          VALUE(' ' *CAT %SST(&SQLSTMT &STARTPOS +
                          &POS)))
             IF         COND(&CTR *EQ 9) THEN(CHGVAR VAR(&SQL9X) +
                          VALUE(' ' *CAT %SST(&SQLSTMT &STARTPOS +
                          &POS)))
             IF         COND(&CTR *EQ 10) THEN(CHGVAR VAR(&SQL10X) +
                          VALUE(' ' *CAT %SST(&SQLSTMT &STARTPOS +
                          &POS)))

             CHGVAR     VAR(&STARTPOS) VALUE(&STARTPOS + &POS)
             IF         COND(&CTR *NE 10) THEN(DO)
             CHGVAR     VAR(&CTR) VALUE(&CTR + 1)
             GOTO       CMDLBL(LOOP)
             ENDDO

             CHGVAR     VAR(&OUTFILENM) VALUE(%SST(&OUTFILE 1 10))
             CHGVAR     VAR(&OUTLIB)    VALUE(%SST(&OUTFILE 11 10))
             CHGVAR     VAR(&MEMBER)    VALUE(%SST(&OUTMBR  3 6))
             CHGVAR     VAR(&REPLADD)   VALUE(%SST(&OUTMBR  9 8))

             IF         COND(&OUTLIB *NE ' ') THEN(CHKOBJ +
                          OBJ(&OUTLIB) OBJTYPE(*LIB))

             IF         COND(&OUTPUT *EQ '*') THEN(DO)
             STRQMQRY   QMQRY(SQLQMQRY) OUTPUT(*) SETVAR((SQL1 +
                          &SQL1X) (SQL2 &SQL2X) (SQL3 &SQL3X) (SQL4 +
                          &SQL4X) (SQL5 &SQL5X) (SQL6 &SQL6X) (SQL7 +
                          &SQL7X) (SQL8 &SQL8X) (SQL9 &SQL9X) +
                          (SQL10 &SQL10X))
             ENDDO

             IF         COND(&OUTPUT *EQ *PRINT) THEN(DO)
             STRQMQRY   QMQRY(SQLQMQRY) OUTPUT(*PRINT) DATETIME(*NO) +
                          SETVAR((SQL1 &SQL1X) (SQL2 &SQL2X) (SQL3 +
                          &SQL3X) (SQL4 &SQL4X) (SQL5 &SQL5X) (SQL6 +
                          &SQL6X) (SQL7 &SQL7X) (SQL8 &SQL8X) (SQL9 +
                          &SQL9X) (SQL10 &SQL10X))
             ENDDO

             IF         COND(&OUTPUT *EQ *OUTFILE) THEN(DO)
             STRQMQRY   QMQRY(SQLQMQRY) OUTPUT(*OUTFILE) +
                          OUTFILE(&OUTLIB/&OUTFILENM) +
                          OUTMBR(&MEMBER &REPLADD) SETVAR((SQL1 +
                          &SQL1X) (SQL2 &SQL2X) (SQL3 &SQL3X) (SQL4 +
                          &SQL4X) (SQL5 &SQL5X) (SQL6 &SQL6X) (SQL7 +
                          &SQL7X) (SQL8 &SQL8X) (SQL9 &SQL9X) +
                          (SQL10 &SQL10X))
             ENDDO

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

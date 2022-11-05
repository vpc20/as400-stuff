             PGM        PARM(&PGMLIB)

             DCL        VAR(&PGMLIB)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&PGMNAME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBNAME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SQLSTMT)  TYPE(*CHAR) LEN(500)
             DCL        VAR(&QUOTE)    TYPE(*CHAR) LEN(1) VALUE('''')

             DCL        VAR(&MSGID)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA)   TYPE(*CHAR) LEN(256)

             MONMSG     MSGID(CPF0000 CPA0000) EXEC(GOTO CMDLBL(ERROR))


             CHGVAR     VAR(&PGMNAME)  VALUE(%SST(&PGMLIB 1 10))
             CHGVAR     VAR(&LIBNAME)  VALUE(%SST(&PGMLIB 11 10))

             CHKOBJ     OBJ(*CURLIB/XPGMREF) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DSPPGMREF +
                          PGM(&LIBNAME/*ALL) OUTPUT(*OUTFILE) +
                          OUTFILE(*CURLIB/XPGMREF))

             CHGVAR     VAR(&SQLSTMT) VALUE('SELECT DISTINCT WHPNAM, +
                          WHTEXT FROM XPGMREF WHERE WHOBJT = ' *CAT +
                          &QUOTE *CAT 'P' *CAT &QUOTE *CAT ' AND +
                          WHFNAM = ' *CAT &QUOTE *CAT &PGMNAME *CAT +
                          &QUOTE *CAT ' ORDER BY WHPNAM')

             SQL        SQLSTMT(&SQLSTMT)

             RETURN


 ERROR:      RCVMSG     MSGDTA(&MSGDTA) MSGID(&MSGID) MSGF(&MSGF)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA)

             ENDPGM

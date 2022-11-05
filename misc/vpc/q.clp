             PGM        PARM(&FILELIB)

             DCL        VAR(&FILELIB)  TYPE(*CHAR) LEN(20)
             DCL        VAR(&FILENAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBNAME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGID)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA)   TYPE(*CHAR) LEN(256)

             MONMSG     MSGID(CPF0000 CPA0000) EXEC(GOTO CMDLBL(ERROR))

             CHGVAR     VAR(&FILENAME) VALUE(%SST(&FILELIB 1 10))
             CHGVAR     VAR(&LIBNAME)  VALUE(%SST(&FILELIB 11 10))
             RUNQRY     QRY(*NONE) QRYFILE((&LIBNAME/&FILENAME)) +
                          OUTTYPE(*DISPLAY) OUTFORM(*DETAIL) +
                          RCDSLT(*YES)
             GOTO       CMDLBL(ENDPGM)

 ERROR:      RCVMSG     MSGDTA(&MSGDTA) MSGID(&MSGID) MSGF(&MSGF)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA)

 ENDPGM:     ENDPGM

             PGM

             DCL        VAR(&DATEDMYY) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DATEYYMD) TYPE(*CHAR) LEN(8)


             SNDUSRMSG  MSG(DATE) MSGRPY(&DATEDMYY)

             CVTDAT     DATE(&DATEDMYY) TOVAR(&DATEYYMD) +
                          FROMFMT(*DMYY) TOFMT(*YYMD) TOSEP(*NONE)
             MONMSG     MSGID(CPF0550 CPF0551 CPF0552 CPF0553 +
                          CPF0554 CPF0555 CPF0556 CPF0557) +
                          EXEC(GOTO CMDLBL(ERROR))

             GOTO       CMDLBL(ENDPGM)

 ERROR:      SNDPGMMSG  MSG('Invalid date')

 ENDPGM:     ENDPGM

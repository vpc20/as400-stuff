             PGM        PARM(&PGMNAME)

             DCL        VAR(&PGMNAME)    TYPE(*CHAR) LEN(10)

             INCLUDE    SRCMBR(ERRVAR)

             DSPPGMREF  PGM(*LIBL/&PGMNAME) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/QADSPPGM)
             MONMSG     MSGID(CPF3033) EXEC(CLRPFM +
                          FILE(QTEMP/QADSPPGM))

             INCLUDE    SRCMBR(ERRRTN)

             ENDPGM

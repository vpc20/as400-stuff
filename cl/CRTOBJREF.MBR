             PGM        PARM(&LIB)

             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             INCLUDE    SRCMBR(ERRVAR)

             DSPPGMREF  PGM(&LIB/*ALL) OUTPUT(*OUTFILE) +
                          OBJTYPE(*ALL) OUTFILE(QTEMP/TMPPGMREF)
             CPYF       FROMFILE(QTEMP/TMPPGMREF) TOFILE(PGMREFPF) +
                          MBROPT(*REPLACE) INCREL((*IF WHFNAM *NL +
                          'A')) ERRLVL(*NOMAX)

             INCLUDE    SRCMBR(ERRRTN)

             ENDPGM

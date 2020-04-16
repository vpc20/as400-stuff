             PGM        PARM(&PGM)

             DCL        VAR(&PGM)        TYPE(*CHAR) LEN(20)
             DCL        VAR(&PGMNAME)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB)        TYPE(*CHAR) LEN(10)

             INCLUDE    SRCMBR(ERRVAR)

             CHGVAR     VAR(&PGMNAME) VALUE(%SST(&PGM 1 10))
             CHGVAR     VAR(&LIB)     VALUE(%SST(&PGM 11 10))

             DSPPGMREF  PGM(&LIB/&PGMNAME) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/QADSPPGM)
             OVRDBF     FILE(QADSPPGM) TOFILE(QTEMP/QADSPPGM)
             CALL       PGM(WRKPGMREFC) PARM(&PGM)

             INCLUDE    SRCMBR(ERRRTN)

             ENDPGM

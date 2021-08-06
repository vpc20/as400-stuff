             PGM        PARM(&PGMNAME)

             DCL        VAR(&PGMNAME) TYPE(*CHAR) LEN(10)

             INCLUDE    SRCMBR(ERRVAR)

             CALL       PGM(WRKCONFCBL) PARM(&PGMNAME)
             RETURN

             INCLUDE    SRCMBR(ERRRTN)

             ENDPGM

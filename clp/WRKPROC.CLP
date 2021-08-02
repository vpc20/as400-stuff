             PGM        PARM(&SCHEMA)

             DCL        VAR(&SCHEMA)     TYPE(*CHAR) LEN(10)


             INCLUDE    SRCMBR(ERRVAR)

       /***  XXXXXXXXXXXXXXXXXXX                                    ***/
             DLTF       FILE(QTEMP/PROCS)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(WRKPROCRPG) PARM(&SCHEMA)

             RETURN

             INCLUDE    SRCMBR(ERRRTN)

             ENDPGM

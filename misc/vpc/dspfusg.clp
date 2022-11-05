             PGM        PARM(&PGMLIB)

             DCL        VAR(&PGMLIB)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&PGMNAME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBNAME)  TYPE(*CHAR) LEN(10)

             DCL        VAR(&MSGID)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA)   TYPE(*CHAR) LEN(256)

             MONMSG     MSGID(CPF0000 CPA0000) EXEC(GOTO CMDLBL(ERROR))


             CHGVAR     VAR(&PGMNAME)  VALUE(%SST(&PGMLIB 1 10))
             CHGVAR     VAR(&LIBNAME)  VALUE(%SST(&PGMLIB 11 10))

             DSPPGMREF  PGM(&LIBNAME/&PGMNAME) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/ZPGMREF1)


             OPNQRYF    FILE((QTEMP/ZPGMREF1)) KEYFLD((WHPNAM) +
                          (WHFNAM))
             DLTF       FILE(QTEMP/ZPGMREF)
             MONMSG     MSGID(CPF0000)
             CPYFRMQRYF FROMOPNID(ZPGMREF1) TOFILE(QTEMP/ZPGMREF) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             CLOF       OPNID(ZPGMREF1)

             OVRDBF     FILE(QADSPPGM) TOFILE(QTEMP/ZPGMREF)
             CALL       PGM(DSPFUSGCBL) PARM(&PGMNAME &LIBNAME)
             DLTOVR     FILE(QADSPPGM)

             RETURN


 ERROR:      RCVMSG     MSGDTA(&MSGDTA) MSGID(&MSGID) MSGF(&MSGF)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA)

             ENDPGM

             PGM        PARM(&PGMNAME)

             DCL        VAR(&PGMNAME)    TYPE(*CHAR) LEN(10)

             INCLUDE    SRCMBR(ERRVAR)
             MONMSG     MSGID(CPF0000)

             /* create qadsppgm in qtemp                 */
             /* not authorized to create dup of qadsppgm */
             IF         COND(&PGMNAME = ' ') THEN(DO)
             DSPPGMREF  PGM(QCMDEXC1) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/QADSPPGM)
             CLRPFM     FILE(QTEMP/QADSPPGM)
             ENDDO
             ELSE       CMD(DO)
             DSPPGMREF  PGM(&PGMNAME) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/QADSPPGM)
             ENDDO

             OVRDBF     FILE(QADSPPGM) TOFILE(QTEMP/QADSPPGM)
             CALL       PGM(WRKPGMREFC) PARM(&PGMNAME)

             INCLUDE    SRCMBR(ERRRTN)

             ENDPGM

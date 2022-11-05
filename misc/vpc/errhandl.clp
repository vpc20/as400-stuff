             PGM

             DCL        VAR(&MSGID)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(256)

             MONMSG     MSGID(CPF0000 CPF9999) EXEC(GOTO CMDLBL(ERROR))

             CHKTAP     DEV(TAPXX)

 /*        ? CPYF     ??FROMFILE(QTEMP/CPACPF) +     */
 /*                   ??TOFILE(QTEMP/CPACPFX) +      */
 /*                       MBROPT(*REPLACE)           */

 ERROR:      RCVMSG     MSGTYPE(*DIAG) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF)
             IF         COND(&MSGID *NE ' ') THEN(DO)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA)
             GOTO       CMDLBL(ERROR)
             ENDDO
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA)

             ENDPGM

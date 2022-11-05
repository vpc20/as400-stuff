             PGM

             DCLF       FILE(TEST3DSP)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(80)

             CHGVAR     VAR(&PGMQ) VALUE('TEST3CL')

 LOOP:       SNDRCVF    RCDFMT(REC1)

             IF         COND(&IN03 = '1') THEN(RETURN)

             RMVMSG     CLEAR(*ALL)
             CHGVAR     VAR(&IN80) VALUE('1')
             SNDF       RCDFMT(MSGCTL)

             SNDPGMMSG  MSG(MESSAGE1) TOPGMQ(*SAME)
             SNDF       RCDFMT(MSGCTL)
             SNDPGMMSG  MSG(MESSAGE2) TOPGMQ(*SAME)
             SNDF       RCDFMT(MSGCTL)

             GOTO       CMDLBL(LOOP)

             ENDPGM

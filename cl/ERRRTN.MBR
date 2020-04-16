
 ERROR:
             RCVMSG     MSGTYPE(*COMP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF)
             IF         COND(&MSGID *NE ' ') THEN(SNDPGMMSG +
                          MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA))

             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF)
             IF         COND(&MSGID *NE ' ') THEN(SNDPGMMSG +
                          MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA))


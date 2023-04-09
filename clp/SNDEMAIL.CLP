01  DCL VAR(&EMAIL1) TYPE(*CHAR) LEN(50)
02  DCL VAR(&EMAIL2) TYPE(*CHAR) LEN(50)
03  DCL VAR(&STRING) TYPE(*CHAR) LEN(256)
04  DCL VAR(&LENGTH) TYPE(*DEC) LEN(15 5)

05  CHGVAR VAR(&EMAIL1) VALUE('simon@rpgpgm.com')
06  CHGVAR VAR(&EMAIL2) VALUE('someone.else@rpgpgm.com')

07  CHGVAR VAR(&STRING) +
             VALUE('SNDSMTPEMM RCP((' || &EMAIL1 |< ' *PRI) +
                                   (' || &EMAIL2 |< ' *PRI)) +
                    SUBJECT(''This is a test'') +
                    NOTE(''This email is a test'')')

08  CHGVAR VAR(&LENGTH) VALUE(%LEN(&STRING))
09  CALL PGM(QCMDEXC) PARM(&STRING &LENGTH)
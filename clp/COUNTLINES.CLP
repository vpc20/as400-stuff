             PGM        PARM(&LIB &FILE &MBR &COUNT)

             DCLF       FILE(SRCPF112)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COUNT) TYPE(*INT)
             DCL        VAR(&EOF) TYPE(*LGL) VALUE('0')

             OVRDBF     FILE(SRCPF112) TOFILE(&LIB/&FILE) MBR(&MBR)
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(CHGVAR VAR(&EOF) +
                          VALUE('1'))

             DOUNTIL    COND(&EOF)
             IF         COND(&SRCSTMT *NE ' ') THEN(CHGVAR VAR(&COUNT) +
                          VALUE(&COUNT + 1))
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(CHGVAR VAR(&EOF) +
                          VALUE('1'))
             ENDDO

             ENDPGM

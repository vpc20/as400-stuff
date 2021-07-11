             PGM        PARM(&LIB &FILE &MBR &COUNT)

             DCLF       FILE(SRCPF112)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COUNT) TYPE(*INT)
             DCL        VAR(&EOF) TYPE(*LGL) VALUE('0')
             DCL        VAR(&TEMP) TYPE(*CHAR) LEN(1)

             OVRDBF     FILE(SRCPF112) TOFILE(&LIB/&FILE) MBR(&MBR)
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(CHGVAR VAR(&EOF) +
                          VALUE('1'))

             DOUNTIL    COND(&EOF)
             CHGVAR     VAR(&TEMP) VALUE(%TRIM(&SRCSTMT))
             IF         COND(&SRCSTMT *NE ' ') THEN(DO)
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
             ENDDO

             RCVF
             MONMSG     MSGID(CPF0864) EXEC(CHGVAR VAR(&EOF) +
                          VALUE('1'))
             ENDDO

             ENDPGM

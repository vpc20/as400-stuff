             PGM        PARM(&SQLSTMT)

             DCL        VAR(&SQLSTMT) TYPE(*CHAR) LEN(5000)

             INCLUDE    SRCMBR(ERRVAR)

             DLTF       FILE(QTEMP/QTEMPSRC)
             MONMSG     MSGID(CPF0000)

             CRTSRCPF   FILE(QTEMP/QTEMPSRC)
             ADDPFM     FILE(QTEMP/QTEMPSRC) MBR(QTEMPSQL)

             OVRDBF     FILE(SRCPF) TOFILE(QTEMP/QTEMPSRC) +
                          MBR(QTEMPSQL)
             CALL       PGM(SQLCBL) PARM(&SQLSTMT)

             RUNSQLSTM  SRCFILE(QTEMP/QTEMPSRC) SRCMBR(QTEMPSQL) +
                          COMMIT(*NONE)
             SNDPGMMSG  MSG('SQL statment executed.')
             RETURN

             INCLUDE    SRCMBR(ERRRTN)

             ENDPGM

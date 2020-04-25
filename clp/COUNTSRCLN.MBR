             PGM        PARM(&LIB &FILE)

             DCLF       FILE(QAFDMBRL) RCDFMT(QWHFDML)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COUNT) TYPE(*INT)
             DCL        VAR(&TOTCOUNT) TYPE(*INT)
             DCL        VAR(&TOTCOUNTX) TYPE(*CHAR) LEN(7)
             DCL        VAR(&EOF) TYPE(*LGL) VALUE('0')

             /* Get member list and output to temporary file */
             DSPFD      FILE(&LIB/&FILE) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/TEMPFD)
             OVRDBF     FILE(QAFDMBRL) TOFILE(QTEMP/TEMPFD)
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(CHGVAR VAR(&EOF) +
                          VALUE('1'))

             /* Process each member of file */
             DOUNTIL    COND(&EOF)
             CALL       PGM(COUNTMBRLN) PARM(&LIB &FILE &MLNAME &COUNT)
             CHGVAR     VAR(&TOTCOUNT) VALUE(&TOTCOUNT + &COUNT)

             RCVF
             MONMSG     MSGID(CPF0864) EXEC(CHGVAR VAR(&EOF) +
                          VALUE('1'))
             ENDDO

             CHGVAR     VAR(&TOTCOUNTX) VALUE(&TOTCOUNT)
             SNDPGMMSG  MSG(&TOTCOUNTX)

             ENDPGM

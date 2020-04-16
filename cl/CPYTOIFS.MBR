             PGM        PARM(&SRCFILE &MBR)

             DCLF       FILE(QAFDMBR)

             DCL        VAR(&SRCFILE)    TYPE(*CHAR) LEN(20)
             DCL        VAR(&MBR)        TYPE(*CHAR) LEN(10)

             DCL        VAR(&FILE)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB)        TYPE(*CHAR) LEN(10)
             DCL        VAR(&FROMMBR)    TYPE(*CHAR) LEN(512)
             DCL        VAR(&TOSTMF)     TYPE(*CHAR) LEN(512)

             INCLUDE    SRCMBR(ERRVAR)

             CHGVAR     VAR(&FILE) VALUE(%SST(&SRCFILE 1 10))
             CHGVAR     VAR(&LIB)  VALUE(%SST(&SRCFILE 11 10))

       /***  Get library name   ***/
             IF         COND(&LIB *EQ '*LIBL' *OR &MBR *EQ +
                          '*FIRST') THEN(DO)
             DLTF       FILE(QTEMP/FDTEMP)
             MONMSG     MSGID(CPF0000)
             RCVMSG     MSGTYPE(*COMP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF)
             DSPFD      FILE(&LIB/&FILE) TYPE(*MBR) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/FDTEMP)
             OVRDBF     FILE(QAFDMBR) TOFILE(QTEMP/FDTEMP)
             RCVF       DEV(*FILE) RCDFMT(QWHFDMBR)

             IF         COND(&LIB *EQ '*LIBL') THEN(DO)
             CHGVAR     VAR(&LIB) VALUE(&MBLIB)
             ENDDO
             IF         COND(&MBR *EQ '*FIRST') THEN(DO)
             CHGVAR     VAR(&MBR) VALUE(&MBNAME)
             ENDDO
             ENDDO

             CHGVAR     VAR(&FROMMBR)                                +
                        VALUE('/QSYS.LIB/'                           +
                        *TCAT &LIB                                   +
                        *TCAT '.LIB/'                                +
                        *TCAT &FILE                                  +
                        *TCAT '.FILE/'                               +
                        *TCAT &MBR                                   +
                        *TCAT '.MBR')
             CHGVAR     VAR(&TOSTMF) VALUE(&MBR *TCAT '.TXT')

             CPYTOSTMF  FROMMBR(&FROMMBR) TOSTMF(&TOSTMF) +
                          STMFOPT(*REPLACE) STMFCODPAG(*PCASCII)
             RCVMSG     MSGTYPE(*COMP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA)
             RETURN

             INCLUDE    SRCMBR(ERRRTN)

             ENDPGM

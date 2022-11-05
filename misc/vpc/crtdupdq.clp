             PGM        PARM(&DTAQLIB &TGTLIB)

             DCL        VAR(&DTAQLIB)    TYPE(*CHAR) LEN(20)
             DCL        VAR(&DTAQNAME)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TGTLIB)     TYPE(*CHAR) LEN(10)

             DCL        VAR(&RCVVAR)     TYPE(*CHAR) LEN(80)
             DCL        VAR(&RCVVARLEN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&FORMATNAME) TYPE(*CHAR) LEN(8)

             DCL        VAR(&TYPE)       TYPE(*CHAR) LEN(4)
             DCL        VAR(&FORCE)      TYPE(*CHAR) LEN(4)
             DCL        VAR(&MAXLEN)     TYPE(*DEC)  LEN(5)
             DCL        VAR(&MAXLENX)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&SEQ)        TYPE(*CHAR) LEN(6)
             DCL        VAR(&KEYLEN)     TYPE(*DEC)  LEN(3)
             DCL        VAR(&KEYLENX)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&SENDERID)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&TEXT)       TYPE(*CHAR) LEN(50)

             DCL        VAR(&MSGID)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA)   TYPE(*CHAR) LEN(256)

             MONMSG     MSGID(CPF0000 CPA0000) EXEC(GOTO CMDLBL(ERROR))

             CHGVAR     VAR(&DTAQNAME) VALUE(%SST(&DTAQLIB 1 10))

             CHGVAR     VAR(%BIN(&RCVVARLEN)) VALUE(80)
             CHGVAR     VAR(&FORMATNAME) VALUE('RDQD0100')

      /***   Retrieve data queue description   ***/

             CALL       PGM(QMHQRDQD) PARM(&RCVVAR &RCVVARLEN +
                          &FORMATNAME &DTAQLIB)

             CHGVAR     VAR(&TYPE) VALUE('*STD')

             CHGVAR     VAR(&MAXLENX) VALUE(%SST(&RCVVAR 9 4))
             CHGVAR     VAR(&MAXLEN) VALUE(%BIN(&MAXLENX))

             IF         COND(%SST(&RCVVAR 19 1) *EQ 'Y') THEN(CHGVAR +
                          VAR(&FORCE) VALUE('*YES'))
             ELSE       CMD(IF COND(%SST(&RCVVAR 19 1) *EQ 'N') +
                          THEN(CHGVAR VAR(&FORCE) VALUE('*NO')))

             IF         COND(%SST(&RCVVAR 17 1) *EQ 'F') THEN(CHGVAR +
                          VAR(&SEQ) VALUE('*FIFO'))
             ELSE       CMD(IF COND(%SST(&RCVVAR 17 1) *EQ 'K') +
                          THEN(CHGVAR VAR(&SEQ) VALUE('*KEYED')))
             ELSE       CMD(IF COND(%SST(&RCVVAR 17 1) *EQ 'L') +
                          THEN(CHGVAR VAR(&SEQ) VALUE('*LIFO')))

             IF         COND(%SST(&RCVVAR 18 1) *EQ 'Y') THEN(CHGVAR +
                          VAR(&SENDERID) VALUE('*YES'))
             ELSE       CMD(IF COND(%SST(&RCVVAR 18 1) *EQ 'N') +
                          THEN(CHGVAR VAR(&SENDERID) VALUE('*NO')))

             CHGVAR     VAR(&TEXT) VALUE(%SST(&RCVVAR 20 50))

             CHGVAR     VAR(&KEYLENX) VALUE(%SST(&RCVVAR 13 4))
             CHGVAR     VAR(&KEYLEN) VALUE(%BIN(&KEYLENX))


      /***   Create new data queue based on the existing one   ***/

             IF         COND(&TYPE = '*STD' *AND &SEQ = '*KEYED') +
                          THEN(CRTDTAQ DTAQ(&TGTLIB/&DTAQNAME) +
                          TYPE(&TYPE) MAXLEN(&MAXLEN) FORCE(&FORCE) +
                          SEQ(&SEQ) KEYLEN(&KEYLEN) +
                          SENDERID(&SENDERID) TEXT(&TEXT))
             ELSE       CMD(CRTDTAQ DTAQ(&TGTLIB/&DTAQNAME) +
                          TYPE(&TYPE) MAXLEN(&MAXLEN) FORCE(&FORCE) +
                          SEQ(&SEQ) SENDERID(&SENDERID) TEXT(&TEXT))

             SNDPGMMSG  MSG('Data queue' *BCAT &DTAQNAME *BCAT +
                          'created in library' *BCAT &TGTLIB *TCAT '.')
             RETURN


 ERROR:      RCVMSG     MSGTYPE(*DIAG) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF)
             MONMSG     MSGID(CPF0000)

             IF         COND(&MSGID *NE ' ') THEN(DO)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(ERROR)
             ENDDO

             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF)
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA)
             MONMSG     MSGID(CPF0000)

 ENDPGM:     ENDPGM

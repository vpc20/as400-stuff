             PGM

             DCLF       FILE(TEMPFILE1)

             DCL        VAR(&JOBNAME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNBR)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&SPLFNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SPLNBRX) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SPLNBR)  TYPE(*DEC)  LEN(4)
             DCL        VAR(&I) TYPE(*DEC) LEN(2)

             DCL        VAR(&MSGID)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(256)

             MONMSG     MSGID(CPF0000 CPF9999) EXEC(GOTO CMDLBL(ERROR))

      /***   Get job attributes   ***/
             RTVJOBA    JOB(&JOBNAME) USER(&USER) NBR(&JOBNBR)

      /***   Get list of spooled files and output to temp file  ***/
             WRKSPLF    OUTPUT(*PRINT)

             DLTF       FILE(QTEMP/TEMPFILE1)
             MONMSG     MSGID(CPF0000)
             CRTPF      FILE(QTEMP/TEMPFILE1) RCDLEN(145)
             CPYSPLF    FILE(QPRTSPLF) TOFILE(QTEMP/TEMPFILE1) +
                          JOB(&JOBNBR/&USER/&JOBNAME) SPLNBR(*LAST)
             DLTSPLF    FILE(QPRTSPLF) JOB(&JOBNBR/&USER/&JOBNAME) +
                          SPLNBR(*LAST)

 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDJOB))
             CHGVAR     VAR(&SPLFNAME) VALUE(%SST(&TEMPFILE1 2 10))

             IF         COND(&SPLFNAME *EQ 'QPJOBLOG') THEN(DO)
             CHGVAR     VAR(&JOBNBR) VALUE(%SST(&TEMPFILE1 117 6))
             CHGVAR     VAR(&USER) VALUE(%SST(&TEMPFILE1 13 10))
             CHGVAR     VAR(&JOBNAME) VALUE(%SST(&TEMPFILE1 106 10))
             CHGVAR     VAR(&SPLNBRX) VALUE(%SST(&TEMPFILE1 101 4))
             CHGVAR     VAR(&I) VALUE(0)
 NEXTI:      CHGVAR     VAR(&I) VALUE(&I + 1)
             IF         COND(&I > 4) THEN(GOTO CMDLBL(ENDCVT))
             IF         COND(%SST(&SPLNBRX &I 1) *EQ ' ') +
                          THEN(CHGVAR VAR(%SST(&SPLNBRX &I 1)) +
                          VALUE('0'))
             GOTO       CMDLBL(NEXTI)

 ENDCVT:     CHGVAR     VAR(&SPLNBR) VALUE(&SPLNBRX)
             SNDPGMMSG  MSG('QPJOBLOG deleted - Job No :' *BCAT +
                          &JOBNBR *BCAT 'User : ' *BCAT &USER +
                          *BCAT 'Job Nm :' *BCAT &JOBNAME +
                          *BCAT 'Spl No :' *BCAT &SPLNBRX)
             DLTSPLF    FILE(QPJOBLOG) JOB(&JOBNBR/&USER/&JOBNAME) +
                          SPLNBR(&SPLNBR)
             ENDDO

             GOTO       CMDLBL(LOOP)

 ENDJOB:     RETURN

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

             PGM        PARM(&FILE &MBR &CSVFILE &MBROPT)

             DCLF       FILE(QAFDRFMT)

             DCL        VAR(&FILE)       TYPE(*CHAR) LEN(20)
             DCL        VAR(&MBR)        TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSVFILE)    TYPE(*CHAR) LEN(20)
             DCL        VAR(&MBROPT)     TYPE(*CHAR) LEN(8)

             DCL        VAR(&FILENM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBNM)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSVFILENM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSVLIBNM)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&RCDLEN)     TYPE(*DEC)  LEN(6 0)

             INCLUDE    SRCMBR(ERRVAR)

       /***  get library and file names  ***/
             CHGVAR     VAR(&FILENM) VALUE(%SST(&FILE  1 10))
             CHGVAR     VAR(&LIBNM)  VALUE(%SST(&FILE 11 10))
             CHGVAR     VAR(&CSVFILENM) VALUE(%SST(&CSVFILE  1 10))
             CHGVAR     VAR(&CSVLIBNM)  VALUE(%SST(&CSVFILE 11 10))

       /***  create the csv file (flat file)                        ***/
       /***  length should be length of the input file plus commas  ***/
       /***  and quotation marks                                    ***/
             DLTF       FILE(QTEMP/FDTEMP)
             MONMSG     MSGID(CPF0000)
             RCVMSG     MSGTYPE(*COMP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF)
             DSPFD      FILE(&LIBNM/&FILENM) TYPE(*RCDFMT) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/FDTEMP)
             OVRDBF     FILE(QAFDRFMT) TOFILE(QTEMP/FDTEMP)
             RCVF       DEV(*FILE) RCDFMT(QWHFDFMT)
             CHGVAR     VAR(&RCDLEN) VALUE(&RFLEN + (&RFFLDN * 3 - 1))

             IF         COND(&CSVLIBNM *EQ '*SAME') THEN(CHGVAR +
                          VAR(&CSVLIBNM) VALUE(&RFLIB))
             CHKOBJ     OBJ(&CSVLIBNM/&CSVFILENM) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&CSVLIBNM/&CSVFILENM) RCDLEN(&RCDLEN))

       /***  convert to csv  ***/
             CPYTOIMPF  FROMFILE(&LIBNM/&FILENM &MBR) +
                          TOFILE(&CSVLIBNM/&CSVFILENM) MBROPT(&MBROPT)
             RCVMSG     MSGTYPE(*COMP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA)

             RETURN

             INCLUDE    SRCMBR(ERRRTN)

             ENDPGM

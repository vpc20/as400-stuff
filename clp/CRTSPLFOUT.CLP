             PGM        PARM(&USER &OUTQ &FORMTYP &USRDTA &JOB +
                          &OUTFILE &OUTMBR)

             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQ)    TYPE(*CHAR) LEN(20)
             DCL        VAR(&FORMTYP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRDTA)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(26)
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(20)
             DCL        VAR(&OUTMBR)  TYPE(*CHAR) LEN(20)

             DCL        VAR(&FILENM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBNM)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBRNM)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBROPT)     TYPE(*CHAR) LEN(8)

             INCLUDE    SRCMBR(ERRVAR)

       /***  get library, filename, mbr name and mbr option   ***/
             CHGVAR     VAR(&FILENM) VALUE(%SST(&OUTFILE  1 10))
             CHGVAR     VAR(&LIBNM)  VALUE(%SST(&OUTFILE 11 10))
             CHGVAR     VAR(&MBRNM)  VALUE(%SST(&OUTMBR   3 10))
             CHGVAR     VAR(&MBROPT) VALUE(%SST(&OUTMBR  13  8))

             CRTDUPOBJ  OBJ(SPLFOUTF) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBNM) NEWOBJ(&FILENM)
             MONMSG     MSGID(CPF2130)
             IF         COND(&MBROPT *EQ '*REPLACE') THEN(CLRPFM +
                          FILE(&LIBNM/&FILENM) MBR(&MBRNM))

             OVRDBF     FILE(SPLFOUTF) TOFILE(&LIBNM/&FILENM) +
                          MBR(&MBRNM)
             CALL CRTSPLFCBL PARM(&USER &OUTQ &FORMTYP &USRDTA &JOB)

             RETURN

             INCLUDE    SRCMBR(ERRRTN)

             ENDPGM

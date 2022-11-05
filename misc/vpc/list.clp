             PGM        PARM(&FILELIST)

             DCL        VAR(&FILELIST) TYPE(*CHAR) LEN(102)
             DCL        VAR(&COUNTX)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&COUNTN)   TYPE(*DEC)  LEN(4)

             CHGVAR     VAR(&COUNTX) VALUE(%SST(&FILELIST 1 2))
             CHGVAR     VAR(&COUNTN) VALUE(%BIN(&COUNTX))
             CHGVAR     VAR(&COUNTN) VALUE(%BIN(&COUNTX))

             ENDPGM

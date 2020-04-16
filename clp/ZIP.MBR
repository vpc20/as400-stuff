             PGM        PARM(&ZIPFILE &FILELIST &DIR)

             DCL        VAR(&DIR)        TYPE(*CHAR) LEN(128)
             DCL        VAR(&ZIPFILE)    TYPE(*CHAR) LEN(32)
             DCL        VAR(&FILELIST)   TYPE(*CHAR) LEN(3202)

             DCL        VAR(&FILESTR)    TYPE(*CHAR) LEN(4000) VALUE(' ')
             DCL        VAR(&QSHCMD)     TYPE(*CHAR) LEN(4000)
             DCL        VAR(&LSTCOUNTX)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&LASTI)      TYPE(*INT)
             DCL        VAR(&STRPOS)     TYPE(*DEC)  LEN(3)
             DCL        VAR(&I)          TYPE(*INT)

             INCLUDE    SRCMBR(ERRVAR)

       /***  change directory  ***/
             IF         COND(&DIR *NE '*CURDIR') THEN(CHDIR DIR(&DIR))

       /***  get number of filenames in list  ***/
             CHGVAR     VAR(&LSTCOUNTX) VALUE(%SST(&FILELIST 1 2))
             CHGVAR     VAR(&LASTI) +
                        VALUE((%BIN(&LSTCOUNTX) - 1) * 32 + 3)

       /***  build the string containing all the file names  ***/
             DOFOR      VAR(&I) FROM(3) TO(&LASTI) BY(32)
             CHGVAR     VAR(&FILESTR) +
                        VALUE(&FILESTR *BCAT %SST(&FILELIST &I 32))
             ENDDO

       /***  zip the files  ***/
             CHGVAR     VAR(&QSHCMD) VALUE('jar -cvfM ' *CAT &ZIPFILE +
                          *TCAT &FILESTR)
             QSH        CMD(&QSHCMD)
             RETURN

             INCLUDE    SRCMBR(ERRRTN)

             ENDPGM

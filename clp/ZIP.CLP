             PGM        PARM(&ZIPFILE &FILELIST)

             DCL        VAR(&ZIPFILE)    TYPE(*CHAR) LEN(80)
             DCL        VAR(&FILELIST)   TYPE(*CHAR) LEN(4002)

             DCL        VAR(&FILESTR)    TYPE(*CHAR) LEN(4050) VALUE(' ')
             DCL        VAR(&QSHCMD)     TYPE(*CHAR) LEN(4140)
             DCL        VAR(&LSTCOUNT)   TYPE(*INT)
             DCL        VAR(&I)          TYPE(*INT)
             DCL        VAR(&STRPOS)     TYPE(*INT)

             INCLUDE    SRCMBR(ERRVAR)

       /***  get number of filenames in list  ***/
             CHGVAR     VAR(&LSTCOUNT) VALUE(%BINARY(&FILELIST 1 2))

       /***  build the string containing all the file names  ***/
             DOFOR      VAR(&I) FROM(1) TO(&LSTCOUNT)
             CHGVAR     VAR(&STRPOS) VALUE((&I - 1) * 80 + 3)
             CHGVAR     VAR(&FILESTR) +
                        VALUE(&FILESTR *BCAT %SST(&FILELIST &STRPOS 80))
             ENDDO

       /***  zip the files  ***/
             CHGVAR     VAR(&QSHCMD) VALUE('jar -cvfM ' *CAT &ZIPFILE +
                          *TCAT &FILESTR)
             QSH        CMD(&QSHCMD)
             RETURN

             INCLUDE    SRCMBR(ERRRTN)

             ENDPGM

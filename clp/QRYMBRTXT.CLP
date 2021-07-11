             PGM        PARM(&FILE &SRTXT)

             DCL        VAR(&FILE)       TYPE(*CHAR) LEN(20)
             DCL        VAR(&SRTXT)      TYPE(*CHAR) LEN(30)

             DCL        VAR(&FILENM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBNM)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&SQLSTMT)    TYPE(*CHAR) LEN(1024)
             DCL        VAR(&QT)         TYPE(*CHAR) LEN(1) VALUE('''')

             INCLUDE    SRCMBR(ERRVAR)

       /***  get library and file name  ***/
             CHGVAR     VAR(&FILENM) VALUE(%SST(&FILE  1 10))
             CHGVAR     VAR(&LIBNM)  VALUE(%SST(&FILE 11 10))

       /***  get member list  ***/
             DSPFD      FILE(&LIBNM/&FILENM) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/TMPFD)

             DLTF       FILE(QTEMP/TEMP1)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&SRTXT) VALUE(%LOWER(&SRTXT))
             CHGVAR     VAR(&SQLSTMT) VALUE('create table qtemp/temp1 as +
                          (select mlfile, mllib, mlname, mlfatr, mlmtxt +
                          from qtemp/tmpfd where lower(mlmtxt) like ' +
                          !! &qt !! '%' !! %trim(&srtxt) !! '%' !! &qt +
                          !! ') with data')
             RUNSQL     SQL(&SQLSTMT) COMMIT(*NONE)
             RUNQRY     QRYFILE((QTEMP/TEMP1))


             RETURN

             INCLUDE    SRCMBR(ERRRTN)

             ENDPGM

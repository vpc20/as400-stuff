             PGM        PARM(&LIB &SRTXT)

             DCL        VAR(&LIB)        TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRTXT)      TYPE(*CHAR) LEN(30)

             DCL        VAR(&SQLSTMT)    TYPE(*CHAR) LEN(1024)
             DCL        VAR(&QT)         TYPE(*CHAR) LEN(1) VALUE('''')

             INCLUDE    SRCMBR(ERRVAR)

       /***  get member list  ***/
             DLTF       FILE(QTEMP/TMPOBJD)
             MONMSG     MSGID(CPF0000)
             DSPOBJD    OBJ(&LIB/*ALL) OBJTYPE(*ALL) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/TMPOBJD)

             DLTF       FILE(QTEMP/TEMP1)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&SRTXT) VALUE(%LOWER(&SRTXT))
             CHGVAR     VAR(&SQLSTMT) VALUE('create table qtemp/temp1 as +
                          (select odlbnm, odobnm, odobtp, odobat, odobtx +
                          from qtemp/tmpobjd where lower(odobtx) like ' +
                          !! &qt !! '%' !! %trim(&srtxt) !! '%' !! &qt +
                          !! ') with data')
             RUNSQL     SQL(&SQLSTMT) COMMIT(*NONE)
             RUNQRY     QRYFILE((QTEMP/TEMP1))


             RETURN

             INCLUDE    SRCMBR(ERRRTN)

             ENDPGM

             PGM

             DCL        VAR(&DTAQNM) TYPE(*CHAR) LEN(10) +
                          VALUE('TESTDTAQ1')
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10) +
                          VALUE('KIBVICTOR')
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(4 0) VALUE(1024)
             DCL        VAR(&FLD) TYPE(*CHAR) LEN(1024)

             CALL       PGM(QCLRDTAQ) PARM(&DTAQNM &LIB)

             CHGVAR     VAR(&FLD) VALUE('Sample data queue data')
             CALL       PGM(QSNDDTAQ) PARM(&DTAQNM &LIB &FLDLEN &FLD)

             ENDPGM

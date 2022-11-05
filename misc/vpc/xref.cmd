             CMD        PROMPT('Cross Reference')

             PARM       KWD(FILE) TYPE(QUAL1) MIN(1) PROMPT('Filename')
             PARM       KWD(SELALL) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(Y) VALUES(Y N) PROMPT('Select all +
                          programs')
             PARM       KWD(REFRESH) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('Refresh XREF +
                          Database')
             PARM       KWD(USAGE) TYPE(ELEM1) PMTCTL(PMTCTL1) +
                          PROMPT('Usage')

 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library')

 ELEM1:      ELEM       TYPE(*CHAR) LEN(1) RSTD(*YES) DFT(Y) +
                          VALUES(Y N) PROMPT('Input')
             ELEM       TYPE(*CHAR) LEN(1) RSTD(*YES) DFT(Y) +
                          VALUES(Y N) PROMPT('Output')
             ELEM       TYPE(*CHAR) LEN(1) RSTD(*YES) DFT(Y) +
                          VALUES(Y N) PROMPT('Update')

 PMTCTL1:    PMTCTL     CTL(SELALL) COND((*EQ 'N')) NBRTRUE(*EQ 1)


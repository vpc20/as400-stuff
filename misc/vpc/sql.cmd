             CMD        PROMPT('Structured Query Language')

             PARM       KWD(SQLSTMT) TYPE(*CHAR) LEN(550) MIN(1) +
                          PROMPT('SQL Statement')
             PARM       KWD(OUTPUT) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*) VALUES(* *PRINT *OUTFILE) +
                          PROMPT('Output')
             PARM       KWD(OUTFILE) TYPE(QUAL1) PMTCTL(PMTCTL1) +
                          PROMPT('File to receive output')
             PARM       KWD(OUTMBR) TYPE(ELEM1) PMTCTL(PMTCTL2) +
                          PROMPT('Output member options')

 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*CURLIB) +
                          SPCVAL((*CURLIB)) PROMPT('Library')

 ELEM1:      ELEM       TYPE(*NAME) LEN(6) DFT(*FIRST) +
                          SPCVAL((*FIRST)) PROMPT('Member to +
                          receive output')
             ELEM       TYPE(*CHAR) LEN(8) RSTD(*YES) DFT(*REPLACE) +
                          VALUES(*REPLACE *ADD) PROMPT('Replace or +
                          add records')

 PMTCTL1:    PMTCTL     CTL(OUTPUT) COND((*EQ *OUTFILE)) NBRTRUE(*EQ 1)
 PMTCTL2:    PMTCTL     CTL(OUTPUT) COND((*EQ *OUTFILE)) NBRTRUE(*EQ 1)

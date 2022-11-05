             CMD        PROMPT('Send Data Queue')

             PARM       KWD(DTAQNAME) TYPE(QUAL1) MIN(1) +
                          PROMPT('Data Queue')
             PARM       KWD(DTALEN) TYPE(*DEC) LEN(4) MIN(1) +
                          PROMPT('Data Length')
             PARM       KWD(DATA) TYPE(*CHAR) LEN(4096) MIN(1) +
                          PROMPT('Data')

 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library')


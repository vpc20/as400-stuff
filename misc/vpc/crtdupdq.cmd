             CMD        PROMPT('Create Duplicate Data Queue')
             PARM       KWD(DTAQ) TYPE(QUAL1) MIN(1) PROMPT('Data +
                          Queue Name')
             PARM       KWD(TGTLIB) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Target Library')

 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Source Library')

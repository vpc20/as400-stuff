             CMD        PROMPT('Display Data Queue')

             PARM       KWD(DTAQNAME) TYPE(QUAL1) MIN(1) +
                          PROMPT('Data Queue')

 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library')


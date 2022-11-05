             CMD        PROMPT('Display File Key Fields')
             PARM       KWD(FILE) TYPE(QUAL1) MIN(1) PROMPT('Filename')
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library')

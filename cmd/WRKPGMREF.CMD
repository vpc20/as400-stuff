             CMD        PROMPT('Work with Program References')
             PARM       KWD(PGM) TYPE(QUAL1) MIN(1) PROMPT('Program')
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library')

             CMD        PROMPT('Display File Usage')
             PARM       KWD(FILE) TYPE(QUAL1) MIN(1) PROMPT('Program +
                          Name')
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library')

             CMD        PROMPT('Hilight COBOL comments')

             PARM       KWD(FILE) TYPE(QUAL1) MIN(1) PROMPT('Filename')
             PARM       KWD(MBR) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Member')

 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library')

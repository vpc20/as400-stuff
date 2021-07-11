             CMD        PROMPT('Copy to CSV')
             PARM       KWD(FILE) TYPE(QUAL1) MIN(1) PROMPT('File')
             PARM       KWD(MBR) TYPE(*NAME) LEN(10) DFT(*FIRST) +
                          SPCVAL((*FIRST)) PROMPT('Member')
             PARM       KWD(CSVFILE) TYPE(QUAL2) MIN(1) PROMPT('CSV +
                          File')
             PARM       KWD(MBROPT) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*ADD) VALUES(*ADD *REPLACE) +
                          PROMPT('Replace or add records')
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library')
 QUAL2:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*SAME) +
                          SPCVAL((*SAME)) PROMPT('Library')

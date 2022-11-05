             CMD        PROMPT('Run FTP Script')

             PARM       KWD(RMTSYS) TYPE(*CHAR) LEN(15) +
                          DFT('172.21.51.26') PROMPT('Remote System')
             PARM       KWD(FILE) TYPE(QUAL1) PROMPT('Filename')
             PARM       KWD(MBR) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Member')
             PARM       KWD(ERRLOG) TYPE(QUAL2) PROMPT('Error Log +
                          File')

 QUAL1:      QUAL       TYPE(*NAME) LEN(10) DFT(QFTPSRC)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library')
 QUAL2:      QUAL       TYPE(*NAME) LEN(10) DFT(FTPERRLOG)
             QUAL       TYPE(*NAME) LEN(10) DFT(QTEMP) +
                          PROMPT('Library')

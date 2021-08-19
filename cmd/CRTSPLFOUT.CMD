             CMD        PROMPT('Create Spooled Files Outfile')
             PARM       KWD(USER) TYPE(*NAME) LEN(10) DFT(*CURRENT) +
                          SPCVAL((*CURRENT) ('          ')) +
                          PROMPT('User')
             PARM       KWD(OUTQ) TYPE(QUAL1) PROMPT('Output Queue')
             PARM       KWD(FORMTYP) TYPE(*NAME) LEN(10) DFT(*ALL) +
                          SPCVAL((*ALL)) PROMPT('Form Type')
             PARM       KWD(USRDTA) TYPE(*NAME) LEN(10) DFT(*ALL) +
                          SPCVAL((*ALL)) PROMPT('User Data')
             PARM       KWD(JOB) TYPE(QUAL2) PROMPT('Job Name')
             PARM       KWD(OUTFILE) TYPE(QUAL3) MIN(1) PROMPT('File +
                          to receive output')
             PARM       KWD(OUTMBR) TYPE(ELEM1) PROMPT('Output Member')

 QUAL1:      QUAL       TYPE(*NAME) LEN(10) DFT(*ALL) SPCVAL((*ALL))
             QUAL       TYPE(*NAME) LEN(10) PROMPT('Library')
 QUAL2:      QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) +
                          SPCVAL((*ALL)) PROMPT('User')
             QUAL       TYPE(*CHAR) LEN(6) PROMPT('Number')

 QUAL3:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) MIN(1) PROMPT('Library')

 ELEM1:      ELEM       TYPE(*NAME) LEN(10) DFT(*FIRST) +
                          SPCVAL((*FIRST)) PROMPT('Member to +
                          receive output')
             ELEM       TYPE(*CHAR) LEN(8) RSTD(*YES) DFT(*REPLACE) +
                          VALUES(*ADD *REPLACE) PROMPT('Replace or +
                          add records')

             CMD        PROMPT('Delete Spooled File')

             PARM       KWD(SPLFNAME) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Spooled File Name')
             PARM       KWD(SPLFNBR) TYPE(*NAME) LEN(10) DFT(*ALL) +
                          SPCVAL((*ALL)) MIN(0) PROMPT('Spooled +
                          File Number')
             PARM       KWD(JOBATTR) TYPE(ELEM1) PROMPT('Job +
                          Attributes')

 ELEM1:      ELEM       TYPE(*NAME) LEN(10) DFT(*ALL) SPCVAL((*ALL)) +
                          PROMPT('Job Name')
             ELEM       TYPE(*NAME) LEN(10) DFT(*CURRENT) +
                          SPCVAL((*CURRENT)) PROMPT('User')
             ELEM       TYPE(*NAME) LEN(10) DFT(*ALL) SPCVAL((*ALL)) +
                          PROMPT('Job Number')


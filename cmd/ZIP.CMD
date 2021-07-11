             CMD        PROMPT('Zip Files')
             PARM       KWD(ZIPFILE) TYPE(*CHAR) LEN(32) MIN(1) +
                          PROMPT('Zip File Name')
             PARM       KWD(FILE) TYPE(*CHAR) LEN(32) MIN(1) +
                          MAX(100) PROMPT('Files to Archive')
             PARM       KWD(DIR) TYPE(*CHAR) LEN(128) DFT(*CURDIR) +
                          SPCVAL((*CURDIR)) PROMPT('Directory')

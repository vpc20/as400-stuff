             CMD        PROMPT('Zip Files')
             PARM       KWD(ZIPFILE) TYPE(*CHAR) LEN(80) MIN(1) +
                          PROMPT('Zip File Name')
             PARM       KWD(FILE) TYPE(*CHAR) LEN(80) MIN(1) MAX(50) +
                          PROMPT('Files to Archive')

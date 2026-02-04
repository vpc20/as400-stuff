             CMD        PROMPT('Convert File to Excel')

             /* PARAMETER 1: QUALIFIED FILE NAME */
             PARM       KWD(FROMFILE) TYPE(Q1) MIN(1) +
                          PROMPT('File')

             /* PARAMETER 2: EXCEL FILE NAME (LENGTH 80) */
             PARM       KWD(TOXLS) TYPE(*CHAR) LEN(80) MIN(1) +
                          PROMPT('Excel Filename')

             /* QUALIFIER DEFINITION FOR FROMFILE */
 Q1:         QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) MIN(1) PROMPT('Library')

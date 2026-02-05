/*-------------------------------------------------------------------*/
/* COMMAND: MYDSPFD                                                 */
/* PURPOSE: Display File Description (Customized)                    */
/*-------------------------------------------------------------------*/
             CMD        PROMPT('Display File Description')

             PARM       KWD(FILE) TYPE(QUAL1) MIN(1) PROMPT('File')
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL) (*CURLIB)) PROMPT('Library')

             PARM       KWD(TYPE) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          DFT(*ALL) VALUES(*ALL *BASATR *ATR +
                          *ACCPTH *SELECT *JOIN *SEQ *RCDFMT *MBR +
                          *SPOOL *MBRLIST *CST *TRG) MIN(0) MAX(10) +
                          PROMPT('Information type')

             PARM       KWD(OUTPUT) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*) VALUES(* *PRINT *OUTFILE) +
                          PROMPT('Output')

             PARM       KWD(FILEATR) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          DFT(*ALL) VALUES(*ALL *DSPF *PRTF *PF +
                          *LF) MIN(0) MAX(10) PROMPT('File attributes')

             PARM       KWD(OUTFILE) TYPE(QUAL2) MAX(1) +
                          PMTCTL(OUTFILE) PROMPT('File to receive +
                          output')
 QUAL2:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL) (*CURLIB)) PROMPT('Library')

             PARM       KWD(OUTMBR) TYPE(ELEM1) MAX(1) +
                          PMTCTL(OUTFILE) PROMPT('Output member +
                          options')
 ELEM1:      ELEM       TYPE(*NAME) LEN(10) DFT(*FIRST) +
                          SPCVAL((*FIRST) (*LAST)) PROMPT('Member')
             ELEM       TYPE(*CHAR) LEN(10) RSTD(*YES) DFT(*ADD) +
                          VALUES(*ADD *REPLACE) PROMPT('Replace or +
                          add')

             PARM       KWD(SYSTEM) TYPE(*CHAR) LEN(5) RSTD(*YES) +
                          DFT(*LCL) VALUES(*LCL *RMT *ALL) +
                          PROMPT('System')

 OUTFILE:    PMTCTL     CTL(OUTPUT) COND((*EQ *OUTFILE)) NBRTRUE(*EQ 1)

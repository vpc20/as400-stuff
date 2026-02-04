             PGM        PARM(&QUALFILE &TOXLS)

             /* ------------------------------------------------------- */
             /* Declare Input Parameters                                */
             /* ------------------------------------------------------- */
             /* &QUALFILE comes in as 20 chars: 1-10=File, 11-20=Lib    */
             DCL        VAR(&QUALFILE) TYPE(*CHAR) LEN(20)
             DCL        VAR(&TOXLS)    TYPE(*CHAR) LEN(80)

             /* ------------------------------------------------------- */
             /* Declare Local Variables to hold parsed values           */
             /* ------------------------------------------------------- */
             DCL        VAR(&FILE)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB)        TYPE(*CHAR) LEN(10)
             DCL        VAR(&SHCMD)      TYPE(*CHAR) LEN(200)

             INCLUDE    SRCMBR(ERRVAR)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(QSHELL) POSITION(*LAST)
             MONMSG     MSGID(CPC2196 CPF2103)
             RCVMSG     MSGTYPE(*COMP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF)

             CHGVAR     VAR(&FILE) VALUE(%SST(&QUALFILE 1 10))
             CHGVAR     VAR(&LIB)  VALUE(%SST(&QUALFILE 11 10))
             CHKOBJ     OBJ(&LIB/&FILE) OBJTYPE(*FILE)

             /* Convert file to spreadsheet */
             CHGVAR     VAR(&SHCMD) VALUE('java -jar +
                          /home/VPCRZKH/acsbundle.jar +
                          /plugin=cldownload /system=localhost +
                          /hostfile=' *TCAT &LIB *TCAT '/' *TCAT &FILE +
                          *BCAT '/clientfile=' *CAT &TOXLS)
             QSH        CMD(&SHCMD)

             INCLUDE    SRCMBR(ERRRTN)

             ENDPGM

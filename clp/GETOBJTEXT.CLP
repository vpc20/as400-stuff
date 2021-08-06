             PGM        PARM(&OBJLIB &OBJNAME &OBJTYPE &OBJTEXT)

             DCL        VAR(&OBJLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJTYPE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OBJTEXT) TYPE(*CHAR) LEN(50)

             RTVOBJD    OBJ(&OBJLIB/&OBJNAME) OBJTYPE(&OBJTYPE) +
                          TEXT(&OBJTEXT)
             MONMSG     MSGID(CPF9811 CPF0001) EXEC(CHGVAR VAR(&OBJTEXT) +
                          VALUE(' '))

             ENDPGM

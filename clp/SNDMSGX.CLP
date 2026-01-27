             /* REGISTER AS A STORED PROCEDURE SND_MSG */

             PGM        PARM(&MSG)

             DCL        VAR(&MSG) TYPE(*CHAR) LEN(100)
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*PRV) MSGTYPE(*INFO)

             ENDPGM

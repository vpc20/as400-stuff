             PGM

             DCLF       FILE(HELLODSPF)
             DCL        VAR(&GREETING) TYPE(*CHAR) LEN(30)

             CHGVAR     VAR(&IN03) VALUE('0')

             DOWHILE    COND(&IN03 = '0')

               CHGVAR     VAR(&NAME) VALUE(' ')
               SNDRCVF    RCDFMT(MAINRCD)

               IF         COND(&IN03 *EQ '0') THEN(DO)
                 CHGVAR     VAR(&GREETING) VALUE('Hello, ' *CAT +
                              %TRIM(&NAME))

                 SNDRCVF    RCDFMT(MSGRCD)
               ENDDO

             ENDDO

             ENDPGM

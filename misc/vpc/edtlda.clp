             PGM

             DCLF       FILE(EDTLDADSP)
             DCL        VAR(&LDAVAR) TYPE(*CHAR) LEN(1024)

             RTVDTAARA  DTAARA(*LDA) RTNVAR(&LDAVAR)

             CHGVAR     VAR(&LDA01) VALUE(%SST(&LDAVAR    1 60))
             CHGVAR     VAR(&LDA02) VALUE(%SST(&LDAVAR   61 60))
             CHGVAR     VAR(&LDA03) VALUE(%SST(&LDAVAR  121 60))
             CHGVAR     VAR(&LDA04) VALUE(%SST(&LDAVAR  181 60))
             CHGVAR     VAR(&LDA05) VALUE(%SST(&LDAVAR  241 60))
             CHGVAR     VAR(&LDA06) VALUE(%SST(&LDAVAR  301 60))
             CHGVAR     VAR(&LDA07) VALUE(%SST(&LDAVAR  361 60))
             CHGVAR     VAR(&LDA08) VALUE(%SST(&LDAVAR  421 60))
             CHGVAR     VAR(&LDA09) VALUE(%SST(&LDAVAR  481 60))
             CHGVAR     VAR(&LDA10) VALUE(%SST(&LDAVAR  561 60))
             CHGVAR     VAR(&LDA11) VALUE(%SST(&LDAVAR  601 60))
             CHGVAR     VAR(&LDA12) VALUE(%SST(&LDAVAR  661 60))
             CHGVAR     VAR(&LDA13) VALUE(%SST(&LDAVAR  721 60))
             CHGVAR     VAR(&LDA14) VALUE(%SST(&LDAVAR  781 60))
             CHGVAR     VAR(&LDA15) VALUE(%SST(&LDAVAR  841 60))
             CHGVAR     VAR(&LDA16) VALUE(%SST(&LDAVAR  801 60))
             CHGVAR     VAR(&LDA17) VALUE(%SST(&LDAVAR  961 60))
             CHGVAR     VAR(&LDA18) VALUE(%SST(&LDAVAR 1021  4))

 LOOP:       SNDRCVF    RCDFMT(DSPREC1)
             IF         COND(&IN03 *EQ '1' *OR &IN12 *EQ '1') +
                          THEN(GOTO CMDLBL(ENDJOB))

             CHGVAR     VAR(%SST(&LDAVAR    1 60)) VALUE(&LDA01)
             CHGVAR     VAR(%SST(&LDAVAR   61 60)) VALUE(&LDA02)
             CHGVAR     VAR(%SST(&LDAVAR  121 60)) VALUE(&LDA03)
             CHGVAR     VAR(%SST(&LDAVAR  181 60)) VALUE(&LDA04)
             CHGVAR     VAR(%SST(&LDAVAR  241 60)) VALUE(&LDA05)
             CHGVAR     VAR(%SST(&LDAVAR  301 60)) VALUE(&LDA06)
             CHGVAR     VAR(%SST(&LDAVAR  361 60)) VALUE(&LDA07)
             CHGVAR     VAR(%SST(&LDAVAR  421 60)) VALUE(&LDA08)
             CHGVAR     VAR(%SST(&LDAVAR  481 60)) VALUE(&LDA09)
             CHGVAR     VAR(%SST(&LDAVAR  561 60)) VALUE(&LDA10)
             CHGVAR     VAR(%SST(&LDAVAR  601 60)) VALUE(&LDA11)
             CHGVAR     VAR(%SST(&LDAVAR  661 60)) VALUE(&LDA12)
             CHGVAR     VAR(%SST(&LDAVAR  721 60)) VALUE(&LDA13)
             CHGVAR     VAR(%SST(&LDAVAR  781 60)) VALUE(&LDA14)
             CHGVAR     VAR(%SST(&LDAVAR  841 60)) VALUE(&LDA15)
             CHGVAR     VAR(%SST(&LDAVAR  801 60)) VALUE(&LDA16)
             CHGVAR     VAR(%SST(&LDAVAR  961 60)) VALUE(&LDA17)
             CHGVAR     VAR(%SST(&LDAVAR 1021  4)) VALUE(&LDA18)

             CHGDTAARA  DTAARA(*LDA) VALUE(&LDAVAR)

             GOTO       CMDLBL(LOOP)

 ENDJOB:     ENDPGM

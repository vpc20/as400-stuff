             PGM        PARM(&DAYOFWEEK)

             DCL        VAR(&DAYOFWEEK) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&QDAYOFWEEK) TYPE(*CHAR) LEN(4)

             RTVSYSVAL  SYSVAL(QDAYOFWEEK) RTNVAR(&QDAYOFWEEK)

             IF         COND(&QDAYOFWEEK *EQ '*SUN') THEN(CHGVAR +
                          VAR(&DAYOFWEEK) VALUE(1))
             IF         COND(&QDAYOFWEEK *EQ '*MON') THEN(CHGVAR +
                          VAR(&DAYOFWEEK) VALUE(2))
             IF         COND(&QDAYOFWEEK *EQ '*TUE') THEN(CHGVAR +
                          VAR(&DAYOFWEEK) VALUE(3))
             IF         COND(&QDAYOFWEEK *EQ '*WED') THEN(CHGVAR +
                          VAR(&DAYOFWEEK) VALUE(4))
             IF         COND(&QDAYOFWEEK *EQ '*THU') THEN(CHGVAR +
                          VAR(&DAYOFWEEK) VALUE(5))
             IF         COND(&QDAYOFWEEK *EQ '*FRI') THEN(CHGVAR +
                          VAR(&DAYOFWEEK) VALUE(6))
             IF         COND(&QDAYOFWEEK *EQ '*SAT') THEN(CHGVAR +
                          VAR(&DAYOFWEEK) VALUE(7))


             ENDPGM

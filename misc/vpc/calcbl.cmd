       IDENTIFICATION DIVISION.
       PROGRAM-ID.    CALCBL.
       AUTHOR.        VPC.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.  IBM-AS400.
       OBJECT-COMPUTER.  IBM-AS400.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT CALDSP-FILE   ASSIGN  TO WORKSTATION-CALDSP
                  ORGANIZATION  IS         TRANSACTION
                  CONTROL-AREA  IS         WS-CONTROL-AREA.

       DATA DIVISION.
       FILE SECTION.
       FD  CALDSP-FILE
           LABEL RECORDS ARE STANDARD.
       01  CALDSP-REC       PIC X(1920).

       WORKING-STORAGE SECTION.

       01 REC1-I-REC.
          COPY DDS-REC1-I OF CALDSP.
       01 REC1-O-REC.
          COPY DDS-REC1-O OF CALDSP.

       01  WS-CONTROL-AREA.
           05  FKEY-PRESSED                  PIC X(2).
               88  F3-EXIT                   VALUE "03".
               88  F12-CANCEL                VALUE "12".

       01  WORK-AREA.
           05  DAY-OF-WK                  PIC 9 COMP-3.
           05  START-DAY-OF-WEEK          PIC 9.
           05  LAST-DAY-OF-MONTH          PIC 99.
           05  DAY-CTR                    PIC 99.
           05  X                          PIC 99.
           05  Y                          PIC 99.
           05  QUOT                       PIC 99.
           05  RMDR                       PIC 99.

       01  PROGRAM-ARRAYS.
           05  DAYS-ARRAY                 PIC 9(2) OCCURS 35.

       01  PROGRAM-TABLES.
           05  MONTH-NAME-ARRAY.
               10 F                       PIC X(3) VALUE "JAN".
               10 F                       PIC X(3) VALUE "FEB".
               10 F                       PIC X(3) VALUE "MAR".
               10 F                       PIC X(3) VALUE "APR".
               10 F                       PIC X(3) VALUE "MAY".
               10 F                       PIC X(3) VALUE "JUN".
               10 F                       PIC X(3) VALUE "JUL".
               10 F                       PIC X(3) VALUE "AUG".
               10 F                       PIC X(3) VALUE "SEP".
               10 F                       PIC X(3) VALUE "OCT".
               10 F                       PIC X(3) VALUE "NOV".
               10 F                       PIC X(3) VALUE "DEC".
           05 MON-NAME-ARRAY REDEFINES MONTH-NAME-ARRAY
                                          PIC X(3) OCCURS 12.
       01  SYSTEM-VARIABLES.
           05 SYSTEM-DATE.
              10 SYSDATE-YY               PIC 9(2).
              10 SYSDATE-MM               PIC 9(2).
              10 SYSDATE-DD               PIC 9(2).

      *---------------------------------------------------------------*

       PROCEDURE DIVISION.

       0000-MAIN.

           PERFORM 9000-INITIALIZE.
           PERFORM 0100-GET-LAST-DAY-OF-MONTH.
           PERFORM 0500-FILL-CALENDAR.

           PERFORM 1000-PROCESS
              UNTIL F3-EXIT OR F12-CANCEL.

           PERFORM 9900-TERMINATE.

           GOBACK.

      *---------------------------------------------------------------*

       0100-GET-LAST-DAY-OF-MONTH.

           IF SYSDATE-MM = 02
              MOVE 28 TO LAST-DAY-OF-MONTH
              DIVIDE SYSDATE-YY BY 4 GIVING QUOT REMAINDER RMDR
              IF RMDR = 0
                 ADD 1 TO LAST-DAY-OF-MONTH
              END-IF
           ELSE
              IF SYSDATE-MM = 04 OR 06 OR 09 OR 11
                 MOVE 30 TO LAST-DAY-OF-MONTH
              ELSE
                 MOVE 31 TO LAST-DAY-OF-MONTH
              END-IF
           END-IF.

      *---------------------------------------------------------------*

       0500-FILL-CALENDAR.

           CALL "GETDAYOFWK" USING DAY-OF-WK.
           MOVE DAY-OF-WK TO START-DAY-OF-WEEK.

           PERFORM VARYING Y FROM SYSDATE-DD BY -1
              UNTIL Y = 1
              IF START-DAY-OF-WEEK = 1
                 MOVE 7 TO START-DAY-OF-WEEK
              ELSE
                 SUBTRACT 1 FROM START-DAY-OF-WEEK
              END-IF
           END-PERFORM.

           MOVE ZEROES TO DAY-CTR.
           MOVE START-DAY-OF-WEEK TO X.

           PERFORM UNTIL DAY-CTR = LAST-DAY-OF-MONTH
              ADD 1 TO DAY-CTR
              MOVE DAY-CTR TO DAYS-ARRAY(X)
              ADD 1 TO X
              IF X > 35
                 MOVE 1 TO X
              END-IF
           END-PERFORM.

           MOVE DAYS-ARRAY(1)  TO DAY001 OF REC1-O.
           MOVE DAYS-ARRAY(2)  TO DAY002 OF REC1-O.
           MOVE DAYS-ARRAY(3)  TO DAY003 OF REC1-O.
           MOVE DAYS-ARRAY(4)  TO DAY004 OF REC1-O.
           MOVE DAYS-ARRAY(5)  TO DAY005 OF REC1-O.
           MOVE DAYS-ARRAY(6)  TO DAY006 OF REC1-O.
           MOVE DAYS-ARRAY(7)  TO DAY007 OF REC1-O.
           MOVE DAYS-ARRAY(8)  TO DAY008 OF REC1-O.
           MOVE DAYS-ARRAY(9)  TO DAY009 OF REC1-O.
           MOVE DAYS-ARRAY(10) TO DAY010 OF REC1-O.
           MOVE DAYS-ARRAY(11) TO DAY011 OF REC1-O.
           MOVE DAYS-ARRAY(12) TO DAY012 OF REC1-O.
           MOVE DAYS-ARRAY(13) TO DAY013 OF REC1-O.
           MOVE DAYS-ARRAY(14) TO DAY014 OF REC1-O.
           MOVE DAYS-ARRAY(15) TO DAY015 OF REC1-O.
           MOVE DAYS-ARRAY(16) TO DAY016 OF REC1-O.
           MOVE DAYS-ARRAY(17) TO DAY017 OF REC1-O.
           MOVE DAYS-ARRAY(18) TO DAY018 OF REC1-O.
           MOVE DAYS-ARRAY(19) TO DAY019 OF REC1-O.
           MOVE DAYS-ARRAY(20) TO DAY020 OF REC1-O.
           MOVE DAYS-ARRAY(21) TO DAY021 OF REC1-O.
           MOVE DAYS-ARRAY(22) TO DAY022 OF REC1-O.
           MOVE DAYS-ARRAY(23) TO DAY023 OF REC1-O.
           MOVE DAYS-ARRAY(24) TO DAY024 OF REC1-O.
           MOVE DAYS-ARRAY(25) TO DAY025 OF REC1-O.
           MOVE DAYS-ARRAY(26) TO DAY026 OF REC1-O.
           MOVE DAYS-ARRAY(27) TO DAY027 OF REC1-O.
           MOVE DAYS-ARRAY(28) TO DAY028 OF REC1-O.
           MOVE DAYS-ARRAY(29) TO DAY029 OF REC1-O.
           MOVE DAYS-ARRAY(30) TO DAY030 OF REC1-O.
           MOVE DAYS-ARRAY(31) TO DAY031 OF REC1-O.
           MOVE DAYS-ARRAY(32) TO DAY032 OF REC1-O.
           MOVE DAYS-ARRAY(33) TO DAY033 OF REC1-O.
           MOVE DAYS-ARRAY(34) TO DAY034 OF REC1-O.
           MOVE DAYS-ARRAY(35) TO DAY035 OF REC1-O.

      *---------------------------------------------------------------*

       1000-PROCESS.

            WRITE CALDSP-REC FROM REC1-O
                  FORMAT IS "REC1".
            READ CALDSP-FILE INTO REC1-I
                 FORMAT IS "REC1".

      *---------------------------------------------------------------*

       9000-INITIALIZE.

           OPEN I-O CALDSP-FILE.

           INITIALIZE REC1-I
                      REC1-O.
           MOVE ZEROES TO PROGRAM-ARRAYS
                          DAY-OF-WK
                          START-DAY-OF-WEEK
                          LAST-DAY-OF-MONTH
                          QUOT
                          RMDR
                          X Y.
           MOVE SPACES TO FKEY-PRESSED.

           ACCEPT SYSTEM-DATE FROM DATE.
           MOVE MON-NAME-ARRAY(SYSDATE-MM) TO MONTH OF REC1-O.
           COMPUTE YEAR OF REC1-O = 2000 + SYSDATE-YY.

      *---------------------------------------------------------------*

       9900-TERMINATE.

           CLOSE CALDSP-FILE.


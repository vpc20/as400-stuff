       PROCESS FS9MTO0M.
       IDENTIFICATION DIVISION.
       PROGRAM-ID.    XREFCBL.

      *================================================================

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.  IBM-AS400.
       OBJECT-COMPUTER.  IBM-AS400.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT XPGMREF1       ASSIGN  TO DATABASE-XPGMREF1.

           SELECT XREFDSP        ASSIGN  TO WORKSTATION-XREFDSP-SI
                  ORGANIZATION   IS         TRANSACTION
                  ACCESS         IS         DYNAMIC
                  RELATIVE KEY   IS         WS-RELKEY
                  CONTROL-AREA   IS         WS-CONTROL-AREA.

      *================================================================

       DATA DIVISION.
       FILE SECTION.

       FD  XPGMREF1
           LABEL RECORDS ARE STANDARD.
       01  XPGMREF1-REC.
           COPY DDS-ALL-FORMATS OF XPGMREF1
                REPLACING XPGMREF1 BY XPGMREF1R.

       FD  XREFDSP
           LABEL RECORDS ARE STANDARD.
       01  XREFDSP-REC     PIC X(1920).


       WORKING-STORAGE SECTION.

       01  WS-SFLREC1-O.
           COPY DDS-SFLREC1-O OF XREFDSP.

       01  WS-SFLCTL1-O.
           COPY DDS-SFLCTL1-O OF XREFDSP.


       01  SWITCH-AREA.
           05  END-PGM-SW        PIC 1     VALUE B"0".
               88  START-PROGRAM           VALUE B"0".
               88  END-PROGRAM             VALUE B"1".
           05  EOF-XPGMREF1-SW    PIC 1   VALUE B"0".
               88  NOT-EOF-XPGMREF1       VALUE B"0".
               88  EOF-XPGMREF1           VALUE B"1".
           05  RECORD-OK-SW      PIC 1     VALUE B"0".
               88  RECORD-NOT-OK           VALUE B"0".
               88  RECORD-OK               VALUE B"1".

       01  DISPLAY-FILE-VAR.
           10  WS-CONTROL-AREA           PIC X(2).
               88  F0-ENTER              VALUE "00".
               88  F3-EXIT               VALUE "03".
           05  WS-RELKEY                 PIC 9(3)     VALUE ZEROES.

       01  INDICATOR-AREA.
           COPY DDS-ALL-FORMATS-INDIC OF XREFDSP.

       01  WORK-AREA.
           05  WS-USAGE                  PIC 9(2) VALUE ZEROES.

       LINKAGE SECTION.

       01 FILE-NAME                        PIC X(10).
       01 LIB-NAME                         PIC X(10).
       01 SELALL-IND                       PIC X.
       01 USAGE-INPUT                      PIC X.
       01 USAGE-OUTPUT                     PIC X.
       01 USAGE-UPDATE                     PIC X.

      *================================================================

       PROCEDURE DIVISION USING FILE-NAME LIB-NAME SELALL-IND
                                USAGE-INPUT USAGE-OUTPUT USAGE-UPDATE.

       0000-MAIN-LOGIC.

           PERFORM 9000-HOUSEKEEPING.

           PERFORM 1000-PROCESS
              UNTIL END-PROGRAM.

           PERFORM 9900-CLEAN-UP.

           GOBACK.

      *================================================================

       1000-PROCESS.

           WRITE XREFDSP-REC  FORMAT IS "FKEYS1".
           WRITE XREFDSP-REC FROM SFLCTL1-O
              FORMAT IS "SFLCTL1"   INDICATORS ARE INDICATOR-AREA.
           READ XREFDSP      INTO SFLCTL1-O
              FORMAT IS "SFLCTL1"   INDICATORS ARE INDICATOR-AREA.


           EVALUATE TRUE

              WHEN F3-EXIT
                 SET END-PROGRAM TO TRUE

           END-EVALUATE.

      *================================================================

       1100-LOAD-SFL.

           MOVE B"0" TO IN80 IN81.
           WRITE XREFDSP-REC FROM SFLCTL1-O
              FORMAT IS "SFLCTL1"   INDICATORS ARE INDICATOR-AREA.
           MOVE B"1" TO IN81.

           SET NOT-EOF-XPGMREF1 TO TRUE.
           MOVE ZEROES TO WS-RELKEY.
           PERFORM UNTIL EOF-XPGMREF1
              READ XPGMREF1 NEXT RECORD
                 AT END
                    SET EOF-XPGMREF1 TO TRUE
                 NOT AT END
                    PERFORM 1150-SELECT-RECORD
                    IF RECORD-OK
                       PERFORM 1200-MOVE-DATA
                       ADD 1 TO WS-RELKEY
                       WRITE SUBFILE XREFDSP-REC FROM WS-SFLREC1-O
                          FORMAT IS "SFLREC1"
                          INDICATORS ARE INDICATOR-AREA
                       MOVE B"1" TO IN80
                    END-IF
              END-READ
           END-PERFORM.

      *================================================================

       1150-SELECT-RECORD.

           SET RECORD-NOT-OK TO TRUE.

           IF USAGE-INPUT = "Y"
              IF USAGE-OUTPUT = "Y"
                 IF USAGE-UPDATE = "Y"
                    MOVE 7 TO WS-USAGE
                 ELSE
                    MOVE 3 TO WS-USAGE
                 END-IF
              ELSE
                 IF USAGE-UPDATE = "Y"
                    MOVE 5 TO WS-USAGE
                 ELSE
                    MOVE 1 TO WS-USAGE
                 END-IF
              END-IF
           ELSE
              IF USAGE-OUTPUT = "Y"
                 IF USAGE-UPDATE = "Y"
                    MOVE 6 TO WS-USAGE
                 ELSE
                    MOVE 2 TO WS-USAGE
                 END-IF
              ELSE
                 IF USAGE-UPDATE = "Y"
                    MOVE 4 TO WS-USAGE
                 END-IF
              END-IF
           END-IF.

           IF SELALL-IND = "Y"
           OR WS-USAGE =  WHFUSG OF XPGMREF1-REC
              SET RECORD-OK TO TRUE
           END-IF.

      *================================================================

       1200-MOVE-DATA.

           INITIALIZE SFLREC1 OF WS-SFLREC1-O.

           MOVE WHPNAM OF XPGMREF1-REC TO WHPNAM OF WS-SFLREC1-O.
           MOVE WHTEXT OF XPGMREF1-REC TO WHTEXT OF WS-SFLREC1-O.

           IF WHFUSG OF XPGMREF1-REC = 1 OR 3 OR 5 OR 7
              MOVE "Y" TO USGINP OF WS-SFLREC1-O
           ELSE
              MOVE "N" TO USGINP OF WS-SFLREC1-O
           END-IF.

           IF WHFUSG OF XPGMREF1-REC = 2 OR 3 OR 6 OR 7
              MOVE "Y" TO USGOUT OF WS-SFLREC1-O
           ELSE
              MOVE "N" TO USGOUT OF WS-SFLREC1-O
           END-IF.

           IF WHFUSG OF XPGMREF1-REC = 4 OR 5 OR 6 OR 7
              MOVE "Y" TO USGUPD OF WS-SFLREC1-O
           ELSE
              MOVE "N" TO USGUPD OF WS-SFLREC1-O
           END-IF.


      *================================================================

       9000-HOUSEKEEPING.

           OPEN INPUT XPGMREF1
                I-O   XREFDSP.

           SET START-PROGRAM TO TRUE.

           MOVE FILE-NAME TO FILENAME OF SFLCTL1-O.
           MOVE LIB-NAME  TO LIBNAME  OF SFLCTL1-O.

           PERFORM 1100-LOAD-SFL.

      *================================================================

       9900-CLEAN-UP.

           CLOSE XPGMREF1
                 XREFDSP.


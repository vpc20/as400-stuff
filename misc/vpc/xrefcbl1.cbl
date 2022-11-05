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

           SELECT XPGMREFLF      ASSIGN  TO DATABASE-XPGMREFLF
                  ORGANIZATION   IS         INDEXED
                  ACCESS         IS         DYNAMIC
                  RECORD KEY     IS         EXTERNALLY-DESCRIBED-KEY
                                            WITH DUPLICATES.

           SELECT XREFDSP        ASSIGN  TO WORKSTATION-XREFDSP-SI
                  ORGANIZATION   IS         TRANSACTION
                  ACCESS         IS         DYNAMIC
                  RELATIVE KEY   IS         WS-RELKEY
                  CONTROL-AREA   IS         WS-CONTROL-AREA.

      *================================================================

       DATA DIVISION.
       FILE SECTION.

       FD  XPGMREFLF
           LABEL RECORDS ARE STANDARD.
       01  XPGMREFLF-REC.
           COPY DDS-ALL-FORMATS OF XPGMREFLF.

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
           05  EOF-XPGMREFLF-SW    PIC 1   VALUE B"0".
               88  NOT-EOF-XPGMREFLF       VALUE B"0".
               88  EOF-XPGMREFLF           VALUE B"1".
           05  BOF-XPGMREFLF-SW    PIC 1   VALUE B"0".
               88  NOT-BOF-XPGMREFLF       VALUE B"0".
               88  BOF-XPGMREFLF           VALUE B"1".
           05  RECORD-OK-SW      PIC 1     VALUE B"0".
               88  RECORD-NOT-OK           VALUE B"0".
               88  RECORD-OK               VALUE B"1".

       01  DISPLAY-FILE-VAR.
           10  WS-CONTROL-AREA           PIC X(2).
               88  F0-ENTER              VALUE "00".
               88  F3-EXIT               VALUE "03".
               88  PAGE-DOWN             VALUE "90".
               88  PAGE-UP               VALUE "91".
           05  WS-RELKEY                 PIC 9(2)     VALUE ZEROES.

       01  INDICATOR-AREA.
           COPY DDS-ALL-FORMATS-INDIC OF XREFDSP.

       01  WORK-AREA.
           05  CTR                       PIC 9(2) VALUE ZEROES.

       LINKAGE SECTION.

       01 FILE-NAME                        PIC X(10).
       01 LIB-NAME                         PIC X(10).
       01 USAGE-INPUT                      PIC X.
       01 USAGE-OUTPUT                     PIC X.
       01 USAGE-UPDATE                     PIC X.

      *================================================================

       PROCEDURE DIVISION USING FILE-NAME LIB-NAME USAGE-INPUT
                                USAGE-OUTPUT USAGE-UPDATE.

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

              WHEN PAGE-UP
                 MOVE B"0" TO IN51
                 PERFORM 1050-PAGE-UP

              WHEN PAGE-DOWN
                 MOVE B"0" TO IN50
                 IF IN82 = B"0"
                    PERFORM 1100-LOAD-SFL
                 ELSE
                    MOVE B"1" TO IN51
                 END-IF

           END-EVALUATE.

      *================================================================

       1050-PAGE-UP.

           MOVE ZEROES TO CTR.
           SET NOT-BOF-XPGMREFLF TO TRUE.

           PERFORM UNTIL BOF-XPGMREFLF
              READ XPGMREFLF PRIOR RECORD
                 AT END
                    SET BOF-XPGMREFLF TO TRUE
                    MOVE SPACES TO WHPNAM OF XPGMREFLF-REC
                    START XPGMREFLF
                       KEY > EXTERNALLY-DESCRIBED-KEY
                       INVALID KEY
                          CONTINUE
                       NOT INVALID KEY
                          PERFORM 1100-LOAD-SFL
                    END-START
                 NOT AT END
                    ADD 1 TO CTR
                    IF CTR = 15
                       SET BOF-XPGMREFLF TO TRUE
                       PERFORM 1100-LOAD-SFL
                    END-IF
              END-READ
           END-PERFORM.

      *================================================================

       1100-LOAD-SFL.

           MOVE B"0" TO IN80 IN81 IN82.
           WRITE XREFDSP-REC FROM SFLCTL1-O
              FORMAT IS "SFLCTL1"   INDICATORS ARE INDICATOR-AREA.
           MOVE B"1" TO IN81.

           SET NOT-EOF-XPGMREFLF TO TRUE.
           MOVE ZEROES TO WS-RELKEY.
           PERFORM UNTIL EOF-XPGMREFLF
              READ XPGMREFLF NEXT RECORD
                 AT END
                    SET EOF-XPGMREFLF TO TRUE
                    MOVE B"1" TO IN82
                 NOT AT END
                    PERFORM 1150-SELECT-RECORD
                    IF RECORD-OK
                       PERFORM 1200-MOVE-DATA
                       ADD 1 TO WS-RELKEY
                       WRITE SUBFILE XREFDSP-REC FROM WS-SFLREC1-O
                          FORMAT IS "SFLREC1"
                          INDICATORS ARE INDICATOR-AREA
                       MOVE B"1" TO IN80
                       IF WS-RELKEY = 13
                          SET EOF-XPGMREFLF TO TRUE
                       END-IF
                    END-IF
              END-READ
           END-PERFORM.

           IF NOT-EOF-XPGMREFLF
              READ XPGMREFLF NEXT RECORD
                 AT END
                    MOVE B"1" TO IN82
                 NOT AT END
                    READ XPGMREFLF PRIOR RECORD
              END-READ
           END-IF.

      *================================================================

       1150-SELECT-RECORD.

           SET RECORD-NOT-OK TO TRUE.

           IF FILE-NAME = WHFNAM OF XPGMREFLF-REC
              IF USAGE-INPUT = "Y"
                 IF WHFUSG OF XPGMREFLF-REC = 1 OR 3 OR 5 OR 7
                    SET RECORD-OK TO TRUE
                 END-IF
              END-IF
              IF USAGE-OUTPUT = "Y"
                 IF WHFUSG OF XPGMREFLF-REC = 2 OR 3 OR 6 OR 7
                    SET RECORD-OK TO TRUE
                 END-IF
              END-IF
              IF USAGE-UPDATE = "Y"
                 IF WHFUSG OF XPGMREFLF-REC = 4 OR 5 OR 6 OR 7
                    SET RECORD-OK TO TRUE
                 END-IF
              END-IF
           END-IF.

      *================================================================

       1200-MOVE-DATA.

           INITIALIZE SFLREC1 OF WS-SFLREC1-O.

           MOVE WHPNAM OF XPGMREFLF-REC TO WHPNAM OF WS-SFLREC1-O.
           MOVE WHTEXT OF XPGMREFLF-REC TO WHTEXT OF WS-SFLREC1-O.

           IF WHFUSG OF XPGMREFLF-REC = 1 OR 3 OR 5 OR 7
              MOVE "Y" TO USGINP OF WS-SFLREC1-O
           ELSE
              MOVE "N" TO USGINP OF WS-SFLREC1-O
           END-IF.

           IF WHFUSG OF XPGMREFLF-REC = 2 OR 3 OR 6 OR 7
              MOVE "Y" TO USGOUT OF WS-SFLREC1-O
           ELSE
              MOVE "N" TO USGOUT OF WS-SFLREC1-O
           END-IF.

           IF WHFUSG OF XPGMREFLF-REC = 4 OR 5 OR 6 OR 7
              MOVE "Y" TO USGUPD OF WS-SFLREC1-O
           ELSE
              MOVE "N" TO USGUPD OF WS-SFLREC1-O
           END-IF.


      *================================================================

       9000-HOUSEKEEPING.

           OPEN INPUT XPGMREFLF
                I-O   XREFDSP.

           SET START-PROGRAM TO TRUE.

           MOVE FILE-NAME TO FILENAME OF SFLCTL1-O.
           MOVE LIB-NAME  TO LIBNAME  OF SFLCTL1-O.

           PERFORM 1100-LOAD-SFL.

      *================================================================

       9900-CLEAN-UP.

           CLOSE XPGMREFLF
                 XREFDSP.


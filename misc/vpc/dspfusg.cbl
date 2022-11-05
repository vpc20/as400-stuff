       PROCESS FS9MTO0M.
       IDENTIFICATION DIVISION.
       PROGRAM-ID. DSPFUSGCBL.

      *================================================================

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.  IBM-AS400.
       OBJECT-COMPUTER.  IBM-AS400.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT QADSPPGM       ASSIGN  TO DATABASE-QADSPPGM.

           SELECT DSPFUSGD       ASSIGN  TO WORKSTATION-DSPFUSGD-SI
                  ORGANIZATION   IS         TRANSACTION
                  ACCESS         IS         DYNAMIC
                  RELATIVE KEY   IS         WS-RELKEY
                  CONTROL-AREA   IS         WS-CONTROL-AREA.

      *================================================================

       DATA DIVISION.
       FILE SECTION.

       FD  QADSPPGM
           LABEL RECORDS ARE STANDARD.
       01  QADSPPGM-REC.
           COPY DDS-ALL-FORMATS OF QADSPPGM.

       FD  DSPFUSGD
           LABEL RECORDS ARE STANDARD.
       01  DSPFUSGD-REC     PIC X(1920).


       WORKING-STORAGE SECTION.

       01  WS-SFLREC1-O.
           COPY DDS-SFLREC1-O OF DSPFUSGD.

       01  WS-SFLCTL1-O.
           COPY DDS-SFLCTL1-O OF DSPFUSGD.


       01  SWITCH-AREA.
           05  END-PGM-SW        PIC 1     VALUE B"0".
               88  START-PROGRAM           VALUE B"0".
               88  END-PROGRAM             VALUE B"1".
           05  EOF-QADSPPGM-SW    PIC 1   VALUE B"0".
               88  NOT-EOF-QADSPPGM       VALUE B"0".
               88  EOF-QADSPPGM           VALUE B"1".

       01  DISPLAY-FILE-VAR.
           10  WS-CONTROL-AREA           PIC X(2).
               88  F0-ENTER              VALUE "00".
               88  F3-EXIT               VALUE "03".
           05  WS-RELKEY                 PIC 9(3)     VALUE ZEROES.

       01  INDICATOR-AREA.
           COPY DDS-ALL-FORMATS-INDIC OF DSPFUSGD.

       01  WORK-AREA.
           05  WS-USAGE                  PIC 9(2) VALUE ZEROES.

       01  QUSROBJD-PARM.
           05  RECEIVER-VAR                        PIC  X(179).
           05  RECEIVER-VAR-LEN                    PIC S9(9) BINARY
                                                   VALUE 179.
           05  FORMAT-NAME                         PIC  X(8)
                                                   VALUE "OBJD0200".
           05  OBJ-AND-LIBRARY-NAME.
               10 ONAME                            PIC  X(10).
               10 LNAME                            PIC  X(10).
           05  OBJTYPE                             PIC  X(10)
                                                   VALUE "*FILE".
           05  ERROR-CODE.
               10  BYTES-PROVIDED                  PIC S9(9) BINARY.
               10  BYTES-AVAILABLE                 PIC S9(9) BINARY.
               10  EXCEPTION-ID                    PIC  X(7).       
               10  RESERVED                        PIC  X(1).       
               10  EXCEPTION-DATA                  PIC  X(512).     

       LINKAGE SECTION.

       01 PGMNAME                          PIC X(10).
       01 LIBNAME                          PIC X(10).

      *================================================================

       PROCEDURE DIVISION USING PGMNAME LIBNAME.

       0000-MAIN-LOGIC.

           PERFORM 9000-SET-UP.

           PERFORM 1000-PROCESS
              UNTIL END-PROGRAM.

           PERFORM 9900-CLEAN-UP.

           GOBACK.

      *================================================================

       1000-PROCESS.

           WRITE DSPFUSGD-REC  FORMAT IS "FKEYS1".
           WRITE DSPFUSGD-REC FROM SFLCTL1-O
              FORMAT IS "SFLCTL1"   INDICATORS ARE INDICATOR-AREA.
           READ DSPFUSGD      INTO SFLCTL1-O
              FORMAT IS "SFLCTL1"   INDICATORS ARE INDICATOR-AREA.


           EVALUATE TRUE

              WHEN F3-EXIT
                 SET END-PROGRAM TO TRUE

           END-EVALUATE.

      *================================================================

       1100-LOAD-SFL.

           MOVE B"0" TO IN80 IN81.
           WRITE DSPFUSGD-REC FROM SFLCTL1-O
              FORMAT IS "SFLCTL1"   INDICATORS ARE INDICATOR-AREA.
           MOVE B"1" TO IN81.

           SET NOT-EOF-QADSPPGM TO TRUE.
           MOVE ZEROES TO WS-RELKEY.
           PERFORM UNTIL EOF-QADSPPGM
              READ QADSPPGM NEXT RECORD
                 AT END
                    SET EOF-QADSPPGM TO TRUE
                 NOT AT END
                    IF WHOTYP OF QADSPPGM-REC = "*FILE"
                       PERFORM 1200-MOVE-DATA
                       ADD 1 TO WS-RELKEY
                       WRITE SUBFILE DSPFUSGD-REC FROM WS-SFLREC1-O
                          FORMAT IS "SFLREC1"
                          INDICATORS ARE INDICATOR-AREA
                       MOVE B"1" TO IN80
                    END-IF
              END-READ
           END-PERFORM.

      *================================================================

       1200-MOVE-DATA.

           INITIALIZE SFLREC1 OF WS-SFLREC1-O.

           MOVE WHFNAM OF QADSPPGM-REC TO FILENAME OF WS-SFLREC1-O.

           MOVE WHFNAM OF QADSPPGM-REC TO ONAME.
           MOVE "*LIBL"                TO LNAME.
           CALL "QUSROBJD" USING RECEIVER-VAR
                                 RECEIVER-VAR-LEN
                                 FORMAT-NAME
                                 OBJ-AND-LIBRARY-NAME
                                 OBJTYPE
                                 ERROR-CODE.
           MOVE RECEIVER-VAR(100:50) TO FILEDESC OF WS-SFLREC1-O.


           IF WHFUSG OF QADSPPGM-REC = 1 OR 3 OR 5 OR 7
              MOVE "Y" TO USGINP OF WS-SFLREC1-O
           ELSE
              MOVE "N" TO USGINP OF WS-SFLREC1-O
           END-IF.

           IF WHFUSG OF QADSPPGM-REC = 2 OR 3 OR 6 OR 7
              MOVE "Y" TO USGOUT OF WS-SFLREC1-O
           ELSE
              MOVE "N" TO USGOUT OF WS-SFLREC1-O
           END-IF.

           IF WHFUSG OF QADSPPGM-REC = 4 OR 5 OR 6 OR 7
              MOVE "Y" TO USGUPD OF WS-SFLREC1-O
           ELSE
              MOVE "N" TO USGUPD OF WS-SFLREC1-O
           END-IF.


      *================================================================

       9000-SET-UP.

           OPEN INPUT QADSPPGM
                I-O   DSPFUSGD.

           SET START-PROGRAM TO TRUE.

           MOVE PGMNAME TO PROGNAME OF SFLCTL1-O.
           MOVE LIBNAME TO LIBRNAME OF SFLCTL1-O.

           PERFORM 1100-LOAD-SFL.

      *================================================================

       9900-CLEAN-UP.

           CLOSE QADSPPGM
                 DSPFUSGD.


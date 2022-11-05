       PROCESS EXTACCDSP.
       IDENTIFICATION DIVISION.
       PROGRAM-ID.    EXTACCDSP.

      *----------------------------------------------------------------

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.  IBM-AS400.
       OBJECT-COMPUTER.  IBM-AS400.
       SPECIAL-NAMES.    CRT STATUS IS WS-CRT-STATUS
                         I-O-FEEDBACK IS IO-FEEDBACK.

      *----------------------------------------------------------------

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       01  WORK-AREAS.
           05  WS-CRT-STATUS            PIC X(6) VALUE SPACES.
               88 F3-EXIT               VALUE "010300".
           05  DUMMY                    PIC X.
           05  CUR-ROW                  PIC 99 VALUE ZEROES.
           05  CUR-COL                  PIC 99 VALUE ZEROES.
       01  WS-IO-FEEDBACK.
           05 F                         PIC X(147).
           05 CURPOS                    PIC S9(4) BINARY.


      *----------------------------------------------------------------

       PROCEDURE DIVISION.

       MAIN-ROUTINE.

           DISPLAY "Get cursor position"
              AT LINE  2 COL 2
              WITH BLANK SCREEN.

           PERFORM UNTIL F3-EXIT
              DISPLAY "Cursor Row :"
                 AT LINE  4 COL 2
              DISPLAY CUR-ROW
                 AT LINE  4 COL 15
              DISPLAY "Cursor Col :"
                 AT LINE  5 COL 2
              DISPLAY CUR-COL
                 AT LINE  5 COL 15
              ACCEPT DUMMY
                 AT LINE 3 COLUMN 2
              ACCEPT WS-IO-FEEDBACK FROM IO-FEEDBACK
              DIVIDE CURPOS BY 256 GIVING CUR-ROW REMAINDER CUR-COL
           END-PERFORM.

           STOP RUN.

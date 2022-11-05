       IDENTIFICATION DIVISION.
       PROGRAM-ID.    KIMMMAIN.
       AUTHOR.        VPC.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.  IBM-AS400.
       OBJECT-COMPUTER.  IBM-AS400.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT TEXTFILE ASSIGN DATABASE-TEXTFILE.

       DATA DIVISION.
       FILE SECTION.


       FD TEXTFILE
           LABEL RECORD IS STANDARD.
       01 TEXTREC.
          COPY DDS-ALL-FORMATS OF TEXTFILE.

       WORKING-STORAGE SECTION.

       01 WORK-AREA.
          05 EOF-TEXTFILE-SW                  PIC 9 VALUE ZEROES.
             88 EOF-TEXTFILE                  VALUE 1.
             88 NOT-EOF-TEXTFILE              VALUE 0.
          05 HILITE-CHAR                      PIC X VALUE X"22".
          05 HILITE-END                       PIC X VALUE X"20".

       PROCEDURE DIVISION.

       0000-MAIN.

           OPEN  I-O TEXTFILE.
           SET NOT-EOF-TEXTFILE TO TRUE

           PERFORM UNTIL EOF-TEXTFILE
              READ TEXTFILE
                 AT END
                    SET EOF-TEXTFILE TO TRUE
                 NOT AT END
                    IF TEXTREC(19:1) = "*"
                       MOVE HILITE-CHAR TO TEXTREC(13:1)
                       MOVE HILITE-END  TO TEXTREC(92:1)
                       REWRITE TEXTREC
                    END-IF
              END-READ
           END-PERFORM.

           CLOSE TEXTFILE.
           STOP RUN.

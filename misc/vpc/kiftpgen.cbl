       IDENTIFICATION DIVISION.
      *****************************************************************
      **                       KPL System                            **
      **                       ----------                            **
      ** Program Id    -  KIFTPGEN    Generate FTP script for        **
      **                              Datapost download              **
      **                                                             **
      *****************************************************************
      **                                                             **
      **  CHANGES DETAILS                                            **
      **                                                             **
      **  Change No. Date      BY  Description                       **
      **  ---------- -----     --  -----------------------           **
      **                                                             **
      *****************************************************************

       PROGRAM-ID.    KIFTPGEN.
       AUTHOR.        VPC.
       INSTALLATION.  KEPPEL TATLEE.
       DATE-WRITTEN.  20/07/2000.
       DATE-COMPILED.

      *---------------------------------------------------------------*

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.  IBM-AS400.
       OBJECT-COMPUTER.  IBM-AS400.
       SPECIAL-NAMES. LOCAL-DATA IS LOCAL-DATA-AREA.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT KIFTPPF-FILE    ASSIGN  TO DATABASE-KIFTPPF
                  ORGANIZATION    IS         SEQUENTIAL
                  ACCESS          IS         SEQUENTIAL
                  FILE STATUS     IS         FILE-STATUS.

      *---------------------------------------------------------------*

       DATA DIVISION.
       FILE SECTION.

       FD  KIFTPPF-FILE
           LABEL RECORDS ARE STANDARD.
       01  KIFTPPF-REC.
       COPY DDS-ALL-FORMATS OF KIFTPPF.

       WORKING-STORAGE SECTION.
           COPY CPDATAWS     OF    QCBLSRC.
           COPY LDAARAWS     OF    QCBLSRC.

       01  WORK-AREAS.
           05 I                          PIC 9(3)  VALUE ZEROES.
           05 SEQNBR                     PIC 9(6)  VALUE ZEROES.
           05 USERID-PASSWORD            PIC X(80) VALUE SPACES.
           05 WS-TEMP-FILENAME.
              10 WS-TEMP-FILENAME1       PIC X(8).
              10 WS-TEMP-FILENAME2       PIC X(2).
           05 WS-FILENAME               PIC X(10) VALUE SPACES.
           05 WS-NBRCURRCD              PIC 9(10) VALUE ZEROES
                                                  PACKED-DECIMAL.
           05 WS-FILEDESC               PIC X(50) VALUE SPACES.

       01  PROGRAM-SWITCHES.
           05 WS-EOF-KIFTPPF          PIC 1.
              88  NOT-EOF-KIFTPPF     VALUE B"0".
              88  EOF-KIFTPPF         VALUE B"1".

       01  SYSTEM-VARIABLES.
           05 SYSTEM-DATE                PIC 9(6)  VALUE ZEROES.

       01  PROGRAM-ARRAYS.
           05 FTP-COMMAND-ARRAY          PIC X(80) OCCURS 3.

       LINKAGE SECTION.

       01  CURRENT-DIR-PARM         PIC X(50).
       01  LOCAL-CURRENT-DIR-PARM   PIC X(10).
       01  FTP-FILES-PARM.
           05  FTP-FILES            PIC X(10) OCCURS 200.


      *---------------------------------------------------------------*

       PROCEDURE DIVISION USING CURRENT-DIR-PARM
                                LOCAL-CURRENT-DIR-PARM
                                FTP-FILES-PARM.

       DECLARATIVES.
       KIFTPPF-FILE-ERROR SECTION.
           USE AFTER STANDARD ERROR PROCEDURE KIFTPPF-FILE.
       ERROR-KIFTPPF-FILE.
           MOVE "KIFTPPF"  TO FILE-NAME.
           PERFORM DCL-ERROR  THRU
                   DCL-ERROR-EXIT.
         COPY   DCLOLPD      OF  QCBLSRC.
       END DECLARATIVES.

       BEGIN-NON-DECLARATIVES SECTION.
       A000-MAIN-PARA.

           PERFORM A1000-INIT-PARA    THRU A1000-EXIT.
           PERFORM B1000-PROCESS-PARA THRU B1000-EXIT.
           PERFORM C1000-CLOSE-PARA   THRU C1000-EXIT.

       A000-EXIT.
           GOBACK.

      *---------------------------------------------------------------*

       A1000-INIT-PARA.

           INITIALIZE WS-LDA.
           ACCEPT WS-LDA    FROM LOCAL-DATA-AREA.
           MOVE "KIFTPGEN"  TO PROGRAM-NAME.

           OPEN INPUT  KIFTPPF-FILE.

           ACCEPT SYSTEM-DATE FROM DATE.
           SET NOT-EOF-KIFTPPF TO TRUE.

       A1000-EXIT.
           EXIT.

      *---------------------------------------------------------------*

       B1000-PROCESS-PARA.

      * Save the first line of the FTP script which contains the
      * userid and password

           READ KIFTPPF-FILE NEXT RECORD
              AT END
                 SET EOF-KIFTPPF TO TRUE
              NOT AT END
                 MOVE SRCDTA OF KIFTPPF-REC TO USERID-PASSWORD
           END-READ.

           CLOSE KIFTPPF-FILE.

      * Clear the FTP script and restore the first line

           OPEN OUTPUT KIFTPPF-FILE.
           MOVE ZEROES TO SEQNBR.

           INITIALIZE KIFTPREC.
           MOVE USERID-PASSWORD TO SRCDTA OF KIFTPPF-REC.
           ADD 1 TO SEQNBR.
           MOVE SEQNBR TO SRCSEQ OF KIFTPPF-REC.
           MOVE SYSTEM-DATE TO SRCDAT OF KIFTPPF-REC.
           WRITE KIFTPPF-REC.

      * Write the cd command

           INITIALIZE KIFTPREC.
           STRING "cd "             DELIMITED BY SIZE
                  CURRENT-DIR-PARM  DELIMITED BY SIZE
              INTO SRCDTA OF KIFTPPF-REC.
           ADD 1 TO SEQNBR.
           MOVE SEQNBR TO SRCSEQ OF KIFTPPF-REC.
           MOVE SYSTEM-DATE TO SRCDAT OF KIFTPPF-REC.
           WRITE KIFTPPF-REC.

      * Write the lcd command

           INITIALIZE KIFTPREC.
           STRING "lcd "                  DELIMITED BY SIZE
                  LOCAL-CURRENT-DIR-PARM  DELIMITED BY SIZE
              INTO SRCDTA OF KIFTPPF-REC.
           ADD 1 TO SEQNBR.
           MOVE SEQNBR TO SRCSEQ OF KIFTPPF-REC.
           MOVE SYSTEM-DATE TO SRCDAT OF KIFTPPF-REC.
           WRITE KIFTPPF-REC.

      * Write del command for each of the file

           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 200
              IF FTP-FILES(I) NOT = SPACES
                 MOVE FTP-FILES(I) TO WS-TEMP-FILENAME
                 INITIALIZE KIFTPREC
                 STRING "del "            DELIMITED BY SIZE
                        FTP-FILES(I) DELIMITED BY SIZE
                    INTO SRCDTA OF KIFTPPF-REC
                 ADD 1 TO SEQNBR
                 MOVE SEQNBR TO SRCSEQ OF KIFTPPF-REC
                 MOVE SYSTEM-DATE TO SRCDAT OF KIFTPPF-REC
                 WRITE KIFTPPF-REC
              ELSE
                 MOVE 201 TO I
              END-IF
           END-PERFORM.

      * Write del command for the control report file

           INITIALIZE KIFTPREC.
           MOVE "del KIARTR98.CTL" TO SRCDTA OF KIFTPPF-REC.
           ADD 1 TO SEQNBR.
           MOVE SEQNBR TO SRCSEQ OF KIFTPPF-REC.
           MOVE SYSTEM-DATE TO SRCDAT OF KIFTPPF-REC.
           WRITE KIFTPPF-REC.

      * Write put command for each of the file

           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 200
              IF FTP-FILES(I) NOT = SPACES
                 MOVE FTP-FILES(I) TO WS-FILENAME
                 MOVE ZEROES TO WS-NBRCURRCD
                 MOVE SPACES TO WS-FILEDESC
                 CALL "KICHKNUMRC" USING WS-FILENAME
                                         WS-NBRCURRCD
                                         WS-FILEDESC
                 IF WS-NBRCURRCD > 0
                    INITIALIZE KIFTPREC
                    MOVE FTP-FILES(I) TO WS-TEMP-FILENAME
                    STRING "put "        DELIMITED BY SIZE
                           FTP-FILES(I)  DELIMITED BY SIZE
                           " "           DELIMITED BY SIZE
                           FTP-FILES(I)  DELIMITED BY SIZE
                       INTO SRCDTA OF KIFTPPF-REC
                    END-STRING
                    ADD 1 TO SEQNBR
                    MOVE SEQNBR TO SRCSEQ OF KIFTPPF-REC
                    MOVE SYSTEM-DATE TO SRCDAT OF KIFTPPF-REC
                    WRITE KIFTPPF-REC
                 END-IF
              ELSE
                 MOVE 201 TO I
              END-IF
           END-PERFORM.

      * Write put command for the control report file

           INITIALIZE KIFTPREC.
           MOVE "put KIARTR98CF KIARTR98.CTL" TO SRCDTA OF KIFTPPF-REC.
           ADD 1 TO SEQNBR.
           MOVE SEQNBR TO SRCSEQ OF KIFTPPF-REC.
           MOVE SYSTEM-DATE TO SRCDAT OF KIFTPPF-REC.
           WRITE KIFTPPF-REC.

       B1000-EXIT.
           EXIT.

      *---------------------------------------------------------------*

       C1000-CLOSE-PARA.

      * Write quit command to end ftp session

           ADD 1 TO SEQNBR.
           MOVE SEQNBR TO SRCSEQ OF KIFTPPF-REC.
           MOVE SYSTEM-DATE TO SRCDAT OF KIFTPPF-REC.
           MOVE "quit" TO SRCDTA OF KIFTPPF-REC.
           WRITE KIFTPPF-REC.

           CLOSE  KIFTPPF-FILE.

       C1000-EXIT.
           EXIT.


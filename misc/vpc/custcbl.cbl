       IDENTIFICATION DIVISION.
       PROGRAM-ID.    CUSTCBL.

      *================================================================

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.  IBM-AS400.
       OBJECT-COMPUTER.  IBM-AS400.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT CUSTPF         ASSIGN  TO DATABASE-CUSTPF
                  ORGANIZATION   IS         INDEXED
                  ACCESS         IS         DYNAMIC
                  RECORD KEY     IS         EXTERNALLY-DESCRIBED-KEY
                                            WITH DUPLICATES.

           SELECT CUSTDSP        ASSIGN  TO WORKSTATION-CUSTDSP-SI
                  ORGANIZATION   IS         TRANSACTION
                  ACCESS         IS         DYNAMIC
                  CONTROL-AREA   IS         WS-CONTROL-AREA.

      *================================================================

       DATA DIVISION.
       FILE SECTION.

       FD  CUSTPF
           LABEL RECORDS ARE STANDARD.
       01  CUSTPF-REC.
           COPY DDS-ALL-FORMATS OF CUSTPF.

       FD  CUSTDSP
           LABEL RECORDS ARE STANDARD.
       01  CUSTDSP-REC     PIC X(1920).


       WORKING-STORAGE SECTION.

       01  WS-REC1-I.
           COPY DDS-REC1-I OF CUSTDSP.
       01  WS-REC1-O.
           COPY DDS-REC1-O OF CUSTDSP.

       01  WS-REC2-I.
           COPY DDS-REC2-I OF CUSTDSP.
       01  WS-REC2-O.
           COPY DDS-REC2-O OF CUSTDSP.

       01  DISPLAY-FILE-VAR.
           10  WS-CONTROL-AREA           PIC X(2).
               88  F0-ENTER              VALUE "00".
               88  F3-EXIT               VALUE "03".
               88  F4-PROMPT             VALUE "04".
               88  F6-ADD                VALUE "06".
               88  F7-CHANGE             VALUE "07".
               88  F8-DELETE             VALUE "08".
               88  F9-DISPLAY            VALUE "09".
               88  F12-CANCEL            VALUE "12".

       01  INDIC-AREA.
           COPY DDS-ALL-FORMATS-INDIC OF CUSTDSP.

       01  SWITCH-AREA.
           05  END-PGM-SW          PIC 1   VALUE B"0".
               88  START-PROGRAM           VALUE B"0".
               88  END-PROGRAM             VALUE B"1".
           05  VALID-DATA-SW       PIC 1   VALUE B"0".
               88  INVALID-DATA            VALUE B"0".
               88  VALID-DATA              VALUE B"1".



       01  WORK-AREA.
           05  SCREEN-VAR          PIC 9(2) VALUE ZEROES.
               88 MAINT-MODE-SCR            VALUE 1.  
               88 DTL-SCR1                  VALUE 2.
           05  MAINTENANCE-MODE    PIC X    VALUE SPACES.
               88 ADD-MODE                  VALUE 'A'.         
               88 CHANGE-MODE               VALUE 'C'.         
               88 DELETE-MODE               VALUE 'D'. 
               88 DISPLAY-MODE              VALUE 'I'.         
  
      *================================================================

       PROCEDURE DIVISION.

       0000-MAIN.

           PERFORM 9000-HOUSEKEEPING.

           EVALUATE TRUE
              WHEN MAINT-MODE-SCR
                 PERFORM 1000-MAINT-MODE-SCR
              WHEN DTL-SCR1
                 PERFORM 2000-DTL-SCR1
           END-EVALUATE. 

           PERFORM 9900-CLEAN-UP.

           GOBACK.

      *================================================================

       1000-MAINT-MODE-SCR.

           PERFORM UNTIL NOT FUNC-SCR 
              MOVE CORR REC1-I TO REC1-O  
              WRITE CUSTDSP-REC FROM REC1-O
                 FORMAT IS "REC1"   INDICATORS ARE INDIC-AREA
              READ CUSTDSP   INTO REC1-I
                 FORMAT IS "REC1"   INDICATORS ARE INDIC-AREA

              IF F0-ENTER
                 PERFORM 1100-VALIDATE-DATA
                 IF VALID-DATA
                    SET DTL-SCR1 TO TRUE 
                 END-IF 
              ELSE   
                 PERFORM 8000-EVALUATE-FKEYS
              END-IF
           END-PERFORM.   

     *================================================================

       1100-VALIDATE-DATA.

           SET VALID-DATA TO TRUE.
           MOVE B'0' TO INXX INXX INXX. 

           SET CUSTPF-FOUND TO TRUE.
           READ CUSTPF
              INVALID KEY
                 SET CUSTPF-NOT-FOUND TO TRUE
           END-READ.

           EVALUATE TRUE

              WHEN ADD-MODE
                 IF CUSPF-FOUND 
                    SET INVALID-DATA TO TRUE
                    MOVE B'1' TO INXX
                 END-IF

              WHEN CHANGE-MODE
              WHEN DELETE-MODE
              WHEN DISPLAY-MODE
                 IF CUSPF-NOT-FOUND 
                    SET INVALID-DATA TO TRUE
                    MOVE B'1' TO INXX
                 END-IF

           END-IF.     


      *================================================================

       2000-DTL-SCR1.

           PERFORM 2900-DTL-SCR1-INIT.

           PERFORM UNTIL NOT DTL-SCR1
              IF DELETE-MODE
                 MOVE B'1' TO INXX
              END-IF 
              MOVE CORR REC2-I TO REC2-O  
              WRITE CUSTDSP-REC FROM REC2-O
                 FORMAT IS "REC2"   INDICATORS ARE INDIC-AREA
              READ CUSTDSP   INTO REC2-I
                 FORMAT IS "REC2"   INDICATORS ARE INDIC-AREA

              IF F0-ENTER
                 PERFORM 2100-VALIDATE-DATA
                 IF VALID-DATA
                    PERFORM 2200-UPDATE-CUSPF
                    SET FUNC-SCR TO TRUE 
                 END-IF
              ELSE   
                 PERFORM 8000-EVALUATE-FKEYS
              END-IF
           END-PERFORM.   

    *================================================================

       2100-VALIDATE-DATA.

           SET VALID-DATA TO TRUE.
           MOVE B'0' TO INXX INXX INXX. 


           IF ADD-MODE OR CHANGE-MODE
              IF XXXX = SPACES 
                 SET INVALID-DATA TO TRUE
                 MOVE B'1' TO INXX
              END-IF
           END-IF.     

    *================================================================

       2200-UPDATE-CUSTPF.

           EVALUATE TRUE

              WHEN ADD-MODE
                 MOVE CORR REC2-I TO CUSTREC
                 WRITE CUSTREC
  
              WHEN CHANGE-MODE
                 MOVE CORR REC2-I TO CUSTREC
                 REWRITE CUSTREC

              WHEN DELETE-MODE
                 DELETE CUSTPF
 
           END-EVALUATE.


     *================================================================

       2900-DTL-SCR1-INIT.

           INITIALIZE REC2-I
                      REC2-O.

           MOVE CORR REC1-O  TO REC2-O. 


           EVALUATE TRUE

      ***   Unprotect data entry fields      
              WHEN ADD-MODE
                 MOVE B'0' TO IN75         
 
      ***   Move data from file to screen
      ***   Unprotect data entry fields        
              WHEN CHANGE-MODE
                 MOVE CORR CUSTREC TO REC2-I 
                 MOVE B'0' TO IN75

      ***   Move data from file to screen
      ***   Protect data entry fields             
              WHEN DELETE-MODE
              WHEN DISPLAY-MODE
                 MOVE CORR CUSTREC TO REC2-I
                 MOVE B'1' TO IN75 
   
           END-EVALUATE. 

      *================================================================

       8000-EVALUATE-FKEYS.

           EVALUATE TRUE

              WHEN F3-EXIT
                 SET END-PROGRAM TO TRUE
            
              WHEN F4-PROMPT
                 PERFORM 8100-F4-PROMPT

              WHEN F6-ADD
                 SET  ADD-MODE  TO TRUE
                 MOVE 'ADD'     TO MODE OF REC1-O
                                           REC2-O                   
 
              WHEN F7-CHANGE
                 SET  CHANGE-MODE TO TRUE
                 MOVE 'CHANGE'    TO MODE OF REC1-O
                                             REC2-O                   

              WHEN F8-DELETE
                 SET  DELETE-MODE TO TRUE
                 MOVE 'DELETE'    TO MODE OF REC1-O
                                             REC2-O 
              WHEN F9-DISPLAY
                 SET  DISPLAY-MODE TO TRUE
                 MOVE 'DISPLAY'    TO MODE OF REC1-O
                                              REC2-O 

              WHEN F12-CANCEL
                 SUBTRACT 1 FROM SCREEN-VAR                  
  
           END-VALUATE.

      *================================================================

       8100-F4-PROMPT.

           IF  CURREC OF REC1-I = 'REC1'
           AND CURFLD OF REC1-I = 'CUSTNO'
               CALL 'CUSTCBL1' USING CUSTCBL1-PARM
               IF CUSTNO OF CUSTCBL1-PARM NOT = ZEROES
                  MOVE CUSTNO OF CUSTCBL1-PARM TO CUSTNO OF REC1-I
               END-IF  
           END-IF. 

      *================================================================

       9000-HOUSEKEEPING.

           OPEN I-O   CUSTPF
                      CUSTDSP.

           INITIALIZE REC1-I
                      REC1-O
                      REC2-I
                      REC2-O.

           SET START-PROGRAM TO TRUE.
           SET MAINT-MODE-SCR      TO TRUE.

      *================================================================

       9900-CLEAN-UP.

           CLOSE CUSTPF
                 CUSTDSP.


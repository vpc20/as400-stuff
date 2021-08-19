       IDENTIFICATION DIVISION.
       PROGRAM-ID. CRTSPLFCBL.

      ******************************************************************

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT SPLFOUTF         ASSIGN TO DATABASE-SPLFOUTF
                  ORGANIZATION     IS SEQUENTIAL
                  ACCESS           IS SEQUENTIAL.

      ******************************************************************

       DATA DIVISION.
       FILE SECTION.
       FD  SPLFOUTF
           LABEL RECORDS ARE STANDARD.
       01  SPLFOUTF-REC.
           COPY DDS-ALL-FORMATS OF SPLFOUTF.

      ******************************************************************

       WORKING-STORAGE SECTION.

       COPY QUSEC OF QSYSINC-QLBLSRC.

       01  MISC.
           05 SPC-NAME           PIC X(20) VALUE "SPCNAME   QTEMP ".
           05 SPC-SIZE           PIC S9(09) VALUE 2190000 BINARY.
           05 SPC-INIT           PIC X(01) VALUE X"00".
           05 SPCPTR             POINTER.
           05 SPC-TYPE           PIC X(10) VALUE "*USRSPC".
           05 EXT-ATTR           PIC X(10) VALUE "QUSLSPL ".
           05 SPC-AUT            PIC X(10) VALUE "*ALL".
           05 SPC-TEXT           PIC X(50).
           05 SPC-REPLAC         PIC X(10) VALUE "*YES".
           05 SPC-DOMAIN         PIC X(10) VALUE "*USER".
           05 LST-FORMAT-NAME    PIC X(08) VALUE "SPLF0200".
           05 VAR9BX             PIC X(4).
           05 VAR9B REDEFINES VAR9BX PIC S9(9) BINARY.
      *>     05 USR-PRF            PIC X(10) VALUE "*CURRENT ".
      *>     05 OUTQ               PIC X(20) VALUE "*ALL".
      *>     05 FORMTYP            PIC X(10) VALUE "*ALL".
      *>     05 USRDTA             PIC X(10) VALUE "*ALL".
      *>     05 JOBNAM             PIC X(26).

       01  KEYS.
           05 KEY201             PIC S9(09) BINARY VALUE 201.
           05 KEY202             PIC S9(09) BINARY VALUE 202.
           05 KEY203             PIC S9(09) BINARY VALUE 203.
           05 KEY204             PIC S9(09) BINARY VALUE 204.
           05 KEY205             PIC S9(09) BINARY VALUE 205.
           05 KEY206             PIC S9(09) BINARY VALUE 206.
           05 KEY207             PIC S9(09) BINARY VALUE 207.
           05 KEY208             PIC S9(09) BINARY VALUE 208.
           05 KEY209             PIC S9(09) BINARY VALUE 209.
           05 KEY210             PIC S9(09) BINARY VALUE 210.
           05 KEY211             PIC S9(09) BINARY VALUE 211.
           05 KEY212             PIC S9(09) BINARY VALUE 212.
           05 KEY213             PIC S9(09) BINARY VALUE 213.
           05 KEY214             PIC S9(09) BINARY VALUE 214.
           05 KEY215             PIC S9(09) BINARY VALUE 215.
           05 KEY216             PIC S9(09) BINARY VALUE 216.
           05 KEY217             PIC S9(09) BINARY VALUE 217.
           05 KEY218             PIC S9(09) BINARY VALUE 218.
           05 KEY219             PIC S9(09) BINARY VALUE 219.
           05 KEY220             PIC S9(09) BINARY VALUE 220.
           05 KEY221             PIC S9(09) BINARY VALUE 221.
           05 KEY222             PIC S9(09) BINARY VALUE 222.
           05 KEY223             PIC S9(09) BINARY VALUE 223.
           05 KEY224             PIC S9(09) BINARY VALUE 224.
           05 KEY225             PIC S9(09) BINARY VALUE 225.
           05 KEY226             PIC S9(09) BINARY VALUE 226.
           05 KEY227             PIC S9(09) BINARY VALUE 227.
           05 KEY228             PIC S9(09) BINARY VALUE 228.
       01  NUMBER-OF-KEYS        PIC S9(09) BINARY VALUE 28.

      *> 01  MISC2.
      *>     05 PAGESA             PIC X(04).
      *>     05 PAGESN REDEFINES PAGESA  PIC S9(09) BINARY.


      ******************************************************************

       LINKAGE SECTION.

       01  LINK-USER                 PIC X(10).
       01  LINK-OUTQ                 PIC X(20).
       01  LINK-FORMTYP              PIC X(10).
       01  LINK-USRDTA               PIC X(10).
       01  LINK-JOB.
           05 LINK-JOBNAM            PIC X(10).
           05 LINK-JOBUSR            PIC X(10).
           05 LINK-JOBNBR            PIC X(6).

       01 STRING-SPACE PIC X(32000).

       COPY QUSGEN OF QSYSINC-QLBLSRC.

       01  QUS-LSPL-KEY-INFO.
           05 LEN-FIELD-INFO-RETD        PIC S9(00009) BINARY.
           05 KEY-FIELD-FOR-FIELD-RETD   PIC S9(00009) BINARY.
           05 TYPE-OF-DATA               PIC X(00001).
           05 RESERV3                    PIC X(00003).
           05 DATA-LENGTH                PIC S9(00009) BINARY.
           05 DATA-FIELD                 PIC X(00100).

       01  QUS-SPLF0200.
           05 NUM-FIELDS-RETD              PIC S9(00009) BINARY.
           05 KEY-INFO.
              09 LEN-FIELD-INFO-RETD       PIC S9(00009) BINARY.
              09 KEY-FIELD-FOR-FIELD-RETD  PIC S9(00009) BINARY.
              09 TYPE-OF-DATA              PIC X(00001).
              09 RESERV3                   PIC X(00003).
              09 DATA-LENGTH               PIC S9(00009) BINARY.
              09 DATA-FIELD                PIC X(00001).
              09 RESERVED                  PIC X(00001).

      ******************************************************************

       PROCEDURE DIVISION USING LINK-USER, LINK-OUTQ, LINK-FORMTYP,
           LINK-USRDTA, LINK-JOB.

       MAIN-LINE.
           OPEN EXTEND SPLFOUTF.
      *
      * Set Error Code structure to use exceptions
      *
           MOVE 0 TO BYTES-PROVIDED OF QUS-EC.
      *
      * Create a User Space for the List generated by QUSLSPL
      *
           CALL "QUSCRTUS" USING SPC-NAME, EXT-ATTR, SPC-SIZE,
                SPC-INIT, SPC-AUT, SPC-TEXT,
                SPC-REPLAC, QUS-EC, SPC-DOMAIN.
      *
      * Call QUSLSPL to get all spooled files for *CURRENT user
      *
           CALL "QUSLSPL" USING SPC-NAME, LST-FORMAT-NAME, LINK-USER,
                LINK-OUTQ, LINK-FORMTYP, LINK-USRDTA, QUS-EC,
                LINK-JOB, KEYS, NUMBER-OF-KEYS.
      *
      * Get a resolved pointer to the User Space for performance
      *
           CALL "QUSPTRUS" USING SPC-NAME, SPCPTR, QUS-EC.
      *
      * If valid information was returned
      *
           SET ADDRESS OF QUS-GENERIC-HEADER-0100 TO SPCPTR.
           IF STRUCTURE-RELEASE-LEVEL OF QUS-GENERIC-HEADER-0100
           NOT EQUAL "0100"
               DISPLAY "Error - STRUCTURE-RELEASE-LEVEL not 0100"
               STOP RUN
           END-IF.

           IF (INFORMATION-STATUS OF QUS-GENERIC-HEADER-0100 = "C"
           OR INFORMATION-STATUS OF QUS-GENERIC-HEADER-0100 = "P")
           AND NUMBER-LIST-ENTRIES OF QUS-GENERIC-HEADER-0100 > 0
      *
      * address current list entry
      *
              SET ADDRESS OF STRING-SPACE TO SPCPTR
              SET ADDRESS OF QUS-SPLF0200 TO
                  ADDRESS OF STRING-SPACE((OFFSET-LIST-DATA
                             OF QUS-GENERIC-HEADER-0100 + 1):1)
      *
      * and process all of the entries
      *
              PERFORM PROCES
              NUMBER-LIST-ENTRIES OF QUS-GENERIC-HEADER-0100 TIMES
           END-IF.

           CLOSE SPLFOUTF.
           STOP RUN.

      ******************************************************************

       PROCES.
      *
      * address the first variable length record for this entry
      *
           SET ADDRESS OF QUS-LSPL-KEY-INFO TO
               ADDRESS OF QUS-SPLF0200(5:).
      *
      * process all variable length records associated with this entry
      *
           PERFORM PROCES2 NUM-FIELDS-RETD TIMES.
           WRITE SPLFOUTF-REC.
      *
      * after each entry, increment to the next entry
      *
           SET ADDRESS OF STRING-SPACE TO ADDRESS OF QUS-SPLF0200.
           SET ADDRESS OF QUS-SPLF0200 TO ADDRESS OF STRING-SPACE
           ((SIZE-EACH-ENTRY OF QUS-GENERIC-HEADER-0100 + 1):1).
      *
      * Process each variable length record based on key
      *
      ******************************************************************

       PROCES2.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 201
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO SPLFNM OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 202
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO JOBNM OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 203
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO USERNM OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 204
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO JOBNUM OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 205
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO VAR9BX
              MOVE VAR9B TO SPLNUM OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 206
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO OUTQNM OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 207
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO OUTQLIB OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 208
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO DEVICE OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 209
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO USRDTA OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 210
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO STAT OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 211
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO VAR9BX
              MOVE VAR9B TO TOTPG OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 212
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO VAR9BX
               MOVE VAR9B TO CURRPG OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 213
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO VAR9BX
              MOVE VAR9B TO CPPLEFT OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 214
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO FORMTYP OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 215
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO PRIORITY OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 216
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO CRTDATE OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 217
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO CRTTIME OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 218
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO INTJOBID OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 219
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO INTSPLFID OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 220
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO DEVTYPE OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 221
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO LSTUSEDT OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 222
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO VAR9BX
              MOVE VAR9B TO SPLSZMULT OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 223
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO VAR9BX
              MOVE VAR9B TO SPLSIZE OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 224
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO VAR9BX
              MOVE VAR9B TO AUXSTRPOOL OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 225
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO JOBSYSNM OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 226
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO AUXSTRDEV OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 227
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO CRTDATEUTC OF SPLFOUTF-REC
           END-IF.

           IF KEY-FIELD-FOR-FIELD-RETD OF QUS-LSPL-KEY-INFO = 228
              MOVE DATA-FIELD OF QUS-LSPL-KEY-INFO(
                   1:DATA-LENGTH OF QUS-LSPL-KEY-INFO)
                   TO CRTTIMEUTC OF SPLFOUTF-REC
           END-IF.

           SET ADDRESS OF STRING-SPACE TO ADDRESS OF QUS-LSPL-KEY-INFO.
           SET ADDRESS OF QUS-LSPL-KEY-INFO TO
               ADDRESS OF STRING-SPACE(
           LEN-FIELD-INFO-RETD OF QUS-LSPL-KEY-INFO + 1:1).

**Free
Ctl-Opt Debug
        DftActGrp( *No ) ActGrp( *Caller )
        Option( *ShowCpy: *SrcStmt: *NoDebugIO );

//--------------------------------------------------------------------------------------------------
// Program Name. . . . . : CVTRPGFREE
// Program Description . : Convert RPGILE Source Member to Free-form
// Date Created. . . . . : 30/04/2015
// Programmer. . . . . . : Ewarwoowar
//
// Please submit any issues or requests via http://cvtrpgfree.sourceforge.net
//
//--------------------------------------------------------------------------------------------------
// SYNOPSIS :
// - Reads through an RPGILE source member and reformats the contents.
//--------------------------------------------------------------------------------------------------
/Eject
//-------------------------------------------------------------------------------------------
// F I L E S
//-------------------------------------------------------------------------------------------
Dcl-F INPSRC      DISK(256)   Usage(*INPUT:*UPDATE:*OUTPUT)
                              EXTFILE(fromFileLib)
                              EXTMBR(@pFromMbr)
                              INFDS(InpAttr)
                              USROPN;

Dcl-F OUTSRC      DISK(256)   Usage(*OUTPUT)
                              EXTFILE(toFileLib)
                              EXTMBR(@pToMbr)
                              INFDS(OutAttr)
                              USROPN;

Dcl-F CVTRPGFRP1  PRINTER     USROPN
                              OFLIND(overFlow);

//-------------------------------------------------------------------------------------------
// P R O C E D U R E   I N T E R F A C E
//-------------------------------------------------------------------------------------------

Dcl-PR CVTRPGFRER                      EXTPGM('CVTRPGFRER');
   @pShutDown                 Char(1)  CONST;
   @pFromFile                 Char(10) CONST;
   @pFromLib                  Char(10) CONST;
   @pFromMember               Char(10) CONST;
   @pToFile                   Char(10) CONST;
   @pToLib                    Char(10) CONST;
   @pToMbr                    Char(10) CONST;
   @pIndComment               Char(1)  CONST;
   @pIndIncrement           Packed(1)  CONST;
   @pRetBlnkCmt               Char(1)  CONST;
   @pRmvCmtEnd                Char(1)  CONST;
   @pRmvNonPrint              Char(1)  CONST;
   @pDirectives               Char(1)  CONST;
   @pSuppressMsgs             Char(1)  CONST;
   @pSrcFromFile              Char(10) CONST;
   @pSrcFromLib               Char(10) CONST;
   @pSrcToFile                Char(10) CONST;
   @pSrcToLib                 Char(10) CONST;
   @pConvMOVE                 Char(1)  CONST;
   @pConvKLIST                Char(1)  CONST;
   @pRetKLIST                 Char(1)  CONST;
   @pConvPLIST                Char(1)  CONST;
   @pRetPLIST                 Char(1)  CONST;
   @pOpCodeCase               Char(6)  CONST;
   @pFullyFree                Char(1)  Const;
   @pRetLineMaker             Char(1)  Const;
End-PR;

Dcl-PI CVTRPGFRER;
   @pShutDown                 Char(1)  CONST;
   @pFromFile                 Char(10) CONST;
   @pFromLib                  Char(10) CONST;
   @pFromMbr                  Char(10) CONST;
   @pToFile                   Char(10) CONST;
   @pToLib                    Char(10) CONST;
   @pToMbr                    Char(10) CONST;
   @pIndComment               Char(1)  CONST;
   @pIndIncrement           Packed(1)  CONST;
   @pRetBlnkCmt               Char(1)  CONST;
   @pRmvCmtEnd                Char(1)  CONST;
   @pRmvNonPrint              Char(1)  CONST;
   @pDirectives               Char(1)  CONST;
   @pSuppressMsgs             Char(1)  CONST;
   @pSrcFromFile              Char(10) CONST;
   @pSrcFromLib               Char(10) CONST;
   @pSrcToFile                Char(10) CONST;
   @pSrcToLib                 Char(10) CONST;
   @pConvMOVE                 Char(1)  CONST;
   @pConvKLIST                Char(1)  CONST;
   @pRetKLIST                 Char(1)  CONST;
   @pConvPLIST                Char(1)  CONST;
   @pRetPLIST                 Char(1)  CONST;
   @pOpCodeCase               Char(6)  CONST;
   @pFullyFree                Char(1)  Const;
   @pRetLineMaker             Char(1)  Const;
End-PI;

//-------------------------------------------------------------------------------------------
// P R O T O T Y P E   I N T E R F A C E S
//-------------------------------------------------------------------------------------------

// Remove message API.
Dcl-PR QMHRCVPM                        ExtPgm('QMHRCVPM');
   rcvvar                     Char(32767) Options(*varsize);
   rcvvarlen                   Int(10) Const;
   format                     Char(8)  Const;
   stack                      Char(10) Const;
   stackctr                    Int(10) Const;
   type                       Char(10) Const;
   msgkey                     Char(4)  Const;
   wait                        Int(10) Const;
   action                     Char(10) Const;
   errorcode                  Char(8)  Const;
End-PR;

Dcl-DS RCVM0100        Qualified;
   msgid                      Char(7)    Pos(13);
   msgkey                     Char(4)    Pos(22);
   msgdtalen                   Int(10)   Pos(45);
   msgdta                     Char(8000) Pos(49);
End-DS;

//-------------------------------------------------------------------------------------------
// N A M E D   C O N S T A N T S
//-------------------------------------------------------------------------------------------
Dcl-C LO                        'abcdefghijklmnopqrstuvwxyz';
Dcl-C UP                        'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
Dcl-C VALIDSPECS                'HFDCP';
Dcl-C VERSION                   '1.3.8';

//-------------------------------------------------------------------------------------------
// D A T A   S T R U C T U R E S
//-------------------------------------------------------------------------------------------

Dcl-DS InpAttr               Qualified;
   RecLen                      Int(5) Pos(125);
End-DS;

Dcl-DS OutAttr               Qualified;
   RecLen                      Int(5) Pos(125);
End-DS;

Dcl-DS InpLine            Len(256) Qualified;
   SRCSEQ               Zoned(6:2);
   SRCDAT               Zoned(6:0);
   SRCDTA                Char(240);
End-DS;

Dcl-S ptrSRCSEQ            Pointer     Inz(%addr(InpLine.SRCSEQ));
Dcl-S ptrSRCDAT            Pointer     Inz(%addr(InpLine.SRCDAT));
Dcl-S ptrSRCDTA            Pointer     Inz(%addr(InpLine.SRCDTA));

Dcl-S SRCSEQ                 Zoned(6:2) Based(ptrSRCSEQ);
Dcl-S SRCDAT                 Zoned(6:0) Based(ptrSRCDAT);
Dcl-S SRCDTA                  Char(240) Based(ptrSRCDTA);

// Fixed format line structure.
Dcl-DS SourceData                      Based(ptrSRCDTA);
   prefix                     Char(5)  Pos(1);
   lineType                   Char(1)  Pos(6);
   directive                  Char(10) Pos(7);
   codeLine                   Char(93) Pos(8);
   fullLine                   Char(94) Pos(7);

   condCtrl                   Char(2)  Pos(7);
   condNot                    Char(1)  Pos(9);
   condInd                    Char(2)  Pos(10);
   factor1                    Char(14) Pos(12);
   opCode                     Char(10) Pos(26);
   factor2                    Char(14) Pos(36);
   result                     Char(14) Pos(50);
   len                        Char(5)  Pos(64);
   dec                        Char(2)  Pos(69);
   hi                         Char(2)  Pos(71);
   lw                         Char(2)  Pos(73);
   eq                         Char(2)  Pos(75);
   comment                    Char(20) Pos(81);

   extFactor2                 Char(45) Pos(36);

   nonPrefix                  Char(95) Pos(6);

   procType                   Char(1)  Pos(24);
   procKeyWords               Char(37) Pos(44);

   declName                   Char(15) Pos(7);
   declExt                    Char(1)  Pos(22);
   declPrefix                 Char(1)  Pos(23);
   declType                   Char(2)  Pos(24);
   declSuffix                 Char(1)  Pos(26);
   declFrom                   Char(7)  Pos(26);
   declLen                    Char(7)  Pos(33);
   declAttr                   Char(1)  Pos(40);
   declScale                  Char(3)  Pos(41);
   declKeyWords               Char(37) Pos(44);
   declOptions                Char(73) Pos(7);

   fileName                   Char(10) Pos(7);
   fileUsage                  Char(1)  Pos(17);
   fileDesig                  Char(1)  Pos(18);
   fileAdd                    Char(1)  Pos(20);
   fileExternal               Char(1)  Pos(22);
   fileKeyed                  Char(1)  Pos(34);
   fileDevice                 Char(7)  Pos(36);
   fileKeywords               Char(37) Pos(44);
End-DS;

// Key Lists.
Dcl-DS parmList                              Qualified DIM(127);
   lineNumber                     Zoned(6:2);
   listName                        Char(14);
   listType                        Char(5);
   listPList                       Char(14);
   listProgram                     Char(14);
   parameterDef                              LikeDS(parameterDefDS_T) Dim(99);
   listOutput                       Ind;
   convert                          Ind;
End-DS;

Dcl-DS parameterDefDS_T                      Qualified Template;
   parmName                        Char(14);
   parmInput                       Char(14);
   parmOutput                      Char(14);
   parmDef                         Char(93);
End-DS;

// Key Lists.
Dcl-DS keyList                         Qualified DIM(127);
   listName                        Char(14);
   keyFields                       Char(93);
End-DS;

// TAGs.
Dcl-DS tagList                         Qualified DIM(127);
   tagName                         Char(14);
   tagType                         Char(14);
   tagUsed                          Ind;
   tagUsageCount                    Int(3);
End-DS;

Dcl-DS DCLPR                    QUALIFIED;
   decl                     Char(7) INZ('Dcl-PR ');
   procName                 Char(16);
   type                     Char(9);
   definition               Char(37);
   comment                  Char(23);
   fieldName                Char(80) Pos(4);
End-DS;

Dcl-DS DCLP                     QUALIFIED;
   decl                     Char(9) INZ('Dcl-Proc ');
   definition               Char(61);
   comment                  Char(23);
End-DS;

Dcl-DS DCLS                     QUALIFIED;
   decl                     Char(6) INZ('Dcl-S ');                            // aaa
   fieldName                Char(17);
   type                     Char(9);
   definition               Char(38);
   comment                  Char(23);
End-DS;

Dcl-DS DCLF                     QUALIFIED;
   decl                     Char(6) INZ('Dcl-F ');
   fileName                 Char(15);
   device                   Char(8);
   definition               Char(44);
   comment                  Char(23) Pos(70);
End-DS;

Dcl-DS DCLH                     QUALIFIED;
   decl                     Char(8) INZ('Ctl-Opt ');
   options                  Char(62);
   comment                  Char(23);
End-DS;

//-------------------------------------------------------------------------------------------
// S T A N D - A L O N E   V A R I A B L E S
//-------------------------------------------------------------------------------------------
Dcl-S cfgCommitControl      Char(7) INZ('*NONE  ');                  // *MASTER/*SLAVE/*NONE
Dcl-S cfgCloseDown          Char(1) INZ('N');                        // Close down program?
Dcl-S initialCall           Char(1) INZ(*Blank);
Dcl-S fullyFree              Ind    Inz(*Off);

Dcl-S @opCodeUP             Char(10) DIM(66) PERRCD(1) CTDATA;
Dcl-S @opCodeLO             Char(10) DIM(66) ALT(@opCodeUP);
Dcl-S @declUP               Char(10) DIM(12) PERRCD(1) CTDATA;
Dcl-S @declLO               Char(10) DIM(12) ALT(@declUP);
Dcl-S @comments             Char(92) DIM(3) CTDATA;
Dcl-S x                   Packed(5:0);
Dcl-S y                   Packed(5:0);
Dcl-S i                   Packed(5:0);
Dcl-S j                   Packed(5:0);
Dcl-S blanks                Char(30) INZ(*Blanks);
Dcl-S maxIndent           Packed(3:0) INZ(15);
Dcl-S keyListCount           Int(3);
Dcl-S keyListName           Char(14);
Dcl-S parmListCount          Int(3);
Dcl-S parmListName          Char(14);
Dcl-S tagCount               Int(5);
Dcl-S tagName               Char(14);
Dcl-S seqProcDefs          Zoned(6:2) Inz(0);

Dcl-S fromFileLib           Char(21);
Dcl-S toFileLib             Char(21);

Dcl-S operator              Char(10);
Dcl-S operatorEnd         Packed(3:0);
Dcl-S newOperator        VarChar(10);
Dcl-S nonConvRsn                LIKE(codeLine);

Dcl-S inCode                 Ind INZ(*Off);
Dcl-S inArrayData            Ind INZ(*Off);
Dcl-S inComment              Ind INZ(*Off);
Dcl-S inDeclaration          Ind INZ(*Off);
Dcl-S inPrototype            Ind INZ(*Off);
Dcl-S inInterface            Ind INZ(*Off);
Dcl-S inDatastructure        Ind INZ(*Off);
Dcl-S inLineCondition        Ind INZ(*Off);
Dcl-S reprocessLine          Ind INZ(*Off);

Dcl-S endDS                  Ind INZ(*Off);
Dcl-S inDirective            Ind INZ(*Off);
Dcl-S inFreeFormat           Ind INZ(*On);
Dcl-S indent                 Ind INZ(*Off);
Dcl-S inSpan                 Ind INZ(*Off);
Dcl-S inContinuation         Ind INZ(*Off);
Dcl-S inCase                 Ind INZ(*Off);
Dcl-S inCAB                  Ind INZ(*Off);
Dcl-S convert                Ind INZ(*Off);
Dcl-S unindent               Ind INZ(*Off);
Dcl-S defsMoved              Ind INZ(*Off);
Dcl-S defVariable           Char(80) Dim(9999);
Dcl-S procsOutput            Ind INZ(*Off);
Dcl-S dropLine               Ind INZ(*Off);
Dcl-S codeStart                 LIKE(SRCSEQ) INZ(0);
Dcl-S endLine                   LIKE(SRCSEQ) INZ(0);                 // Close struct here.
Dcl-S endFound               Ind;
Dcl-S endDeclType           Char(2);

Dcl-S savedLineType         Char(1);

Dcl-S increment           Packed(1:0) INZ(0);
Dcl-S indentCount         Packed(3:0) INZ(0);
Dcl-S indentSize          Packed(1:0) INZ(3);
Dcl-S indentOffset        Packed(3:0) INZ(0);
Dcl-S prevOffset          Packed(3:0) INZ(0);
Dcl-S currOffset          Packed(3:0) INZ(0);
Dcl-S lineEnd             Packed(3:0) INZ(0);
Dcl-S mainlineIndent      Packed(3:0) INZ(1);

Dcl-S savedSRCDTA               LIKE(SRCDTA);
Dcl-S sourceLine            Char(93);
Dcl-S overflowLine          Char(92);
Dcl-S workDirective         Char(10);
Dcl-S workLineType          Char(1);
Dcl-S workDeclType          Char(2);
Dcl-S workDeclAttr          Char(1);
Dcl-S workDeclName          Char(50);
Dcl-S workDeclLine              LIKE(SRCSEQ);

Dcl-S tempDeclType          Char(2);
Dcl-S tempDeclLine              LIKE(SRCSEQ);
Dcl-S tempSavedName         Char(80);

Dcl-S workFileUsage         Char(1);
Dcl-S workFileDesig         Char(1);
Dcl-S workFileAdd           Char(1);
Dcl-S workFileKeyed         Char(1);
Dcl-S workFileDevice        Char(7);
Dcl-S checkLength         Packed(3:0);
Dcl-S workLength          Packed(7:0);
Dcl-S workCondCtrl          Char(2);

Dcl-S savedComment          Char(20);
Dcl-S savedName             Char(80);

Dcl-S padResult              Ind INZ(*Off);
Dcl-S padTarget                 LIKE(result);

Dcl-S scanString                LIKE(factor1);
Dcl-S scanBase                  LIKE(factor2);
Dcl-S scanLength            Char(10);
Dcl-S scanStart             Char(10);
Dcl-S scanNoResult           Ind INZ(*Off);

Dcl-S substLen              Char(10);
Dcl-S substStart            Char(10);

Dcl-S setOff                 Ind INZ(*Off);
Dcl-S setOffInd1            Char(2);
Dcl-S setOffInd2            Char(2);
Dcl-S setOffInd3            Char(2);

Dcl-S setOn                  Ind INZ(*Off);
Dcl-S setOnInd1             Char(2);
Dcl-S setOnInd2             Char(2);
Dcl-S setOnInd3             Char(2);

Dcl-S xlateFrom                 LIKE(factor1);
Dcl-S xlateTo                   LIKE(factor1);
Dcl-S xlateBase                 LIKE(factor2);
Dcl-S xlateStart            Char(10);

Dcl-S caseSubRoutine        Char(10);
Dcl-S caseOperator          Char(4);

Dcl-S catFactor1                LIKE(factor1);
Dcl-S catFactor2                LIKE(factor2);
Dcl-S catCount            Packed(3:0) INZ(0);
Dcl-S catBlanks                 LIKE(factor2);

Dcl-S durDuration               LIKE(factor2);
Dcl-S durCode                   LIKE(factor2);
Dcl-S durNewDate             Ind INZ(*Off);

Dcl-S inEval                 Ind INZ(*Off);
Dcl-S evalOperator              Like(opCode);
Dcl-S evalOffset          Packed(3:0);

Dcl-S inCallP                Ind INZ(*Off);
Dcl-S callPOperator             Like(opCode);
Dcl-S callPOffset         Packed(3:0);

Dcl-S inDo                   Ind INZ(*Off);
Dcl-S doOperator                Like(opCode);
Dcl-S doCompare             Char(2);

Dcl-S inIf                   Ind INZ(*Off);
Dcl-S ifOperator                Like(opCode);
Dcl-S ifCompare             Char(2);

Dcl-S inWhen                 Ind INZ(*Off);
Dcl-S whenOperator              Like(opCode);
Dcl-S whenCompare           Char(2);

Dcl-S inSQL                  Ind INZ(*Off);

Dcl-S forCount            Packed(1:0) INZ(0);
Dcl-S forLevel            Packed(3:0) DIM(9);                           // Allow for 9
Dcl-S forFactor1                LIKE(factor1);
Dcl-S forFactor2                LIKE(factor2);

Dcl-S doCount             Packed(1:0) INZ(0);
Dcl-S doLevel             Packed(3:0) DIM(9);                           // Allow for 9

Dcl-S divFactor1                LIKE(factor1);
Dcl-S divFactor2                LIKE(factor2);

Dcl-S ERRCheck               Ind INZ(*Off);
Dcl-S ERRInd                Char(2);

Dcl-S foundCheck             Ind INZ(*Off);
Dcl-S foundInd              Char(2);

Dcl-S NRFCheck               Ind INZ(*Off);
Dcl-S NRFInd                Char(2);
Dcl-S NRFFile                   LIKE(factor2);

Dcl-S EOFCheck               Ind INZ(*Off);
Dcl-S EOFInd                Char(2);
Dcl-S EOFFile                   LIKE(factor2);

Dcl-S HICheck                Ind INZ(*Off);
Dcl-S HIInd                 Char(2);
Dcl-S HiFactor1                 LIKE(factor1);
Dcl-S HiFactor2                 LIKE(factor2);

Dcl-S LWCheck                Ind INZ(*Off);
Dcl-S LWInd                 Char(2);
Dcl-S LWFactor1                 LIKE(factor1);
Dcl-S LWFactor2                 LIKE(factor2);

Dcl-S EQCheck                Ind INZ(*Off);
Dcl-S EQInd                 Char(2);
Dcl-S EQFactor1                 LIKE(factor1);
Dcl-S EQFactor2                 LIKE(factor2);

Dcl-S CABFactor1                LIKE(factor1);
Dcl-S CABFactor2                LIKE(factor2);

Dcl-S equalCheck             Ind INZ(*Off);
Dcl-S equalInd              Char(2);

Dcl-S CALLPOutput            Ind Inz(*Off);
Dcl-S CALLPSeq             Zoned(6:2);
Dcl-S CALLPPgm              Char(14);
Dcl-S CALLPPList            Char(14);
Dcl-S CALLPIndex             Int(3);
Dcl-S CALLPx                 Int(3);

Dcl-S countSource         Packed(7:0) INZ(0);
Dcl-S countTarget         Packed(7:0) INZ(0);
Dcl-S countEligible       Packed(7:0) INZ(0);
Dcl-S countConv           Packed(7:0) INZ(0);
Dcl-S countNotConv        Packed(7:0) INZ(0);
Dcl-S countMoved          Packed(7:0) INZ(0);

Dcl-S arrayLength            Uns(3);
Dcl-S endPos                 Uns(3);
Dcl-S arrayStart         VarChar(3);
Dcl-S zz_IndArray           Char(99) Based(zz_IndArrayPtr);
Dcl-S zz_IndArrayPtr     Pointer     Inz(%addr(*IN));
/Eject
//-------------------------------------------------------------------------------------------
// Main Procedure
//-------------------------------------------------------------------------------------------
// Initialize
Exsr subInitialise;

// Perform required function
Exsr subUserFunction;

// Terminate the program.
Exsr subExitProgram;
//-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// USER: Perform required function.
//-------------------------------------------------------------------------------------------
BegSr subUserFunction;

   // ** Code the necessary processing here.
   // >>>>> Start of User-Point >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

   // Read through the source member.
   SetLL *Start INPSRC;
   Read INPSRC InpLine;

   DoW not %eof(INPSRC);
      countSource += 1;

      Exsr subUserReformatLine;

      Exsr subUserSetIndicators;

      Exsr subUserOutputCallP;

      // Old-style SCAN without a result field.
      If scanNoResult;
         Clear nonPrefix;

         codeLine = '// Old-style SCAN without a result!';
         Exsr subUserReformatLine;
         codeLine = 'EndIf;';
         Exsr subUserReformatLine;

         scanNoResult = *Off;
      EndIf;

      // If in a CAS statement, record the subroutine to call.
      If inCase and caseSubroutine <> *Blanks;
         codeLine = 'ExSr ' + %trim(caseSubRoutine) + ';';
         Exsr subUserReformatLine;
         caseSubRoutine = *Blanks;
      EndIf;

      // If in a CAB statement, record the branch point.
      If inCAB;
         lineType = *Blanks;
         If caseSubroutine = *Blanks;
         Else;
            If caseOperator <> *Blanks;
               codeLine = 'If ' + %trim(CABFactor1) + ' '
                        + %trim(caseOperator) + ' ' + %trim(CABFactor2) + ';';
               Exsr subUserReformatLine;
            EndIf;

            codeLine = 'LeaveSr;';
            Exsr subUserReformatLine;

            If caseOperator <> *Blanks;
               Clear nonPrefix;
               codeLine = 'EndIf;';
               Exsr subUserReformatLine;
            EndIf;
         EndIf;

         inCAB = *Off;
      EndIf;

      // Close off conditioning indicator group?
      If inLineCondition and reprocessLine = *Off;
         inLineCondition = *Off;
         Clear nonPrefix;
         codeLine = 'EndIf;';
         Exsr subUserReformatLine;
      EndIf;

      // Reprocess the current line?
      If reprocessLine;
         SRCDTA = savedSRCDTA;
         reprocessLine = *Off;
      Else;
         Read INPSRC InpLine;
      EndIf;
   EndDo;

   // Handle overflow.
   If overFlow;

      // Print page headings.
      Z1#PAG += 1;
      Write Z1PAGHDG;

      ZTFRFL = %trim(@pSrcFromLib) + '/' + %trim(@pSrcFromFile);
      ZTTOFL = %trim(@pSrcToLib) + '/' + %trim(@pSrcToFile);

      Write Z1TOPPAG;

      overFlow = *Off;
   EndIf;

   Z1FRMB = @pFromMbr;
   Z1TOMB = @pToMbr;
   Z1CTSC = countSource;
   Z1CTTG = countTarget;
   Z1CTEL = countEligible;
   Z1CTCV = countConv;
   Z1CTNV = countNotConv;
   Z1CTMV = countMoved;
   If countEligible = 0;
      Z1CNVR = 0;
   Else;
      Z1CNVR = countConv * 100 / countEligible;
   EndIf;

   // Print detail format.
   Write Z1DETAIL;

   // <<<<< End of User-Point   <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

EndSr;
//-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// Perform conversion/reformatting on the current line.
//-------------------------------------------------------------------------------------------
BegSr subUserReformatLine;

   inDirective = *Off;
   inComment = *Off;
   increment = 0;

   workDirective = %xlate(lo:up:directive);
   workLineType = %xlate(lo:up:lineType);

   convert = *Off;
   nonConvRsn = *Blanks;

   sourceLine = codeLine;     // Start with what is already there.

   // Array data reached?
   If %subst(prefix:1:3) = '** '
   or %subst(SRCDTA:1:8) = '**CTDATA';
      inCode = *Off;
      inDeclaration = *Off;
      inArrayData = *On;
   EndIf;

   If not inArrayData;
      //----------------------------------------------------------------------------------
      // Close off Prototype/Interface/Datastructure?
      If (inPrototype or inInterface or inDatastructure)
      and SRCSEQ >= endLine;
         If not inDatastructure
         or inDatastructure and endDS;
            savedSRCDTA = SRCDTA;
            Clear SRCDTA;
            codeLine = 'End-' + endDeclType + ';';
            writeLine();
            SRCDTA = savedSRCDTA;
         EndIf;
         inPrototype = *Off;
         inInterface = *Off;
         inDatastructure = *Off;
         inSpan = *Off;
         inDeclaration = *Off;
         workDeclName = *Blanks;
      EndIf;

      //----------------------------------------------------------------------------------
      // Determine Line Type
      If workLineType = 'C';                  // C-Spec
         inCode = *On;
      //         ElseIf workLineType = 'P'               // P-Spec
      //             or %len(%trim(codeLine)) >= 4
      //            and %xlate(lo:up:%subst(%trim(codeLine):1:4)) = 'DCL-';
      //            inCode = *Off;
      //            defsMoved = *Off;
      ElseIf workLineType = 'P';              // P-Spec
         inCode = *Off;
         defsMoved = *Off;
      ElseIf workLineType = 'D';              // Declaration.
         inCode = *Off;
      ElseIf workLineType = 'H';              // Header spec.
         inCode = *Off;
      ElseIf workLineType = 'F';              // File spec.
         inCode = *Off;
      ElseIf workLineType = 'O';              // O-Spec
         inCode = *Off;
      ElseIf workLineType = 'I';              // I-Spec
         inCode = *Off;
      ElseIf %check(validSpecs:workLineType) <> 0;    // Invalid spec type.
         workLineType = *Blanks;
         lineType = *Blank;                           // Clear it!
      EndIf;

      If %trim(workDirective) = '/FREE';
         // In a free-format directive, so we must be in code too.
         If not inFreeFormat;
            inDirective = *On;
            inCode = *On;
            inFreeFormat = *On;
            lineType = ' ';
            workLineType = ' ';
            If @pDirectives = 'Y';
               directive = '/Free';
            Else;
               dropLine = *On;
            EndIf;
         Else;
            dropLine = *On;   // Not needed.
         EndIf;
      ElseIf %trim(workDirective) = '/END-FREE';
         // At the end of a directive, so we can't be in free format any more.
         //inDirective = *On;
         //directive = '/End-Free';
         //inFreeFormat = *Off;
         dropLine = *On;
      ElseIf %trim(workDirective) = '/EJECT';
         inDirective = *On;
         lineType = ' ';
         workLineType = ' ';
      ElseIf %subst(workDirective:1:5) = '/COPY';
         inDirective = *On;
         lineType = ' ';
         workLineType = ' ';
      ElseIf %subst(workDirective:1:8) = '/INCLUDE';
         inDirective = *On;
         lineType = ' ';
         workLineType = ' ';
      ElseIf %subst(workDirective:1:3) = '/IF';
         inDirective = *On;
         lineType = ' ';
         workLineType = ' ';
      ElseIf %subst(workDirective:1:6) = '/ENDIF';
         inDirective = *On;
         lineType = ' ';
         workLineType = ' ';
      ElseIf %subst(workDirective:1:7) = '/DEFINE';
         inDirective = *On;
         lineType = ' ';
         workLineType = ' ';
      ElseIf %subst(workDirective:1:6) = '/SPACE';
         inDirective = *On;
         lineType = ' ';
         workLineType = ' ';
      ElseIf %subst(workDirective:1:6) = '/TITLE';
         inDirective = *On;
         lineType = ' ';
         workLineType = ' ';
      ElseIf (%subst(workDirective:1:1) = '*'
         or %subst(workDirective:1:2) = '//')
         and (lineType = *Blank or inCode);
         removeNonPrintable(SourceData);
         // This is a comment line.
         If @pIndComment <> 'Y' or workLineType = 'C';
            inComment = *On;
         EndIf;
         If %subst(workDirective:1:2) = '//';
            %subst(directive:1:2) = '  ';
         Else;
            %subst(directive:1:1) = ' ';
         EndIf;
         If workLineType = 'C' or workLineType = 'D';
            lineType = ' ';
            workLineType = ' ';
         EndIf;
         // Retain blank comment markers?
         If @pRetBlnkCmt = 'N' and %len(%trim(codeLine)) = 0;
         // Leave the line blank, devoid of any marker.
         Else;
            codeLine = '//' + codeLine;
         EndIf;
         removeEndCommentMarker(@pRmvCmtEnd:codeLine);
      ElseIf %subst(workDirective:1:1) = '*';
         //            and workLineType = 'O';
         // Leave the line as it is.
         inComment = *On;
         removeNonPrintable(SourceData);
         If workLineType = 'F'
         or workLineType = 'H'
         or workLineType = 'P'
         or workLineType = 'D'
         or workLineType = 'I';
            lineType = ' ';
            workLineType = ' ';
            %subst(directive:1:1) = ' ';
            codeLine = '//' + codeLine;
         EndIf;
         removeEndCommentMarker(@pRmvCmtEnd:codeLine);
      ElseIf %len(%trim(codeLine)) = 0;
         // Just a 'spacer' line - keep it but drop the line type.
         lineType = ' ';
         workLineType = ' ';
      ElseIf %len(%trim(codeLine)) >= 2
         and %subst(%trim(codeLine):1:2) = '//'
         and (workLineType = *Blank or inCode);
         // This is a comment line.
         If @pIndComment <> 'Y' or workLineType = 'C';
            inComment = *On;
         EndIf;
         removeNonPrintable(SourceData);
         // Retain blank comment markers?
         If @pRetBlnkCmt = 'N' and %len(%trim(%subst(codeLine:3)))
                                           = 0;
            // Leave the line blank, devoid of any marker.
            codeLine = *Blanks;
         EndIf;
         removeEndCommentMarker(@pRmvCmtEnd:codeLine);
      EndIf;

      //----------------------------------------------------------------------------------
      // Convert fixed-format to free-format?
      If not inComment
      and not inDirective;

         If workLineType = 'C';
            countEligible += 1;
            countNotConv += 1;
            operator = %xlate(lo:up:opCode);
            savedComment = comment;

            convertC_Spec();

            If not inComment and not convert
            and not dropLine and nonConvRsn = *Blanks;
               nonConvRsn = 'Conversion not currently supported.';
            EndIf;

         ElseIf workLineType = 'P';     // Procedure start/end.
            countEligible += 1;
            countNotConv += 1;
            operator = *Blanks;
            savedComment = comment;

            convertP_Spec();

            If not inComment and not convert
            and not dropLine and nonConvRsn = *Blanks;
               nonConvRsn = 'Conversion not currently supported.';
            EndIf;

         ElseIf workLineType = 'D';     // Declaration.
            countEligible += 1;
            countNotConv += 1;
            savedComment = comment;

            convertD_Spec();

            If not inComment and not convert
            and not dropLine and nonConvRsn = *Blanks;
            //nonConvRsn = 'Conversion not currently supported.';
            EndIf;

         ElseIf workLineType = 'F';     // File.
            countEligible += 1;
            countNotConv += 1;
            savedComment = comment;

            convertF_Spec();

            If not inComment and not convert
            and not dropLine and nonConvRsn = *Blanks;
            //nonConvRsn = 'Conversion not currently supported.';
            EndIf;

         ElseIf workLineType = 'H';     // Header.
            countEligible += 1;
            countNotConv += 1;
            savedComment = comment;

            convertH_Spec();

            If not inComment and not convert
            and not dropLine and nonConvRsn = *Blanks;
            //nonConvRsn = 'Conversion not currently supported.';
            EndIf;

         ElseIf workLineType = 'O';     // Output spec
            sourceLine = fullLine;

         ElseIf workLineType = 'I';     // Input spec
            sourceLine = fullLine;

         ElseIf workLineType = ' ' and inCode;
            inFreeFormat = *On;
            // When in an IF we usually want subsequent lines to be pulled back to be
            // in line with the 'If', but only if those lines start with either 'and'
            // or 'or'.  Otherwise we retain the existing indentation by turning on
            // inSpan.
            If inIf and %len(%trim(codeLine)) >= 3
            and %xlate(lo:up:%subst(%trim(codeLine):1:3)) <> 'AND'
            and %xlate(lo:up:%subst(%trim(codeLine):1:3)) <> 'OR ';
               inSpan = *On;
            EndIf;
            If inSpan;
               currOffset = %check(' ':codeLine);  // Offset of the continuation line.
            Else;
               prevOffset = %check(' ':codeLine);  // Offset of the parent line.
            EndIf;
            sourceLine = %trim(codeLine);         // Free-format already, so trim it.
         Else;
            inFreeFormat = *On;
            sourceLine = %trimr(codeLine);        // None of the above, use the raw source
         EndIf;

         // Converted?
         If convert;
            countConv += 1;
            countNotConv -= 1;
            // Switch to free-format?
            If not inFreeFormat and not inDeclaration;
               If @pDirectives = 'Y';
                  savedSRCDTA = SRCDTA;
                  Clear SRCDTA;
                  directive = '/Free';
                  writeLine();
                  SRCDTA = savedSRCDTA;
               EndIf;
               inFreeFormat = *On;
//               directive = *Blanks;
            EndIf;
         Else;
            convert = convert;
         EndIf;

         // Revert to fixed-format?
         If not convert and (lineType <> *Blanks
         or %subst(workDirective:1:5) = '/COPY' or %subst(workDirective:1:8) = '/INCLUDE');
            //                or  %subst(prefix:1:3) = '** ');        // Array data reached
            If inFreeFormat and not inDeclaration;
               If @pDirectives = 'Y';
                  savedSRCDTA = SRCDTA;
                  Clear SRCDTA;
                  directive = '/End-Free';
                  writeLine();
                  SRCDTA = savedSRCDTA;
               EndIf;
               inFreeFormat = *Off;
//               If not inDirective;
//                  directive = *Blanks;
//               EndIf;
            EndIf;
            // Record the reason for not converting?
            If nonConvRsn <> *Blanks and @pSuppressMsgs <> 'Y';
               savedSRCDTA = SRCDTA;
               Clear SRCDTA;
               codeLine = '// >>>>> Not converted: ' + nonConvRsn;
               writeLine();
               SRCDTA = savedSRCDTA;
            EndIf;
            inSpan = *Off;
         EndIf;
      Else;
         // Use source exactly as is.
         sourceLine = codeLine;
      EndIf;

      //----------------------------------------------------------------------------------
      // If we are in a code section, check if indent is affected at all.
      //         If not inDeclaration
      //         and not inDirective
      If not inDirective
      and not inComment
      and not dropLine;
         // Isolate the operator to check indentation against.
         //sourceLine = %trimr(codeLine);
         If inFreeFormat;
            If %subst(sourceLine:1:2) = '//';            // Comment - no operator.
               operator = *Blanks;
            ElseIf inSQL;                                // Embedded SQL - no operator.
               operator = *Blanks;
            Else;
               // Isolate the 'operator' (first word really).
               operator = %trim(sourceLine);
               operatorEnd = %scan(';':%trim(operator)); // Isolate the actual code.
               If operatorEnd > 0;
                  operator = %subst(operator:1:operatorEnd-1);
               EndIf;
               operatorEnd = %scan(' ':%trim(operator)); // Look for end of first 'word'.
               If operatorEnd = 0;
                  operatorEnd = %scan(';':operator);  // Only one word - is it an operator
                  If operatorEnd = 0;
                     operatorEnd = %scan('(':operator);  // Shouldn't match!
                  EndIf;
               EndIf;
               // If we have an operator, remove any attached extender code.
               If operatorEnd > 0;
                  operator = %subst(operator:1:operatorEnd - 1);
                  // Exec SQL?
                  If %xlate(lo:up:operator) = 'EXEC';
                     If %scan('SQL':%xlate(lo:up:%trim(sourceLine)):6)
                              > 0;
                        operator = 'Exec SQL';
                        inSQL = *On;
                     EndIf;
                  EndIf;
                  operatorEnd = %scan('(':operator);
                  If operatorEnd > 1;
                     operator = %subst(operator:1:operatorEnd - 1);
                  EndIf;
               EndIf;

               If %lookup(%xlate(lo:up:operator):@opCodeUP) > 0
               and not inDeclaration and workLineType <> 'D';
                  inCode = *On;
               Else;
                  If %lookup(%xlate(lo:up:operator):@declUP) > 0
                  or inDeclaration;
                  // Declaration!
                  Else;
                     // Not an operator!
                     operator = *Blanks;
                     x = %scan('//':sourceLine);
                     If x = 0;
                        x = %len(sourceLine);
                     Else;
                        x = x - 1;
                        If x < 1;
                           x = 1;
                        EndIf;
                     EndIf;
/if defined(V7R3M0)
                     y = %scan('=':sourceLine:1:x);
/else
                     y = %scan('=':sourceLine:1);
                     If y >= x;
                        y = 0;
                     EndIf;
/endif
                     If y > 0;   // Looks like an assignment.
                        operator = '=';
                        inCode = *On;
                        If workLineType = *Blank;
                           sourceLine = %trim(sourceLine);
                        EndIf;
                     EndIf;
                  EndIf;
               EndIf;
            EndIf;
         Else;
            If %subst(sourceLine:1:2) = '//';            // Comment - no operator.
               operator = *Blanks;
            Else;
               operator = %xlate(lo:up:opCode);
               If %subst(operator:1:4) <> 'EVAL'
               and operator <> *Blanks;
                  // Strip out in-line definitions.
                  len = *Blanks;
                  dec = *Blanks;
               EndIf;
            EndIf;
         EndIf;

         // Convert to upper case for check.
         operator = %xlate(lo:up:operator);

         // Check for indentation level change.
         Select;
            When workDirective = '/EXEC SQL';
               increment = 1;
               inSQL = *On;
            When workDirective = '/END-EXEC';
               unindent = *On;
               increment = -1;
               dropLine = *On;
            When inSQL;
            // Do nothing.
            When %subst(operator:1:2) = 'IF';
               increment = 1;
               inIf = *On;
            When %subst(operator:1:2) = 'DO';
               increment = 1;
               inDo = *On;
               doCount += 1;
               doLevel(doCount) = indentCount;
            When operator = 'FOR';
               increment = 1;
               forCount += 1;
               forLevel(forCount) = indentCount;
            When operator = 'SELECT';
               increment = 2;
            When operator = 'BEGSR';
               increment = 1;
               mainlineIndent = 0;
               indentCount = mainlineIndent;
            When %subst(operator:1:4) = 'DCL-';
               increment = 1;
               mainlineIndent = 0;
               indentCount = mainlineIndent;
               defsMoved = *Off;
            When %subst(operator:1:4) = 'END-';
               increment = 0;
               indentCount = 0;
            When operator = 'MONITOR';
               increment = 1;
            When operator = 'ENDSL';
               unindent = *On;
               increment = -2;
            When operator = 'ENDCS';
               Operator = 'ENDIF';
               unindent = *On;
               increment = -1;
            When operator = 'ENDDO';
               unindent = *On;
               increment = -1;
               doCount -= 1;
            When operator = 'ENDFOR';
               unindent = *On;
               increment = -1;
               forCount -= 1;
            When %subst(operator:1:3) = 'END';
               unindent = *On;
               increment = -1;
            When %subst(operator:1:4) = 'ELSE'; // Unindent ELSE
               unindent = *On;
               indent = *On;
               increment = -1;
            When %subst(operator:1:2) = 'OR';   // Unindent OR
               unindent = *On;
               indent = *On;
               increment = -1;
            When %subst(operator:1:3) = 'AND';  // Unindent AND
               unindent = *On;
               indent = *On;
               increment = -1;
            When operator = 'ON-ERROR';         // Unindent On-Error
               unindent = *On;
               indent = *On;
               increment = -1;
            When %subst(operator:1:4) = 'WHEN' or inWhen;
               unindent = *On;
               indent = *On;
               increment = -1;
               inWhen = *On;
            When inIF or inDo;                  // Keep conditions in line.
               unindent = *On;
               indent = *On;
               increment = -1;
            When operator = 'OTHER';             // Unindent Other
               unindent = *On;
               indent = *On;
               increment = -1;
            Other;
               increment = 0;
         EndSl;
      ElseIf inDeclaration;
      EndIf;

      //----------------------------------------------------------------------------------
      // Start of code?  If so, pause here and move all field definitions to D-specs.
      If not procsOutput and SRCSEQ >= seqProcDefs;
         If inComment or %subst(sourceLine:1:2) = '//' or sourceLine = *Blanks;
            seqProcDefs = SRCSEQ + 0.01;
         Else;
            outputPrototypeDefs();
         EndIf;
      EndIf;

      //----------------------------------------------------------------------------------
      // Start of code?  If so, pause here and move all field definitions to D-specs.
      If (inCode or workLineType = 'I') and not defsMoved;
         moveDefinitions();
         Clear defVariable;
      EndIf;

      //----------------------------------------------------------------------------------
      // If we need to temporarily unindent, do so to the requested increment.
      If unindent;
         indentCount += increment;
         increment = 0;
         unindent = *Off;
      EndIf;

      //----------------------------------------------------------------------------------
      // If we are in a code section and in free-format, perform reformatting.
      //If inCode and inFreeFormat and not inDirective
      If inFreeFormat
      and not inDirective
      and sourceLine <> *Blanks
      and not inComment
      and not dropLine;       //  and not inSpan
         // Derive reformatted opcode (if any)
         x = %lookup(operator:@opCodeUP);
         If x > 0;
            newOperator = %trim(@opCodeLO(x));
         Else;
            x = %lookup(operator:@declUP);
            If x > 0;
               newOperator = %trim(@declLO(x));
            Else;
               // Not a valid operator, check if this is a comment.
               x = %scan('//':%trim(sourceLine));
               If x = 1;
                  inComment = *On;
                  newOperator = '';
                  operator = *Blanks;
               Else;
                  newOperator = '';
               EndIf;
            EndIf;
         EndIf;

         // Use new opcode if it exists.
         If %len(newOperator) > 0;
            newOperator = setOpCodeCase(newOperator:@pOpCodeCase);
            If %len(%trim(sourceLine)) > %len(newOperator);
               sourceLine = %trim(%subst(%trim(sourceLine)
                                :%len(newOperator) + 1));
            Else;
               //                  sourceLine = %trim(%subst(%trim(sourceLine)
               //                                   :%len(newOperator)));
               sourceLine = *Blanks;
            EndIf;
            // Insert a spcace after operator if it's not the end of the line
            // and there's no operation extender.
            If %subst(sourceLine:1:1) <> ';'
            and (%subst(sourceLine:1:1) <> '('
              or %subst(sourceLine:1:1) = '('
             and %subst(sourceLine:3:1) <> ')'
             and %subst(sourceLine:4:1) <> ')');
               sourceLine = ' ' + sourceLine;
            EndIf;
            sourceLine = newOperator + sourceLine;
         EndIf;

         If inCode;
            // Padding required?
            If padResult;
               savedSRCDTA = SRCDTA;
               Clear codeLine;
               %subst(codeLine:indentOffset)
                     = %trim(padTarget) + ' = *Blanks;';
               writeLine();
               SRCDTA = savedSRCDTA;
               padResult = *Off;
            EndIf;

            // Determine the indentation to use.
            If indentCount > maxIndent;
               indentOffset = maxIndent * indentSize + 1;
            Else;
               indentOffset = indentCount * indentSize + 1;
            EndIf;

            // Adjust for continuation lines.
            If inCallP and (%subst(operator:1:5) <> 'CALLP');
               indentOffset += callPOffset;
            ElseIf inEval and (%subst(operator:1:4) <> 'EVAL');
               indentOffset += evalOffset;
            ElseIf inSpan;
               indentOffset = currOffset + (indentOffset - prevOffset);
            EndIf;

            // Avoid losing code off of the right hand side (comments mainly).
            If %len(%trimr(sourceLine)) + indentOffset > 93;
               indentOffset = 93 - %len(%trim(sourceLine));
            EndIf;

            // For code lines, check for overflow, and unindent accordingly if it does,
            If not inComment;
               lineEnd = %scan(';':%trimr(sourceLine));
               If lineEnd = 0;   // Code already spans to next line.
                  lineEnd = %scan('//':sourceLine);
                  If lineEnd > 0;
                     lineEnd
                       = %len(%trimr(%subst(sourceLine:1:lineEnd-1)));
                  Else;
                     lineEnd = %len(%trimr(sourceLine));
                  EndIf;
                  If not inIf and not inDo and not inWhen;
                     inSpan = *On;
                  EndIf;
               EndIf;
            EndIf;

            // Cater for commented out code that extends into comments.
            If indentOffset + lineEnd > 74;
               //Exsr subUserWrapLine;
               indentOffset -= ((indentOffset + lineEnd) - 74);
            EndIf;

            // Ensure that we don't go back too far!
            If indentOffset < 1;
               indentOffset = 1;
            EndIf;

            savedSRCDTA = SRCDTA;
            Clear codeLine;
            %subst(codeLine:indentOffset) = %trimr(sourceLine);
            // Append an in-line comment?
            If (convert or setOn or setOff)
            and savedComment <> *Blanks;
               %subst(codeLine:71) = '// ' + savedComment;
               savedComment = *Blanks;
            EndIf;
            sourceLine = codeLine;
            SRCDTA = savedSRCDTA;
         EndIf;   // inCode
      EndIf;
   EndIf;

   //----------------------------------------------------------------------------------
   // Output the formatted line (and any overflows that have occurred.
   If not dropLine;
      If convert;
         Clear nonPrefix;
      EndIf;
      If inCode or inArrayData
      or lineType = *Blank or %subst(directive:1:1) = '*';
         codeLine = %trimr(sourceLine);
      Else;
         fullLine = %trimr(sourceLine);
      EndIf;
      writeLine();

      // Overflow line?
      If overFlowLine <> *Blanks;
         Clear sourceLine;
         indentOffset = 74 - %len(%trim(overflowLine));
         %subst(sourceLine:indentOffset)
               = %trim(overflowLine);
         codeLine = sourceLine;
         overflowLine = *Blanks;
         writeLine();
      EndIf;
   Else;
      dropLine = *Off;
   EndIf;

   indentCount += increment;

   // Following a WHEN or ON-ERROR or ELSE, code should be indented again.
   If indent;
      indentCount += 1;
      indent = *Off;
   // Following ENDSR, we should revert to mainline indentation.
   ElseIf operator = 'ENDSR';
      indentCount = mainlineIndent;
      inCode = *Off;
   EndIf;

   // If spanning a line, check if the current line ends the span.
   If (inSpan or inIf or inDo or inWhen or inCallP or inEval
   or inSQL or inDeclaration)
   and not inComment;
      If inDeclaration;

/if defined(V7R3M0)
         lineEnd = %scan(';':sourceLine:1:80);
/else
         lineEnd = %scan(';':sourceLine:1);
         If lineEnd >= 80;
            lineEnd = 0;
         EndIf;
/endif

         If lineEnd > 0;
            If %len(%trim(%subst(sourceLine:lineEnd+1:80-lineEnd))) > 0;
               lineEnd = 0;   // Not really the end of the line.
            EndIf;
         EndIf;
      Else;
         lineEnd = %scan(';':%trim(sourceLine));
      EndIf;
      If lineEnd <> 0;
         inSpan = *Off;
         inIf = *Off;
         inDo = *Off;
         inWhen = *Off;
         inCallP = *Off;
         inEval = *Off;
         inSQL = *Off;
         inDeclaration = *Off;
      EndIf;
   EndIf;

EndSr;
//-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Set Resulting Indicators.
 //-------------------------------------------------------------------------------------------
 BegSr subUserSetIndicators;

    //-----------------------------------------------------------------------
    // Scan found.
    If foundCheck;
       Clear nonPrefix;

       codeLine = '*IN' + foundInd + ' = %found();';
       Exsr subUserReformatLine;

       foundCheck = *Off;
    EndIf;

    //-----------------------------------------------------------------------
    // Error indicator check.
    If ERRCheck;
       Clear nonPrefix;

       codeLine = '*IN' + ERRInd + ' = %error();';
       Exsr subUserReformatLine;

       ERRCheck = *Off;
    EndIf;

    //-----------------------------------------------------------------------
    // Record not found check.
    If NRFCheck;
       Clear nonPrefix;

       codeLine = '*IN' + NRFInd + ' = not %found();';
       Exsr subUserReformatLine;

       NRFCheck = *Off;
    EndIf;

    //-----------------------------------------------------------------------
    // End of File check.
    If EOFCheck;
       Clear nonPrefix;

       codeLine = '*IN' + EOFInd + ' = %eof();';
       Exsr subUserReformatLine;

       EOFCheck = *Off;
    EndIf;

    //-----------------------------------------------------------------------
    // Matching Key check.
    If equalCheck;
       Clear nonPrefix;

       codeLine = '*IN' + equalInd + ' = %equal();';
       Exsr subUserReformatLine;

       equalCheck = *Off;
    EndIf;

    //-----------------------------------------------------------------------
    // Perform SETOFF / SETON Expansion.
    If setOff;
       Clear nonPrefix;
       If setOffInd1 <> *Blanks;
          codeLine = '*IN' + setOffInd1 + ' = *Off;';
          Exsr subUserReformatLine;
       EndIf;
       If setOffInd2 <> *Blanks;
          codeLine = '*IN' + setOffInd2 + ' = *Off;';
          Exsr subUserReformatLine;
       EndIf;
       If setOffInd3 <> *Blanks;
          codeLine = '*IN' + setOffInd3 + ' = *Off;';
          Exsr subUserReformatLine;
       EndIf;
       setOff = *Off;
    EndIf;
    If setOn;
       Clear nonPrefix;
       If setOnInd1 <> *Blanks;
          codeLine = '*IN' + setOnInd1 + ' = *On;';
          Exsr subUserReformatLine;
       EndIf;
       If setOnInd2 <> *Blanks;
          codeLine = '*IN' + setOnInd2 + ' = *On;';
          Exsr subUserReformatLine;
       EndIf;
       If setOnInd3 <> *Blanks;
          codeLine = '*IN' + setOnInd3 + ' = *On;';
          Exsr subUserReformatLine;
       EndIf;
       setOn = *Off;
    EndIf;

    //-----------------------------------------------------------------------
    // Resulting indicators...

    // Turn off all specified indicators first.
    If HICheck;
       Clear nonPrefix;
       codeLine = '*IN' + HIInd + ' = *Off;';
       Exsr subUserReformatLine;
    EndIf;
    If LWCheck;
       Clear nonPrefix;
       codeLine = '*IN' + LWInd + ' = *Off;';
       Exsr subUserReformatLine;
    EndIf;
    If EQCheck;
       Clear nonPrefix;
       codeLine = '*IN' + EQInd + ' = *Off;';
       Exsr subUserReformatLine;
    EndIf;

    // And now turn on those specified accordingly.

    // HI check.
    If HICheck;
       Clear nonPrefix;

       codeLine = 'If ' + %trim(HIFactor1) + ' > '
                + %trim(HIFactor2) + ';';
       Exsr subUserReformatLine;
       codeLine = '*IN' + HIInd + ' = *On;';
       Exsr subUserReformatLine;
       codeLine = 'EndIf;';
       Exsr subUserReformatLine;

       HICheck = *Off;
    EndIf;

    // LO check.
    If LWCheck;
       Clear nonPrefix;

       codeLine = 'If ' + %trim(LWFactor1) + ' < '
                + %trim(LWFactor2) + ';';
       Exsr subUserReformatLine;
       codeLine = '*IN' + LWInd + ' = *On;';
       Exsr subUserReformatLine;
       codeLine = 'EndIf;';
       Exsr subUserReformatLine;

       LWCheck = *Off;
    EndIf;

    // EQ check.
    If EQCheck;
       Clear nonPrefix;

       codeLine = 'If ' + %trim(EQFactor1) + ' = '
                + %trim(EQFactor2) + ';';
       Exsr subUserReformatLine;
       codeLine = '*IN' + EQInd + ' = *On;';
       Exsr subUserReformatLine;
       codeLine = 'EndIf;';
       Exsr subUserReformatLine;

       EQCheck = *Off;
    EndIf;

EndSr;
//-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Output a new CALLP?
 //-------------------------------------------------------------------------------------------
 BegSr subUserOutputCallP;

   // Flagged to output a callp?
   If CALLPOutput;
//         CALLPSeq = SRCSEQ;
//         CALLPPgm = parmListName;
//         CALLPPList = parmList(x).listName;
//         CALLPOutput = *On;

      // Move input parameters?
      For CALLPx = 1 to %elem(parmList);
         If parmList(CALLPIndex).parameterDef(CALLPx).parmName = *Blanks;
            writeLine('');
            Leave;
         EndIf;
         If parmList(CALLPIndex).parameterDef(CALLPx).parmInput <> *Blanks
         and parmList(CALLPIndex).parameterDef(CALLPx).parmInput <>
             parmList(CALLPIndex).parameterDef(CALLPx).parmName;
            codeLine = %trim(parmList(CALLPIndex).parameterDef(CALLPx).parmName)
                  + ' = '
                  + %trim(parmList(CALLPIndex).parameterDef(CALLPx).parmInput)
                  + ';';
            Exsr subUserReformatLine;
         EndIf;
      EndFor;

      // Output the actual CALLP.
      codeLine = 'CallP ' + %trim(%scanrpl('''':'':CALLPPgm)) + '(';
      Exsr subUserReformatLine;

      callPOffset = %len(%trim(codeLine))-1;
      inCallP = *On;

      For CALLPx = 1 to %elem(parmList);
         If parmList(CALLPIndex).parameterDef(CALLPx).parmName = *Blanks;
            Leave;
         EndIf;
         If CALLPx > 1;
           codeLine = ':'
                    + %trim(parmList(CALLPIndex).parameterDef(CALLPx).parmName);
         Else;
           codeLine = %trim(parmList(CALLPIndex).parameterDef(CALLPx).parmName);
         EndIf;
         Exsr subUserReformatLine;
      EndFor;

      codeLine = ');';
      Exsr subUserReformatLine;
      inCallP = *Off;

      // Move output parameters?
      For CALLPx = 1 to %elem(parmList);
         If parmList(CALLPIndex).parameterDef(CALLPx).parmName = *Blanks;
            writeLine('');
            Leave;
         EndIf;
         If parmList(CALLPIndex).parameterDef(CALLPx).parmOutput <> *Blanks
         and parmList(CALLPIndex).parameterDef(CALLPx).parmOutput <>
             parmList(CALLPIndex).parameterDef(CALLPx).parmName;
            codeLine = %trim(parmList(CALLPIndex).parameterDef(CALLPx).parmOutput)
                  + ' = '
                  + %trim(parmList(CALLPIndex).parameterDef(CALLPx).parmName)
                  + ';';
            Exsr subUserReformatLine;
         EndIf;
      EndFor;

      CALLPOutput = *Off;
   EndIf;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// Perform line wrap.
//-------------------------------------------------------------------------------------------
BegSr subUserWrapLine;

   x = (indentOffset + lineEnd) - 74;
   x = %len(%trimr(codeLine)) - x;

   // Scan backwards through the line, looking for a place to break it.
   For x = x downto 1;
      If %scan(%subst(codeLine:x:1):' :)(') > 0;
         // Break here, and put the rest into a new line.
         overflowLine = %subst(codeLine:x);
         codeLine = %subst(codeLine:1:x-1);
         Leave;
      EndIf;
   EndFor;

EndSr;
//-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// Exit the program directly.
//-------------------------------------------------------------------------------------------
BegSr subExitProgram;

   Exsr subUserExitProgram;     // Perform any user-specified exit processing.

   // If commitment control is active, a commit should have been done if everything
   // was OK, so issue a rollback here to catch and remove any uncommitted changes.
   If cfgCommitControl = '*MASTER';
      RolBk;
   EndIf;

   If cfgCloseDown = 'Y';
      *INLR = *On;                  // Close down the program.
   EndIf;

   Return;                          // Exit the program.

EndSr;
//-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// USER: Exit processing.
//-------------------------------------------------------------------------------------------
BegSr subUserExitProgram;

   // ** Place any program-specific exit code here.
   // >>>>> Start of User-Point >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

   If @pShutDown <> 'Y';
      Close INPSRC;
      Close OUTSRC;
   EndIf;

   If @pShutDown = 'Y' and initialCall <> 'Y';
      cfgCloseDown = 'Y';
      Write Z1ENDRPT;
      Close CVTRPGFRP1;
   EndIf;

   // <<<<< End of User-Point   <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

EndSr;
//-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// Initialisation
//-------------------------------------------------------------------------------------------
BegSr subInitialise;

   // Flag initial call.
   If initialCall = *Blank;
      initialCall = 'Y';
   Else;
      initialCall = 'N';
   EndIf;

   // Perform user-specified intialisation processing.
   Exsr subUserInitialise;

EndSr;
//-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// USER: Initialisation
//-------------------------------------------------------------------------------------------
BegSr subUserInitialise;

   // Set configuration/processing options:
   cfgCommitControl   = '*NONE  '; // Commitment control setting: *MASTER/*SLAVE
   cfgCloseDown       = 'Y';       // Close down the program on exit?


   // >>>>> Start of User-Point >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

   // Shut down?
   If @pShutDown = 'Y';
      Exsr subExitProgram;
   EndIf;

   // Open audit report.
   If initialCall = 'Y';
      Open CVTRPGFRP1;
      Z1#TTL = 'RPG/ILE to Free-Format Conversion Report';
      overflow = *On;
   EndIf;

   fromFileLib = %trim(@pFromLib) + '/' + %trim(@pFromFile);
   Open INPSRC;

   // Remove the "Buffer length longer than record"
   // message from the job log.

   QMHRCVPM( RCVM0100: %size(RCVM0100): 'RCVM0100'
           : '*': 0: '*DIAG': *blanks
           : 0: '*REMOVE': x'00000008');

   toFileLib = %trim(@pToLib) + '/' + %trim(@pToFile);
   Open OUTSRC;

   // Remove the "Buffer length longer than record"
   // message from the job log.

   QMHRCVPM( RCVM0100: %size(RCVM0100): 'RCVM0100'
           : '*': 0: '*DIAG': *blanks
           : 0: '*REMOVE': x'00000008');

   Reset countSource;
   Reset countTarget;
   Reset countEligible;
   Reset countConv;
   Reset CountNotConv;
   countMoved = 0;

   Reset maxIndent;
   Reset inCode;
   Reset inArrayData;
   Reset indentCount;

   indentCount = mainlineIndent;

   indentSize = @pIndIncrement;

   // Renumber the input source because we use line numbers for positioning.
   renumberSource();

   // Extract the paramater list definitions.
   extractParameterLists();

   // Extract the key list definitions.
   extractKeyLists();

   // Extract the tags in the source.
   tagCount = extractTAGs();

   If @pFullyFree = 'Y';
      fullyFree = *On;
      Clear inpLine;
      codeLine = '**FREE';
      writeLine();
   Else;
      fullyFree = *Off;
   EndIf;

   Clear inpLine;
   codeLine = '// Converted from '
            + %trim(@pSrcFromLib) + '/' + %trim(@pSrcFromFile) + '(' + %trim(@pFromMbr)
            + ') to '
            + %trim(@pSrcToLib) + '/' + %trim(@pSrcToFile) + '(' + %trim(@pToMbr) + ').';
   writeLine();
   codeLine = '// Converted with CVTRPGFREE version ' + VERSION + ' on '
            + %char(%timestamp():*ISO) + '.';
   writeLine();
   codeLine = '// Go to https://sourceforge.net/projects/cvtrpgfree/ for support and updates.';
   writeLine();

   // <<<<< End of User-Point   <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

EndSr;
//-------------------------------------------------------------------------------------------
//===========================================================================================

/Eject
//==========================================================================================
// Convert C-Spec
//==========================================================================================
Dcl-Proc convertC_Spec;

// -- Procedure Interface ------------------------------------------------------------------
Dcl-PI *N;
End-PI;

// -- Data Structures ----------------------------------------------------------------------

// -- Variables ----------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------

//////   // Move Prototype Definitions to here?
//////   If seqProcDefs = 0;
//////      seqProcDefs = SRCSEQ - 0.01;
//////   EndIf;

// Control indicators
If condCtrl <> *Blanks;
   workCondCtrl = %xlate(LO:UP:condCtrl);

   If workCondCtrl <> 'AN'
   and workCondCtrl <> 'OR'
   and workCondCtrl <> 'SR'
   and workCondCtrl <> '/E'
   and workCondCtrl <> '+ ';
      nonConvRsn = 'Control indicators are not currently supported.';
      Return;
   EndIf;
Else;
   workCondCtrl = *Blanks;
EndIf;

//----------------------------------------------------------------------------------
// Conditioning indicators
If condInd <> *Blanks
   and workCondCtrl <> '/E'
   and workCondCtrl <> '+ ';
   Exsr subUserCvt_Conditioning;
   Return;
EndIf;

Select;
   // Keep blank lines.
   When codeLine = *Blanks;
      sourceLine = *Blanks;
      convert = *On;

   //----------------------------------------------------------------------------------
   // EXEC SQL
   When workDirective = '/EXEC SQL' or inSQL;
      Exsr subUserCvt_EXEC_SQL;

   //----------------------------------------------------------------------------------
   // END-EXEC
   When workDirective = '/END-EXEC';
      convert = *On;

   //----------------------------------------------------------------------------------
   // ACQ.
   When %subst(operator:1:3) = 'ACQ';
      Exsr subUserCvt_ACQ;

   //----------------------------------------------------------------------------------
   // ADDDUR.
   When %subst(operator:1:6) = 'ADDDUR';
      Exsr subUserCvt_ADDDUR;

   //----------------------------------------------------------------------------------
   // ADD.
   When %subst(operator:1:3) = 'ADD';
      Exsr subUserCvt_ADD;

   //----------------------------------------------------------------------------------
   // ALLOC.
   When %subst(operator:1:5) = 'ALLOC';
      Exsr subUserCvt_ALLOC;

   //----------------------------------------------------------------------------------
   // BEGSR
   When operator = 'BEGSR';
      Exsr subUserCvt_BEGSR;

   //----------------------------------------------------------------------------------
   // CABxx
   When %subst(operator:1:3) = 'CAB';
      Exsr subUserCvt_CABxx;

   //----------------------------------------------------------------------------------
   // CALLB
   When %subst(operator:1:5) = 'CALLB';
      Exsr subUserCvt_CALLB;

   //----------------------------------------------------------------------------------
   // CALLP
   When %subst(operator:1:5) = 'CALLP' or inCallP;
      Exsr subUserCvt_CALLP;

   //----------------------------------------------------------------------------------
   // CALL
   When %subst(operator:1:4) = 'CALL';
      Exsr subUserCvt_CALL;

   //----------------------------------------------------------------------------------
   // CASxx
   When %subst(operator:1:3) = 'CAS';
      Exsr subUserCvt_CASxx;

   //----------------------------------------------------------------------------------
   // CAT
   When %subst(operator:1:3) = 'CAT';
      Exsr subUserCvt_CAT;

   //----------------------------------------------------------------------------------
   // CHAIN
   When %subst(operator:1:5) = 'CHAIN';
      Exsr subUserCvt_CHAIN;

   //----------------------------------------------------------------------------------
   // CHECK
   When %subst(operator:1:5) = 'CHECK';
      Exsr subUserCvt_CHECKx;

   //----------------------------------------------------------------------------------
   // CLEAR
   When %subst(operator:1:5) = 'CLEAR';
      Exsr subUserCvt_CLEAR;

   //----------------------------------------------------------------------------------
   // CLOSE
   When %subst(operator:1:5) = 'CLOSE';
      Exsr subUserCvt_CLOSE;

   //----------------------------------------------------------------------------------
   // COMMIT
   When %subst(operator:1:6) = 'COMMIT';
      Exsr subUserCvt_COMMIT;

   //----------------------------------------------------------------------------------
   // COMP
   When operator = 'COMP';
      Exsr subUserCvt_COMP;

   //----------------------------------------------------------------------------------
   // DEALLOC.
   When %subst(operator:1:7) = 'DEALLOC';
      Exsr subUserCvt_DEALLOC;

   //----------------------------------------------------------------------------------
   // DEFINE
   When operator = 'DEFINE';
      dropLine = *On;
      convert = *On;

   //----------------------------------------------------------------------------------
   // DELETE
   When %subst(operator:1:6) = 'DELETE';
      Exsr subUserCvt_DELETE;

   //----------------------------------------------------------------------------------
   // DIV (not half-adjusted)
   When operator = 'DIV';
      Exsr subUserCvt_DIV;

   //----------------------------------------------------------------------------------
   // DOxxx
   When %subst(operator:1:2) = 'DO'
   and (%subst(operator:3:3) = 'WEQ'
   or %subst(operator:3:2) = 'W '
   or %subst(operator:3:2) = 'U '
   or %subst(operator:3:3) = 'WGT'
   or %subst(operator:3:3) = 'WLT'
   or %subst(operator:3:3) = 'WNE'
   or %subst(operator:3:3) = 'WGE'
   or %subst(operator:3:3) = 'WLE'
   or %subst(operator:3:3) = 'UEQ'
   or %subst(operator:3:3) = 'UGT'
   or %subst(operator:3:3) = 'ULT'
   or %subst(operator:3:3) = 'UNE'
   or %subst(operator:3:3) = 'UGE'
   or %subst(operator:3:3) = 'ULE'
   or %subst(operator:3:3) = '   ')
   or inDo;
      Exsr subUserCvt_DO;

   //----------------------------------------------------------------------------------
   // DSPLY
   When %subst(operator:1:5) = 'DSPLY';
      Exsr subUserCvt_DSPLY;

   //----------------------------------------------------------------------------------
   // DUMP
   When %subst(operator:1:4) = 'DUMP';
      Exsr subUserCvt_DUMP;

   //----------------------------------------------------------------------------------
   // ELSE
   When operator = 'ELSE';
      Exsr subUserCvt_ELSE;

   //----------------------------------------------------------------------------------
   // ELSEIF
   When operator = 'ELSEIF';
      Exsr subUserCvt_ELSEIF;

   //----------------------------------------------------------------------------------
   // ENDxx
   When %subst(operator:1:3) = 'END';
      Exsr subUserCvt_ENDxx;

   //----------------------------------------------------------------------------------
   // EVALx
   When %subst(operator:1:4) = 'EVAL' or inEval;
      Exsr subUserCvt_EVALx;

   //----------------------------------------------------------------------------------
   // EXCEPT
   When operator = 'EXCEPT';
      Exsr subUserCvt_EXCEPT;

   //----------------------------------------------------------------------------------
   // EXFMT
   When %subst(operator:1:5) = 'EXFMT';
      Exsr subUserCvt_EXFMT;

   //----------------------------------------------------------------------------------
   // EXSR
   When operator = 'EXSR';
      Exsr subUserCvt_EXSR;

   //----------------------------------------------------------------------------------
   // EXTRCT
   When %subst(operator:1:6) = 'EXTRCT';
      Exsr subUserCvt_EXTRCT;

   //----------------------------------------------------------------------------------
   // FEOD
   When %subst(operator:1:4) = 'FEOD';
      Exsr subUserCvt_FEOD;

   //----------------------------------------------------------------------------------
   // FOR
   When operator = 'FOR';
      Exsr subUserCvt_FOR;

   //----------------------------------------------------------------------------------
   // FORCE
   When operator = 'FORCE';
      Exsr subUserCvt_FORCE;

   //----------------------------------------------------------------------------------
   // GOTO
   When %subst(operator:1:4) = 'GOTO';
      Exsr subUserCvt_GOTO;

   //----------------------------------------------------------------------------------
   // IFxx
   When %subst(operator:1:2) = 'IF' or inIf;
      Exsr subUserCvt_IF;

   //----------------------------------------------------------------------------------
   // IN
   When %subst(operator:1:2) = 'IN';
      Exsr subUserCvt_IN;

   //----------------------------------------------------------------------------------
   // ITER
   When operator = 'ITER';
      Exsr subUserCvt_ITER;

   //----------------------------------------------------------------------------------
   // KFLD
   When operator = 'KFLD';
      Exsr subUserCvt_KFLD;

   //----------------------------------------------------------------------------------
   // KLIST
   When operator = 'KLIST';
      Exsr subUserCvt_KLIST;

   //----------------------------------------------------------------------------------
   // LEAVExx;
   When %subst(operator:1:5) = 'LEAVE';
      Exsr subUserCvt_LEAVE;

   //----------------------------------------------------------------------------------
   // LOOKUP
   When operator = 'LOOKUP';
      Exsr subUserCvt_LOOKUP;

   //----------------------------------------------------------------------------------
   // MOVEA
   When %subst(operator:1:5) = 'MOVEA';
      Exsr subUserCvt_MOVEA;

   //----------------------------------------------------------------------------------
   // MOVE/MOVEL
   When operator = 'MONITOR';
      Exsr subUserCvt_MONITOR;

   //----------------------------------------------------------------------------------
   // MOVE/MOVEL
   When %subst(operator:1:4) = 'MOVE';
      Exsr subUserCvt_MOVE;

   //----------------------------------------------------------------------------------
   // MULT.
   When %subst(operator:1:4) = 'MULT';
      Exsr subUserCvt_MULT;

   //----------------------------------------------------------------------------------
   // MVR
   When operator = 'MVR';
      Exsr subUserCvt_MVR;

   //----------------------------------------------------------------------------------
   // NEXT
   When operator = 'NEXT';
      Exsr subUserCvt_NEXT;

   //----------------------------------------------------------------------------------
   // OCCUR (but not both set and get).
   When %subst(operator:1:5) = 'OCCUR';
      Exsr subUserCvt_OCCUR;

   //----------------------------------------------------------------------------------
   // ON-ERROR
   When operator = 'ON-ERROR';
      Exsr subUserCvt_ON_ERROR;

   //----------------------------------------------------------------------------------
   // OPEN
   When %subst(operator:1:4) = 'OPEN';
      Exsr subUserCvt_OPEN;

   //----------------------------------------------------------------------------------
   // OTHER
   When operator = 'OTHER';
      Exsr subUserCvt_OTHER;

   //----------------------------------------------------------------------------------
   // OUT
   When %subst(operator:1:3) = 'OUT';
      Exsr subUserCvt_OUT;

   //----------------------------------------------------------------------------------
   // PARM
   When operator = 'PARM';
      Exsr subUserCvt_PARM;

   //----------------------------------------------------------------------------------
   // PLIST
   When operator = 'PLIST';
      Exsr subUserCvt_PLIST;

   //----------------------------------------------------------------------------------
   // POST
   When %subst(operator:1:4) = 'POST';
      Exsr subUserCvt_POST;

   //----------------------------------------------------------------------------------
   // READ
   When %subst(operator:1:4) = 'READ';
      Exsr subUserCvt_READ;

   //----------------------------------------------------------------------------------
   // REL
   When %subst(operator:1:3) = 'REL';
      Exsr subUserCvt_REL;

   //----------------------------------------------------------------------------------
   // RESET
   When %subst(operator:1:5) = 'RESET';
      Exsr subUserCvt_RESET;

   //----------------------------------------------------------------------------------
   // RETURN
   When %subst(operator:1:6) = 'RETURN';
      Exsr subUserCvt_RETURN;

   //----------------------------------------------------------------------------------
   // ROLBK
   When %subst(operator:1:5) = 'ROLBK';
      Exsr subUserCvt_ROLBK;

   //----------------------------------------------------------------------------------
   // SCAN
   When operator = 'SCAN';
      Exsr subUserCvt_SCAN;

   //----------------------------------------------------------------------------------
   // SELECT
   When operator = 'SELECT';
      Exsr subUserCvt_SELECT;

   //----------------------------------------------------------------------------------
   // SETLL / SETGT
   When %subst(operator:1:5) = 'SETLL'
   or %subst(operator:1:5) = 'SETGT';
      Exsr subUserCvt_SETxx;

   //----------------------------------------------------------------------------------
   // SETOFF
   When operator = 'SETOFF';
      Exsr subUserCvt_SETOFF;

   //----------------------------------------------------------------------------------
   // SETON
   When operator = 'SETON';
      Exsr subUserCvt_SETON;

   //----------------------------------------------------------------------------------
   // SHTDN
   When operator = 'SHTDN';
      Exsr subUserCvt_SHTDN;

   //----------------------------------------------------------------------------------
   // SORTA.
   When %subst(operator:1:5) = 'SORTA';
      Exsr subUserCvt_SORTA;

   //----------------------------------------------------------------------------------
   // SUBDUR.
   When %subst(operator:1:6) = 'SUBDUR';
      Exsr subUserCvt_SUBDUR;

   //----------------------------------------------------------------------------------
   // SUBST.
   When %subst(operator:1:5) = 'SUBST';
      Exsr subUserCvt_SUBST;

   //----------------------------------------------------------------------------------
   // SUB
   When %subst(operator:1:3) = 'SUB';
      Exsr subUserCvt_SUB;

   //----------------------------------------------------------------------------------
   // TAG
   When operator = 'TAG';
      Exsr subUserCvt_TAG;

   //----------------------------------------------------------------------------------
   // TESTB
   When operator = 'TESTB';

   //----------------------------------------------------------------------------------
   // TESTN
   When operator = 'TESTN';

   //----------------------------------------------------------------------------------
   // TESTZ
   When operator = 'TESTZ';

   //----------------------------------------------------------------------------------
   // TEST
   When %subst(operator:1:4) = 'TEST';
      Exsr subUserCvt_TEST;

   //----------------------------------------------------------------------------------
   // TIME
   When operator = 'TIME';
      Exsr subUserCvt_TIME;

   //----------------------------------------------------------------------------------
   // UPDATE
   When %subst(operator:1:6) = 'UPDATE';
      Exsr subUserCvt_UPDATE;

   //----------------------------------------------------------------------------------
   // UNLOCK
   When %subst(operator:1:6) = 'UNLOCK';
      Exsr subUserCvt_UNLOCK;

   //----------------------------------------------------------------------------------
   // WHENxx
   When %subst(operator:1:4) = 'WHEN' or inWhen;
      Exsr subUserCvt_WHEN;

   //----------------------------------------------------------------------------------
   // WRITE
   When %subst(operator:1:5) = 'WRITE';
      Exsr subUserCvt_WRITE;

   //----------------------------------------------------------------------------------
   // XLATE
   When %subst(operator:1:5) = 'XLATE';
      Exsr subUserCvt_XLATE;

   //----------------------------------------------------------------------------------
   // Z-ADD (half-adjust not converted).
   When %subst(operator:1:5) = 'Z-ADD';
      Exsr subUserCvt_Z_ADD;

   //----------------------------------------------------------------------------------
   // Z-SUB (half-adjust not converted).
   When %subst(operator:1:5) = 'Z-SUB';
      Exsr subUserCvt_Z_SUB;
EndSl;

Return;
//-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// Convert Conditioning Indicators.
//-------------------------------------------------------------------------------------------
BegSr subUserCvt_Conditioning;

   If condCtrl = 'AN';
      sourceLine = 'and';
   ElseIf condCtrl = 'OR';
      sourceLine = 'or';
   Else;
      sourceLine = 'If';
   EndIf;

   sourceLine = %trim(sourceLine) + ' *IN' + condInd;

   If condNot = 'N';
      sourceLine = %trim(sourceLine) + ' = *Off';
   Else;
      sourceLine = %trim(sourceLine) + ' = *On';
   EndIf;

   If operator <> *Blanks;
      sourceLine = %trim(sourceLine) + ';';
   EndIf;

   // Is this a pre-line indicator or current line?
   If operator = *Blanks;
      reprocessLine = *Off;
   Else;
      inLineCondition = *On;
      // Reprocess the current line (sans conditioning indicators).
      condCtrl = *Blanks;
      condNot  = *Blanks;
      condInd  = *Blanks;
      savedSRCDTA = SRCDTA;
      reprocessLine = *On;
   EndIf;

   convert = *On;

EndSr;
//-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert ACQ.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_ACQ;

    sourceLine = %trim(operator) + ' ' + %trim(factor1)
               + ' ' + %trim(factor2) + ';';

    // Set resulting indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert ADD.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_ADD;

    // Half-adjust?
    x = %scan('H':operator:4);
    If x > 0;
       sourceLine = 'Eval(H)';
    Else;
       sourceLine = *Blanks;
    EndIf;

    If factor1 = *Blanks;
       sourceLine = %trimr(sourceLine) + ' ' + %trim(result)
                  + ' = ' + %trim(result)
                  + ' + ' + %trim(factor2) +';';
    Else;
       sourceLine = %trimr(sourceLine) + ' ' + %trim(result)
                  + ' = ' + %trim(factor1)
                  + ' + ' + %trim(factor2) + ';';
    EndIf;

    sourceLine = %trim(sourceLine);

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert ADDDUR.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_ADDDUR;

    // Split out duration and code.
    x = %scan(':':factor2);
    If x = 0;
       nonConvRsn =  'No duration code specified.';
       LeaveSr;
    EndIf;

    durDuration = %trim(%subst(factor2:1:x-1));
    durCode     = %xlate(lo:up:%trim(%subst(factor2:x+1)));

    Select;
       When durCode = '*Y' or durCode = '*YEARS';
          durCode = '%years';
       When durCode = '*M' or durCode = '*MONTHS';
          durCode = '%months';
       When durCode = '*D' or durCode = '*DAYS';
          durCode = '%days';
       When durCode = '*H' or durCode = '*HOURS';
          durCode = '%hours';
       When durCode = '*MN' or durCode = '*MINUTES';
          durCode = '%minutes';
       When durCode = '*S' or durCode = '*SECONDS';
          durCode = '%seconds';
       When durCode = '*MS' or durCode = '*MSECONDS';
          durCode = '%mseconds';
       Other;
          nonConvRsn = 'Invalid duration code specified.';
          LeaveSr;
    EndSl;

    If factor1 = *Blanks;
       sourceLine = %trim(result) + ' = ' + %trim(result);
    Else;
       sourceLine = %trim(result) + ' = ' + %trim(factor1);
    EndIf;

    sourceLine = %trimr(sourceLine) + ' + ' + %trim(durCode)
               + '(' + %trim(durDuration) + ');';

    // Set resulting indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert ALLOC.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_ALLOC;

    sourceLine = %trim(result) + ' = %alloc(' + %trim(factor2) + ');';

    // Set resulting indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert BEGSR.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_BEGSR;

    sourceLine = 'BegSr ' + %trim(factor1) + ';';

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// Convert CALLB.
//-------------------------------------------------------------------------------------------
BegSr subUserCvt_CALLB;

   If %scan('D':%xlate(lo:up:opCode)) = 0;  // No D-extender...no equivalent in freeform.
      // Hand over to CALL conversion as it's basically the same.
      Exsr subUserCvt_CALL;
   ElseIf @pConvPList = 'Y';
      convert = *Off;
      nonConvRsn = 'Conversion of CALLB with extender D is not supported';
   EndIf;

EndSr;
//-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// Convert CALL.
//-------------------------------------------------------------------------------------------
BegSr subUserCvt_CALL;

   If @pConvPList <> 'Y';
      convert = *Off;
      nonConvRsn = 'Conversion not selected on command';
      LeaveSr;
   EndIf;

   If parmListCount > 0;
      parmListName = %xlate(LO:UP:factor2);
      x = %lookup(SRCSEQ:parmList(*).lineNumber:1:parmListCount);
      If x > 0;
         If @pSuppressMsgs <> 'Y';
            savedSRCDTA = SRCDTA;
            lineType = *Blank;
            directive = *Blanks;
            codeLine = '// >>>>> Automatically removed by conversion';
            writeLine();
            SRCDTA = savedSRCDTA;
         EndIf;

         // Comment it out.
         sourceLine = '//' + nonPrefix;
         lineType = *Blank;
         inComment = *On;
         convert = *On;

         // Set parameters for callp definition.
         If parmList(x).listPList <> *Blanks;    // Uses a real parameter list.
            x = %lookup(parmList(x).listPList
                       :parmList(*).listName:1:parmListCount);
            CALLPPList = parmList(x).listName;
         EndIf;
         CALLPIndex = x;
         CALLPSeq = SRCSEQ;
         CALLPPgm = parmList(x).listName;
         CALLPOutput = *On;

         // Retain converted PList?
         If @pRetPList <> 'Y';
            dropLine = *On;
         EndIf;
      EndIf;
   EndIf;

EndSr;
//-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert CALLP.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_CALLP;

    // Returning for a multi-line CALLP - restore the original opcode.
    If inCallP;
       operator = callPOperator;
    EndIf;

    checkSpan();  // Does this line span more than one line?

    If not inCallP;         // First line of CALLP.
       sourceLine = %trimr(operator) + ' ' + %trim(extFactor2);
       If not inSpan;
          sourceLine = %trim(sourceLine) + ';';
       Else;
          callPOffset = %len(%trim(operator)) + 2;
          inCallP = *On;
          inSpan = *Off;
       EndIf;
    Else;                   // Second+ line of CALLP.
       sourceLine = *Blanks;
       sourceLine = %trim(extFactor2);
       If not inSpan;
          sourceLine = %trimr(sourceLine) + ';';
          //            inCallP = *Off;
       EndIf;
       inSpan = *Off;
    EndIf;

    // Multi-line CALLP?  Save the opcode.
    If inCallP;
       callPOperator = operator;
    Else;
       callPOperator = *Blanks;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// Convert CABxx.
//-------------------------------------------------------------------------------------------
BegSr subUserCvt_CABxx;

   If tagCount > 0;
      If result <> *Blanks;
         tagName = %xlate(LO:UP:result);
         x = %lookup(tagName:tagList(*).tagName:1:tagCount);
         If x = 0;
            nonConvRsn =  'TAG not found.';
            LeaveSr;
         EndIf;
         If tagList(x).tagType <> 'ENDSR';
            nonConvRsn =  'associated TAG is not on ENDSR.';
            LeaveSr;
         EndIf;

         tagList(x).tagUsageCount -= 1; // Keep a track of how many we've converted.
      EndIf;
   Else;
      nonConvRsn =  'TAG not found.';
      LeaveSr;
   EndIf;

   // Extract components.
   inCAB = *On;
   caseSubRoutine = %trim(result);
   If caseSubroutine = *Blanks;
      caseOperator = *Blanks;  // Doesn't matter...no actual branch being done.
   Else;
      caseOperator = %subst(operator:4:2);
   EndIf;

   // Determine comparator.
   If caseOperator = 'EQ';
      caseOperator = '=';
   ElseIf caseOperator = 'GT';
      caseOperator = '>';
   ElseIf caseOperator = 'LT';
      caseOperator = '<';
   ElseIf caseOperator = 'GE';
      caseOperator = '>=';
   ElseIf caseOperator = 'LE';
      caseOperator = '<=';
   ElseIf caseOperator = 'NE';
      caseOperator = '<>';
   Else;
      caseOperator = *Blanks;
   EndIf;

   CABFactor1 = %trim(factor1);
   CABFactor2 = %trim(factor2);

   sourceLine = *Blanks;     // Don't output anything just yet.
   dropLine = *On;

   // Do we need to set Resulting indicators?
   If hi <> *Blanks;
      HICheck = *On;
      HIInd = hi;
      HIFactor1 = %trim(factor1);
      HIFactor2 = %trim(factor2);
   EndIf;
   If lw <> *Blanks;
      LWCheck = *On;
      LWInd = lw;
      LWFactor1 = %trim(factor1);
      LWFactor2 = %trim(factor2);
   EndIf;
   If eq <> *Blanks;
      EQCheck = *On;
      EQInd = eq;
      EQFactor1 = %trim(factor1);
      EQFactor2 = %trim(factor2);
   EndIf;

   convert = *On;

EndSr;
//-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert CASxx.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_CASxx;

    // Extract components.
    caseSubRoutine = %trim(result);
    caseOperator = %subst(operator:4:2);

    // Determine comparator.
    If caseOperator = 'EQ';
       caseOperator = '=';
    ElseIf caseOperator = 'GT';
       caseOperator = '>';
    ElseIf caseOperator = 'LT';
       caseOperator = '<';
    ElseIf caseOperator = 'GE';
       caseOperator = '>=';
    ElseIf caseOperator = 'LE';
       caseOperator = '<=';
    ElseIf caseOperator = 'NE';
       caseOperator = '<>';
    Else;
       caseOperator = 'Else';
    EndIf;

    // Build 'If' statement.
    If not inCase;
       sourceLine = 'If ' +  %trim(factor1) + ' '
                  + %trim(caseOperator) + ' ' + %trim(factor2)
                  + ';';
       inCase = *On;
    Else;
       If caseOperator = 'Else';
          sourceLine = 'Else;';
       Else;
          sourceLine = 'ElseIf ' +  %trim(factor1) + ' '
                     + %trim(caseOperator) + ' ' + %trim(factor2)
                     + ';';
       EndIf;
    EndIf;

    // Do we need to set Resulting indicators?
    If hi <> *Blanks;
       HICheck = *On;
       HIInd = hi;
       HIFactor1 = %trim(factor1);
       HIFactor2 = %trim(factor2);
    EndIf;
    If lw <> *Blanks;
       LWCheck = *On;
       LWInd = lw;
       LWFactor1 = %trim(factor1);
       LWFactor2 = %trim(factor2);
    EndIf;
    If eq <> *Blanks;
       EQCheck = *On;
       EQInd = eq;
       EQFactor1 = %trim(factor1);
       EQFactor2 = %trim(factor2);
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert CAT.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_CAT;

    // Pad the result?
    x = %scan('P':operator:4);
    If x = 0                                              // Not padding.
    and factor1 <> *Blanks                                // Factor1 specified.
    and %xlate(lo:up:factor1) <> %xlate(LO:UP:result);    // Factor1 not the same as result
       nonConvRsn =  'No padding specified, result unpredictable.';
       LeaveSr;    // Don't convert - too difficult to get right.
    EndIf;

    // Drop the extender.
    operator = 'CAT';

    // Determine first part of string.
    If factor1 = *Blanks;
       catFactor1 = %trim(result);
    Else;
       catFactor1 = %trim(factor1);
    EndIf;

    // Determine number of blanks.
    x = %scan(':':factor2);
    If x = 0;   // No trimming required;
       catBlanks = *Blanks;
       catFactor2 = %trim(factor2);
    Else;
       catBlanks = %subst(factor2:x+1);
       catFactor2 = %subst(factor2:1:x-1);
    EndIf;

    // Determine second part of String.

    // Blanks zero?
    If catBlanks <> *blanks;
       Monitor;
          catCount = %dec(catBlanks:3:0);
       On-Error;
          LeaveSr; // Uses a field to vary the number of blanks - don't convert.
       EndMon;
    EndIf;

    // Build the new line.
    If catBlanks = *Blanks;
       // No trimming.
       sourceLine = %trim(result) + ' = ' + %trim(catFactor1)
                  + ' + ' + %trim(catFactor2) + ';';
    ElseIf catCount = 0;
       // No spaces.
       sourceLine = %trim(result) + ' = %trimr(' + %trim(catFactor1)
                  + ') + %trim(' + %trim(catFactor2) + ');';
    ElseIf catCount > 25;
       LeaveSr; // Arbitrary upper limit - don't convert.
    Else;
       sourceLine = %trim(result) + ' = %trimr(' + %trim(catFactor1)
                  + ') + ''' + %str(%addr(blanks):catCount)
                  + ''' + %trim(' + %trim(catFactor2) + ');';
    EndIf;

    // Set resulting indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert CHAIN.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_CHAIN;

    sourceLine = %trim(operator) + ' ' + getKeyList(factor1) + ' '
               + %trim(factor2);

    If result <> *Blanks;
       sourceLine = %trim(sourceLine)  + ' ' + %trim(result) + ';';
    Else;
       sourceLine = %trim(sourceLine)  + ';';
    EndIf;

    // Set resulting indicators?
    If hi <> *Blanks;
       NRFCheck = *On;
       NRFInd = hi;
       NRFFile = %trim(factor2);
    EndIf;
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert CHECK.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_CHECKx;

    // Don't convert of no result specified.
    If result = *Blanks;
       nonConvRsn = 'No result field specified.';
       LeaveSr;
    EndIf;

    If %subst(operator:1:5) = 'CHECKR';
       operator = '%checkr(';
    Else;
       operator = '%check(';
    EndIf;

    // Determine starting point.
    x = %scan(':':factor2);

    // Build the new line.
    If x = 0;
       // No start specified.
       sourceLine = %trim(result) + ' = ' + %trim(operator)
                  + %trim(factor1) + ':' + %trim(factor2) + ');';
    Else;
       // Start from a specified point.
       sourceLine = %trim(result) + ' = ' + %trim(operator)
                  + %trim(factor1) + ':' + %subst(factor2:1:x-1)
                  + ':' + %trim(%subst(factor2:x+1))
                  + ');';
    EndIf;

    // Set resulting indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;
    If eq <> *Blanks;
       HICheck = *On;
       HIInd = eq;
       HIFactor1 = result;
       HIFactor2 = '0';
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert CLEAR.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_CLEAR;

    sourceLine = 'Clear ' + %trim(result) + ';';

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert CLOSE.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_CLOSE;

    sourceLine = %trim(operator) + ' ' + %trim(factor2) + ';';

    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert COMMIT.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_COMMIT;

    sourceLine = %trim(operator) + ' ' + %trim(factor1);

    sourceLine = %trim(sourceLine)  + ';';

    // Check indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert COMP.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_COMP;

    // Set resulting indicators to check.
    If hi <> *Blanks;
       HICheck = *On;
       HIInd = hi;
       HIFactor1 = factor1;
       HIFactor2 = factor2;
    EndIf;

    If lw <> *Blanks;
       LWCheck = *On;
       LWInd = lw;
       LWFactor1 = factor1;
       LWFactor2 = factor2;
    EndIf;

    If eq <> *Blanks;
       EQCheck = *On;
       EQInd = eq;
       EQFactor1 = factor1;
       EQFactor2 = factor2;
    EndIf;

    // Drop the current line.
    dropLine = *On;
    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert DEALLOC.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_DEALLOC;

    sourceLine = %trim(operator) + ' ' + %trim(result);

    sourceLine = %trim(sourceLine)  + ';';

    // Set resulting indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert DELETE.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_DELETE;

    sourceLine = %trim(operator) + ' ' + %trim(factor2);

    sourceLine = %trim(sourceLine)  + ';';

    // Check indicators?
    If hi <> *Blanks;
       NRFCheck = *On;
       NRFInd = eq;
       NRFFile = %trim(factor2);
    EndIf;
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert DIV.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_DIV;

    // Half-adjust?
    If %scan('H':operator:3) > 0;
       sourceLine = 'Eval(H) ';
    Else;
       sourceLine = *Blanks;
    EndIf;

    If factor1 = *Blanks;
       divFactor1 = result;
       divFactor2 = factor2;
    Else;
       divFactor1 = factor1;
       divFactor2 = factor2;
    EndIf;

    sourceLine = %trim( %trimr(sourceLine) + ' ' + %trim(result)
               + ' = ' + %trim(divFactor1) + ' / '
               + %trim(divFactor2) + ';');

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert DO.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_DO;

    If inDo;
       operator = doOperator;
    EndIf;

    checkSpan();  // Does this line span more than one line?

    If operator = 'DOW'     // Use Extended Factor2.
    or operator = 'DOU';    // Use Extended Factor2.
       If not inDo;         // First line of DO.
          sourceLine = %trim(operator) + ' ' + %trim(extFactor2);
          If not inSpan;
             sourceLine = %trim(sourceLine) + ';';
          Else;
             inDo = *On;
             inSpan = *Off;
          EndIf;
       Else;                   // Second line of DO.
          sourceLine = *Blanks;
          //            %subst(sourceLine:40) = %trim(extFactor2);
          sourceLine = %trim(extFactor2);
          If not inSpan;
             sourceLine = %trimr(sourceLine) + ';';
             //               inDo = *Off;
          EndIf;
          inSpan = *Off;
       EndIf;
       doCompare = '!!';    // Just a regular DO.
    Else;
       // Fixed format.
       opCode = %xlate(lo:up:opCode);
       If not inDo;         // First line of DO.
          doCompare = %subst(opCode:4:2);
          sourceLine = %subst(opcode:1:3);
       Else;                // Second line of DO.
          If %subst(opCode:1:3) = 'AND';
             doCompare = %subst(opCode:4:2);
             sourceLine = 'And';
          Else;
             doCompare = %subst(opCode:3:2);
             sourceLine = 'Or';
          EndIf;
       EndIf;

       If doCompare = 'EQ';
          doCompare = '=';
       ElseIf doCompare = 'GT';
          doCompare = '>';
       ElseIf doCompare = 'GE';
          doCompare = '>=';
       ElseIf doCompare = 'LT';
          doCompare = '<';
       ElseIf doCompare = 'LE';
          doCompare = '<=';
       ElseIf doCompare = 'NE';
          doCompare = '<>';
       ElseIf doCompare = '!!';
          // Do nothing.
          Else;    // Just DO - convert to FOR.
          If factor1 = *Blanks;
             forFactor1 = '1';
          Else;
             forFactor1 = factor1;
          EndIf;
          If factor2 = *Blanks;
             forFactor2 = '1';
          Else;
             forFactor2 = factor2;
          EndIf;
          factor1 = *Blanks;
          factor2 = *Blanks;
          doCompare = *Blanks;
          If result = *Blanks;
             result = 'ZZ_doCount';
          EndIf;
          sourceLine = 'For ' + %trim(result) + ' = '
                     + %trim(forFactor1) + ' To '
                     + %trim(forFactor2);
       EndIf;

       //         If doCompare = *Blanks;
   //            // Save current indentation level to match up to the associated ENDDO later.
       //            forCount += 1;
       //            forLevel(forCount) = indentCount;
       //         Else;
   //            // Save current indentation level to match up to the associated ENDDO later.
       //            doCount += 1;
       //            doLevel(doCount) = indentCount;
       //         EndIf;

       sourceLine = %trimr(sourceLine) + ' ' + %trim(factor1)
                          + ' ' + %trim(doCompare) + ' '
                          + %trim(factor2);
       If not inSpan;
          sourceLine = %trimr(sourceLine) + ';';
          inDo = *Off;
       Else;
          inDo = *On;
          inSpan = *Off;
       EndIf;
    EndIf;

    // If multi-line, retain the original opcode.
    If inDo;
       doOperator = operator;
    Else;
       doOperator = *Blanks;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert DSPLY.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_DSPLY;

    sourceLine = %trim(operator);

    If factor1 <> *Blanks;
       sourceLine = %trimr(sourceLine) + ' ' + %trim(factor1);
       If factor2 <> *Blanks;
          sourceLine = %trimr(sourceLine) + ' ' + %trim(factor2);
          If result <> *Blanks;
             sourceLine = %trimr(sourceLine) + ' ' + %trim(result);
          EndIf;
       EndIf;
    EndIf;

    sourceLine = %trimr(sourceLine) + ';';

    // Set resulting indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert DUMP.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_DUMP;

    If factor1 <> *Blanks;
       sourceLine = %trim(operator) + ' ' + %trim(factor1) + ';';
    Else;
       sourceLine = %trim(operator) + ';';
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert ELSE.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_ELSE;

    sourceLine = 'Else;';

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert ELSEIF.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_ELSEIF;

    sourceLine = 'ElseIf ' + %trim(factor2) + ';';

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert ENDxx.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_ENDxx;

    // ENDSR with a TAG...can we remove it?
    If %trim(operator) = 'ENDSR';
       If %len(%trim(factor1)) > 0;
          If tagCount > 0;
             x = %lookup(%xlate(LO:UP:factor1):tagList(*).tagName:1:tagCount);
             If x = 0;
                nonConvRsn = 'Tag on ENDSR not found in tag list (this is an internal error)';
                LeaveSr;
             Else;
                If tagList(x).tagUsageCount > 0;
                   nonConvRsn = 'Cannot remove TAG on ENDSR as it is still in use';
                   LeaveSr;
                Else;
                   savedComment = factor1;
                   factor1 = *Blanks;
                   // Continue with conversion...
                EndIf;
             EndIf;
          Else;
             nonConvRsn = 'Label on ENDSR is not supported in free-form';
             LeaveSr;
          EndIf;
       EndIf;
    EndIf;

    // Do we need to convert an ENDDO to ENDFOR?
    If %trim(operator) = 'ENDDO' or %trim(operator) = 'END';
       If forCount > 0;
          If forLevel(forCount) = indentCount - 1;
             operator = 'ENDFOR' + ' ' + %trim(factor2);
             If factor2 <> *Blanks;
                savedSRCDTA = SRCDTA;
                fullLine = '* CHECK: This is a converted ENDDO -'
                         + ' Please add ''BY'' to the corresponding'
                         + ' FOR';
                writeLine();
                SRCDTA = savedSRCDTA;
             EndIf;
             //               forCount -= 1; // Remove from the stack.
          EndIf;
       EndIf;
    EndIf;

    // Convert END to ENDDO?
    If %trim(operator) = 'ENDDO' or %trim(operator) = 'END';
       If doCount > 0;
          If doLevel(doCount) = indentCount - 1;
             operator = 'ENDDO';
             //               doCount -= 1; // Remove from the stack.
          EndIf;
       EndIf;
    EndIf;

    If %trim(operator) = 'END';
       If inCase;
          operator = 'ENDCS';
       Else;
          operator = 'ENDIF';
       EndIf;
    EndIf;

    sourceLine = %trim(operator) + ';';

    convert = *On;

    If operator = 'ENDCS';
       inCase = *Off;
    EndIf;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert EVALx.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_EVALx;

    // Returning for a multi-line EVAL - restore the original opcode.
    If inEval;
       operator = evalOperator;
    EndIf;

    checkSpan();  // Does this line span more than one line?

    If not inEval;          // First line of EVAL.
       inEval = *On;
       If %scan('H':operator:5) > 0  // Half-adjust.
       or %scan('R':operator:1) > 0; // EVALR.
          sourceLine = %trimr(operator) + ' ' + %trim(extFactor2);
       Else;
          sourceLine = %trim(extFactor2);
       EndIf;
       If not inSpan;
          sourceLine = %trim(sourceLine) + ';';
       Else;
          inSpan = *Off;
       EndIf;
    Else;                   // Second+ line of EVAL.
       sourceLine = *Blanks;
       %subst(sourceLine:%len(%trim(operator)) + 2)
             = %trim(extFactor2);
       If not inSpan;
          sourceLine = %trimr(sourceLine) + ';';
       EndIf;
       inSpan = *Off;
    EndIf;

    // Multi-line EVAL?  Save the opcode.
    If inEval;
       evalOperator = operator;
    Else;
       evalOperator = *Blanks;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert EXCEPT.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_EXCEPT;

    sourceLine = %trim(operator) + ' ' + %trim(factor2) + ';';

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert Embedded SQL.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_EXEC_SQL;

    checkSpan();  // Does this line span more than one line?

    If workDirective = '/EXEC SQL';
       sourceLine = 'Exec SQL';
       inSQL = *On;
       inSpan = *Off;
    Else;
       sourceLine = %trimr(%subst(codeLine:2));
       If not inSpan;
          sourceLine = %trim(sourceLine) + ';';
       Else;
          inSQL = *On;
          inSpan = *Off;
       EndIf;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert EXFMT.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_EXFMT;

    sourceLine = %trim(operator) + ' ' + %trim(factor2);

    // Append datastructure?
    If result <> *Blanks;
       sourceLine = %trim(sourceLine)  + ' ' + %trim(result) + ';';
    Else;
       sourceLine = %trim(sourceLine)  + ';';
    EndIf;

    // Check indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert EXSR.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_EXSR;

    sourceLine = 'ExSr ' + %trim(factor2) + ';';

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert EXTRCT
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_EXTRCT;

    // Split out duration and code.
    x = %scan(':':factor2);
    If x = 0;
       nonConvRsn =  'No duration code specified.';
       LeaveSr;
    EndIf;

    durDuration = %trim(%subst(factor2:1:x-1));
    durCode     = %xlate(lo:up:%trim(%subst(factor2:x+1)));

    Select;
       When durCode = '*Y' or durCode = '*YEARS';
          durCode = '%years';
       When durCode = '*M' or durCode = '*MONTHS';
          durCode = '%months';
       When durCode = '*D' or durCode = '*DAYS';
          durCode = '%days';
       When durCode = '*H' or durCode = '*HOURS';
          durCode = '%hours';
       When durCode = '*MN' or durCode = '*MINUTES';
          durCode = '%minutes';
       When durCode = '*S' or durCode = '*SECONDS';
          durCode = '%seconds';
       When durCode = '*MS' or durCode = '*MSECONDS';
          durCode = '%mseconds';
       Other;
          nonConvRsn = 'Invalid duration code specified.';
          LeaveSr;
    EndSl;

    sourceLine = %trim(result) + ' = %subdt(' + %trim(durDuration)
               + ':' + %trim(durCode) + ');';

    // Check indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert FEOD.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_FEOD;

    sourceLine = %trim(operator) + ' ' + %trim(factor2) + ';';

    // Check indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert FORCE.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_FORCE;

    sourceLine = %trim(operator) + ' ' + %trim(extFactor2) + ';';

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert FOR.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_FOR;

    sourceLine = 'For ' + %trim(extFactor2) + ';';

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// Convert GOTO
//-------------------------------------------------------------------------------------------
BegSr subUserCvt_GOTO;

   If tagCount > 0;
      tagName = %xlate(LO:UP:factor2);
      x = %lookup(tagName:tagList(*).tagName:1:tagCount);
      If x > 0 and tagList(x).tagType = 'ENDSR';
            tagList(x).tagUsageCount -= 1; // Keep a track of how many we've converted.
            sourceLine = 'LeaveSr;';
            convert = *On;

      Else;
         nonConvRsn =  'TAG not found or not an ENDSR.';
         LeaveSr;
      EndIf;
   EndIf;

EndSr;
//-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert IF.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_IF;

    // Returning for a multi-line IF?  Reinstate original opcode.
    If inIf;
       operator = ifOperator;
    EndIf;

    checkSpan();  // Does this line span more than one line?

    If operator = 'IF';     // Use Extended Factor2.
       If not inIf;            // First line of IF.
          sourceLine = %trim(operator) + ' ' + %trim(extFactor2);
          If not inSpan;
             sourceLine = %trim(sourceLine) + ';';
          Else;
             inIf = *On;
             inSpan = *Off;
          EndIf;
       Else;                   // Second line of IF.
          //            sourceLine = *Blanks;
          //            %subst(sourceLine:40) = %trim(extFactor2);
          sourceLine = %trim(extFactor2);
          If not inSpan;
             sourceLine = %trimr(sourceLine) + ';';
             //               inIf = *Off;
          EndIf;
          //            inSpan = *On;
          inSpan = *Off;
       EndIf;
    Else;
       // Fixed format.
       opCode = %xlate(lo:up:opCode);
       If not inIf;         // First line of IF.
          ifCompare = %subst(opCode:3:2);
          sourceLine = 'If';
       Else;                // Second line of IF.
          If %subst(opCode:1:3) = 'AND';
             ifCompare = %subst(opCode:4:2);
             sourceLine = 'And';
          Else;
             ifCompare = %subst(opCode:3:2);
             sourceLine = 'Or';
          EndIf;
       EndIf;
       If ifCompare = 'EQ';
          ifCompare = '=';
       ElseIf ifCompare = 'GT';
          ifCompare = '>';
       ElseIf ifCompare = 'GE';
          ifCompare = '>=';
       ElseIf ifCompare = 'LT';
          ifCompare = '<';
       ElseIf ifCompare = 'LE';
          ifCompare = '<=';
       ElseIf ifCompare = 'NE';
          ifCompare = '<>';
       EndIf;
       sourceLine = %trimr(sourceLine) + ' ' + %trim(factor1)
                          + ' ' + %trim(ifCompare) + ' '
                          + %trim(factor2);
       If not inSpan;
          sourceLine = %trimr(sourceLine) + ';';
          inIf = *Off;
       Else;
          inIf = *On;
          inSpan = *Off;
       EndIf;
    EndIf;

    // Multi-line IF?  Retain original opcode.
    If inIf;
       ifOperator = operator;
    Else;
       ifOperator = *Blanks;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert IN.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_IN;

    If factor1 <> *Blanks;
       sourceLine = %trim(operator) + ' ' + %trim(factor1) + ' '
                  + %trim(factor2) + ';';
    Else;
       sourceLine = %trim(operator) + ' ' + %trim(factor2) + ';';
    EndIf;

    // Set resulting indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert ITER.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_ITER;

    sourceLine = %trim(operator) + ';';

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert KFLD
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_KFLD;

   If @pConvKList <> 'Y';
      convert = *Off;
      nonConvRsn = 'Conversion not selected on command';
      LeaveSr;
   EndIf;

   If keyListCount > 0;
      x = %lookup(keyListName:keyList(*).listName:1:keyListCount);
      If x > 0;
         // Comment it out.
         sourceLine = '//' + nonPrefix;
         lineType = *Blank;
         inComment = *On;
         convert = *On;

         // Retain converted KList?
         If @pRetKList <> 'Y';
            dropLine = *On;
         EndIf;
      EndIf;
   EndIf;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// Convert KLIST
//-------------------------------------------------------------------------------------------
BegSr subUserCvt_KLIST;

   If @pConvKList <> 'Y';
      convert = *Off;
      nonConvRsn = 'Conversion not selected on command';
      LeaveSr;
   EndIf;

   If keyListCount > 0;
      keyListName = %xlate(LO:UP:factor1);
      x = %lookup(keyListName:keyList(*).listName:1:keyListCount);
      If x > 0;
         If @pSuppressMsgs <> 'Y' and @pRetKList = 'Y';
            savedSRCDTA = SRCDTA;
            lineType = *Blank;
            directive = *Blanks;
            codeLine = '// >>>>> Automatically removed by conversion';
            writeLine();
            SRCDTA = savedSRCDTA;
         EndIf;

         // Comment it out.
         sourceLine = '//' + nonPrefix;
         lineType = *Blank;
         inComment = *On;
         convert = *On;

         // Retain converted KList?
         If @pRetKList <> 'Y';
            dropLine = *On;
         EndIf;
      EndIf;
   EndIf;

EndSr;
//-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert LEAVExx.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_LEAVE;

    sourceLine = %trim(operator) + ';';

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert LOOKUP.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_LOOKUP;

    //            If %subst(factor2:1:3) = 'TAB';  // Table lookup.
    //            Else;                            // Array lookup.
    //               // Extract element variable.
    //               x = %scan('(':factor2);
    //               If x = 0;   // No variable specified, so use a substitute.
    //                  lookupVar = 'lookupIndex';
    //               Else;
    //                  lookupVar = %subst(factor2:x+1:%scan(')':factor2:x)-x-1);
    //               EndIf;
    //               If eq <> *Blanks and lw <> *Blanks;
    //                  sourceLine = '%lookupLE(';
    //               ElseIf eq <> *Blanks and hi <> *Blanks;
    //                  sourceLine = '%lookupGE(';
    //               ElseIf lw <> *Blanks;
    //                  sourceLine = '%lookupLT(';
    //               ElseIf hi <> *Blanks;
    //                  sourceLine = '%lookupGT(';
    //               Else;
    //                  sourceLine = '%lookup(';
    //               EndIf;
    //               sourceLine = %trim(sourceLine) + %trim(factor1) + ':'
    //                          + %trim(factor2) + ');';
    //            EndIf;
    //            convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert MONITOR.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_MONITOR;

    sourceLine = 'Monitor;';

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// Convert MOVE.
//-------------------------------------------------------------------------------------------
BegSr subUserCvt_MOVE;

   // No conversion for MOVE statements.
   If @pConvMOVE <> 'Y';
      nonConvRsn =  'CVTRPGFREE run with CNVMOVE(N).';
      LeaveSr;
   EndIf;

   // Pad the result?
   x = %scan('P':operator:5);

   If x > 0 and %subst(operator:5:1) <> 'L';
      // Move right and pad left.
      sourceLine = 'EvalR ' + %trim(result) + ' = ' + %trim(factor2)
                 + ';';

   ElseIf x > 0 and %subst(operator:5:1) = 'L';
      // Move left and pad right.
      sourceLine = %trim(result) + ' = ' + %trim(factor2) + ';';

   ElseIf factor1 = *Blanks;
      // Straight move: OK to comvert THESE types of MOVE.
      If %xlate(LO:UP:%subst(factor2:1:6)) = '*BLANK'
      or %xlate(LO:UP:%subst(factor2:1:5)) = '*ZERO'
      or %xlate(LO:UP:factor2) = '*OFF' or %xlate(LO:UP:factor2) = '*ON'
      or %subst(operator:5:1) = 'L'
      or (%subst(result:1:3) = '*IN' and %subst(result:4:1) <> '(');

         If %lookup(%xlate(lo:up:%trim(result)):@opCodeUp) = 0;
            sourceLine = %trim(result) + ' = ' + %trim(factor2) + ';';
         Else;
            // Result is a reserved word - don't convert.
            nonConvRsn = 'Result field name is a reserved word.';
            LeaveSr;
         EndIf;
      Else;
         // Straight move is too dangerous - don't convert.
         nonConvRsn = 'Straight move between unknown fields is dangerous.';
         LeaveSr;
      EndIf;

   Else;
      // Conversion from one format to another...
      //         sourceLine = %xlate(lo:up:factor1);

      //         If sourceLine = '*CYMD';   // Date.
      //            sourceLine = %trim(result) + ' = %dec(' + %trim(factor2)
      //                       + ':*CYMD);';
      //         Else;
      nonConvRsn = 'Data conversion is needed.';
      LeaveSr; // Don't convert.
      //         EndIf;
   EndIf;

   convert = *On;

EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// Convert MOVEA.
//-------------------------------------------------------------------------------------------
BegSr subUserCvt_MOVEA;

   // MOVEA supported only for indicators like so:
   // C                   MOVEA     '00000000'    *IN(50)
   If  (%scan('''0':factor2) > 0 or %scan('''1':factor2) > 0) and %subst(result:1:4) = '*IN(';
      arrayLength = %len(%trim(factor2)) - 2;
      endPos = %scan(')':result);
      arrayStart = %subst(result:5:endpos-5);

      sourceLine = '%subst(zz_IndArray:' + arrayStart + ':'
                 + %char(arrayLength) + ') = ' + %trim(factor2) + ';';

      convert = *On;
      LeaveSr;

     // perhaps trying to set indicators
     nonConvRsn = 'redefine *IN as array IND use %subst(IND:50:3) = ''000''';

   else;

     nonConvRsn = 'Data type Conversion necesssary';
     LeaveSr;

  EndIf;

EndSr;
//-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert MULT.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_MULT;

    // Half-adjust?
    x = %scan('H':operator:4);
    If x > 0;
       sourceLine = 'Eval(H)';
    Else;
       sourceLine = *Blanks;
    EndIf;

    If factor1 = *Blanks;
       sourceLine = %trimr(sourceLine) + ' ' + %trim(result)
                  + ' = ' + %trim(result)
                  + ' * ' + %trim(factor2) +';';
    Else;
       sourceLine = %trimr(sourceLine) + ' ' + %trim(result)
                  + ' = ' + %trim(factor1)
                  + ' * ' + %trim(factor2) + ';';
    EndIf;

    sourceLine = %trim(sourceLine);

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert MVR.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_MVR;

    sourceLine = %trim(result) + ' = %rem(' + %trim(divFactor1)
               + ':' + %trim(divFactor2) + ');';

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert NEXT.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_NEXT;

    sourceLine = %trim(operator) + ' ' + %trim(factor1) + ' '
               + %trim(factor2) + ';';


    // Check indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert OCCUR.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_OCCUR;

    If factor1 = *Blanks;      // Get occurrence.
       sourceLine = %trim(result) + ' = ' + '%occur('
                  + %trim(factor2) + ');';
    ElseIf result = *Blanks;   // Set occurrent.
       sourceLine = '%occur(' + %trim(factor2) + ') = '
                  + %trim(factor1) + ';';
    Else;
       nonConvRsn = 'Cannot determine of OCCUR is used to set or '
                  + 'get the occurrence.';
       LeaveSr;
    EndIf;

    // Check resulting indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert ON-ERROR.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_ON_ERROR;

    If extFactor2 = *Blanks;
       sourceLine = %trim(operator) + ';';
    Else;
       sourceLine = %trim(operator) + ' ' + %trim(extFactor2) + ';';
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert OPEN.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_OPEN;

    sourceLine = %trim(operator) + ' ' + %trim(factor2) + ';';

    // Check resulting indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert OTHER.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_OTHER;

    sourceLine = 'Other;';

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert OUT.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_OUT;

    If factor1 = *Blanks;
       sourceLine = %trim(operator) + ' ' + %trim(factor2) + ';';
    Else;
       sourceLine = %trim(operator) + ' ' + %trim(factor1) + ' '
                  + %trim(factor2) + ';';
    EndIf;

    // Set resulting indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert PARM
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_PARM;

   If @pConvPList <> 'Y';
      convert = *Off;
      nonConvRsn = 'Conversion not selected on command';
      LeaveSr;
   EndIf;

   If parmListCount > 0;
      x = %lookup(parmListName:parmList(*).listName:1:parmListCount);
      If x > 0 and parmList(x).convert;
         // Comment it out.
         sourceLine = '//' + nonPrefix;
         lineType = *Blank;
         inComment = *On;
         convert = *On;

         // Retain converted PList?
         If @pRetPList <> 'Y';
            dropLine = *On;
         EndIf;
      EndIf;
   EndIf;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// Convert PLIST
//-------------------------------------------------------------------------------------------
BegSr subUserCvt_PLIST;

   If @pConvPList <> 'Y';
      convert = *Off;
      nonConvRsn = 'Conversion not selected on command';
      LeaveSr;
   EndIf;

   If parmListCount > 0;
      parmListName = %xlate(LO:UP:factor1);
      x = %lookup(parmListName:parmList(*).listName:1:parmListCount);
      If x > 0 and parmList(x).convert;
         If @pSuppressMsgs <> 'Y' and @pRetPList = 'Y';
            savedSRCDTA = SRCDTA;
            lineType = *Blank;
            directive = *Blanks;
            codeLine = '// >>>>> Automatically removed by conversion';
            writeLine();
            SRCDTA = savedSRCDTA;
         EndIf;

         // Comment it out.
         sourceLine = '//' + nonPrefix;
         lineType = *Blank;
         inComment = *On;
         convert = *On;

         // Retain converted PList?
         If @pRetPList <> 'Y';
            dropLine = *On;
         EndIf;
      EndIf;
   EndIf;

EndSr;
//-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert POST.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_POST;

    If factor2 = *Blanks;
       nonConvRsn =  'No filename specified in Factor2.';
       LeaveSr;
    EndIf;

    If result <> *Blanks;
       nonConvRsn =  'INFDS specified in result.';
       LeaveSr;
    EndIf;

    If factor1 = *Blanks;
       sourceLine = %trim(operator) + ' ' + %trim(factor2) + ';';
    Else;
       sourceLine = %trim(operator) + ' ' + %trim(factor1) + ' '
                  + %trim(factor2) + ';';
    EndIf;

    // Set resulting indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert READ.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_READ;

    If factor1 <> *Blanks;
       sourceLine = %trim(operator) + ' ' + getKeyList(factor1) + ' '
                  + %trim(factor2);
    Else;
       sourceLine = %trim(operator) + ' ' + %trim(factor2);
    EndIf;

    // Append datastructure?
    If result <> *Blanks;
       sourceLine = %trim(sourceLine)  + ' ' + %trim(result) + ';';
    Else;
       sourceLine = %trim(sourceLine)  + ';';
    EndIf;

    // Check indicators?
    If eq <> *Blanks;
       EOFCheck = *On;
       EOFInd = eq;
       EOFFile = %trim(factor2);
    EndIf;
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// Convert REALLOC.
//-------------------------------------------------------------------------------------------
BegSr subUserCvt_REALLOC;

   // Not valid in free-format!
   Return;

   sourceLine = %trim(result) + ' = %realloc(' + %trim(factor2)
              + ');';

   // Set resulting indicators?
   If lw <> *Blanks;
      ERRCheck = *On;
      ERRInd = lw;
   EndIf;

   convert = *On;

EndSr;
//-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert REL.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_REL;

    sourceLine = %trim(operator) + ' ' + %trim(factor1)
               + ' ' + %trim(factor2) + ';';

    // Check resulting indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert RESET.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_RESET;

    sourceLine = %trim(operator);

    If factor1 <> *Blanks;
       sourceLine = %trimr(sourceLine) + ' ' + %trim(factor1);
    EndIf;

    If factor2 <> *Blanks;
       sourceLine = %trimr(sourceLine) + ' ' + %trim(factor2);
    EndIf;

    sourceLine = %trimr(sourceLine) + ' ' + %trim(result) + ';';

    // Check indicators?
    If hi <> *Blanks;
       NRFCheck = *On;
       NRFInd = eq;
       NRFFile = %trim(factor2);
    EndIf;
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert RETURN;
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_RETURN;

    sourceLine = 'Return ' + %trim(%subst(operator:7))
               + ' ' + %trim(extFactor2) + ';';

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert ROLBK.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_ROLBK;

    sourceLine = %trim(operator) + ' ' + %trim(factor1);

    sourceLine = %trim(sourceLine)  + ';';

    // Check indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert SCAN.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_SCAN;

    // Determine length of comparator.
    x = %scan(':':factor1);
    If x = 0;   // No length specified.
       scanLength = *Blanks;               // Scan length
       scanString = %trim(factor1);        // Scan string
    Else;
       scanLength = %subst(factor1:x+1);   // Scan length
       scanString = %subst(factor1:1:x-1); // Scan string
    EndIf;

    // Determine starting point.
    x = %scan(':':factor2);
    If x = 0;   // No start specified.
       scanStart = '1';                    // Start position
       scanBase = %trim(factor2);          // Base string
    Else;
       scanStart = %subst(factor2:x+1);    // Start position
       scanBase = %subst(factor2:1:x-1);   // Base string
    EndIf;

    // Build the new line.
    If scanLength = *Blanks;
       // No length specified.
       sourceLine = '%scan(' + %trim(scanString)
                  + ':' + %trim(scanBase) + ':' + %trim(scanStart)
                  + ')';
    Else;
       // Use a subset of the scan string.
       sourceLine = '%scan(%subst('
                  + %trim(scanString) + ':1:' + %trim(scanLength)
                  + '):' + %trim(scanBase) + ':' + %trim(scanStart)
                  + ')';
    EndIf;

    // Result specified?
    If result = *Blanks;
       scanNoResult = *On;
       sourceLine = 'If ' + %trimr(sourceLine) + ' = 0;';
    Else;
       scanNoResult = *Off;
       sourceLine = %trim(result) + ' = ' + %trimr(sourceLine) + ';';
    EndIf;

    // Set resulting indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;
    If eq <> *Blanks;
       foundCheck = *On;
       foundInd = eq;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert SELECT
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_SELECT;

    sourceLine = 'Select;';

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert SETOFF
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_SETOFF;

    setOff = *On;
    setOffInd1 = hi;
    setOffInd2 = lw;
    setOffInd3 = eq;

    dropLine = *On;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert SETON
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_SETON;

    setOn = *On;
    setOnInd1 = hi;
    setOnInd2 = lw;
    setOnInd3 = eq;

    dropLine = *On;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert SETxx.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_SETxx;

    sourceLine = %trim(operator) + ' ' + getKeyList(factor1) + ' '
               + %trim(factor2);
    If result <> *Blanks;
       sourceLine = %trim(sourceLine)  + ' ' + %trim(result) + ';';
    Else;
       sourceLine = %trim(sourceLine)  + ';';
    EndIf;

    // Check resulting indicators.
    If hi <> *Blanks;
       NRFCheck = *On;
       NRFInd = hi;
       NRFFile = %trim(factor2);
    EndIf;
    If eq <> *Blanks;
       equalCheck = *On;
       equalInd = eq;
    EndIf;
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert SHTDN
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_SHTDN;

    sourceLine = '*IN' + hi + ' = %shtdn();';

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert SORTA.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_SORTA;

    sourceLine = %trim(operator) + ' ' + %trim(extFactor2);

    sourceLine = %trim(sourceLine)  + ';';

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// Convert SQRT.
//-------------------------------------------------------------------------------------------
BegSr subUserCvt_SQRT;

   // Not valid in free-format!
   Return;

   sourceLine = %trim(result) + ' = %sqrt(' + %trim(factor2) + ');';

   convert = *On;

EndSr;
//-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert SUB.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_SUB;

    // Half-adjust?
    x = %scan('H':operator:4);
    If x > 0;
       operator = 'SUB';
       sourceLine = 'Eval(H)';
    Else;
       sourceLine = *Blanks;
    EndIf;

    If factor1 = *Blanks;
       sourceLine = %trimr(sourceLine) + ' ' + %trim(result)
                  + ' = ' + %trim(result)
                  + ' - ' + %trim(factor2) +';';
    Else;
       sourceLine = %trimr(sourceLine) + ' ' + %trim(result)
                  + ' = ' + %trim(factor1)
                  + ' - ' + %trim(factor2) + ';';
    EndIf;

    sourceLine = %trim(sourceLine);

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert SUBDUR.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_SUBDUR;

    // Split out duration and code.
    x = %scan(':':factor2);
    If x = 0;
       x = %scan(':':result);
       If x = 0;
          nonConvRsn =  'No duration code specified.';
          LeaveSr;
       Else;
          durNewDate = *Off;
       EndIf;
    Else;
       durNewDate = *On;
    EndIf;

    If durNewDate;
       durDuration = %trim(%subst(factor2:1:x-1));
       durCode     = %xlate(lo:up:%trim(%subst(factor2:x+1)));

       Select;
          When durCode = '*Y' or durCode = '*YEARS';
             durCode = '%years';
          When durCode = '*M' or durCode = '*MONTHS';
             durCode = '%months';
          When durCode = '*D' or durCode = '*DAYS';
             durCode = '%days';
          When durCode = '*H' or durCode = '*HOURS';
             durCode = '%hours';
          When durCode = '*MN' or durCode = '*MINUTES';
             durCode = '%minutes';
          When durCode = '*S' or durCode = '*SECONDS';
             durCode = '%seconds';
          When durCode = '*MS' or durCode = '*MSECONDS';
             durCode = '%mseconds';
          Other;
             nonConvRsn = 'Invalid duration code specified.';
             LeaveSr;
       EndSl;

       If factor1 = *Blanks;
          sourceLine = %trim(result) + ' = ' + %trim(result);
       Else;
          sourceLine = %trim(result) + ' = ' + %trim(factor1);
       EndIf;

       sourceLine = %trimr(sourceLine) + ' - ' + %trim(durCode)
                  + '(' + %trim(durDuration) + ');';
    Else;
       durDuration = %trim(%subst(result:1:x-1));
       durCode     = %xlate(lo:up:%trim(%subst(result:x+1)));

       Select;
          When durCode = '*Y' or durCode = '*YEARS';
          When durCode = '*M' or durCode = '*MONTHS';
          When durCode = '*D' or durCode = '*DAYS';
          When durCode = '*H' or durCode = '*HOURS';
          When durCode = '*MN' or durCode = '*MINUTES';
          When durCode = '*S' or durCode = '*SECONDS';
          When durCode = '*MS' or durCode = '*MSECONDS';
          Other;
             nonConvRsn = 'Invalid duration code specified.';
             LeaveSr;
       EndSl;

       sourceLine = %trim(durDuration) + ' = %diff(' + %trim(factor1)
                  + ':' + %trim(factor2) + ':' + %trim(durCode) + ');';
    EndIf;

    // Set resulting indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert SUBST.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_SUBST;

    // Pad the result?
    x = %scan('P':operator:4);
    If x = 0                                              // Not padding.
    and factor1 <> *Blanks                                // Factor1 specified.
    and %xlate(lo:up:factor1) <> %xlate(LO:UP:result);    // Factor1 not the same as result
       nonConvRsn = 'No padding specified, and factor1 and result '
                  + 'are not the same.';
       LeaveSr;    // Don't convert - too difficult to get right.
    EndIf;

    substLen = %trim(factor1);

    x = %scan(':':factor2);
    If x = 0;
       substStart = '1';
       x = %len(%trim(factor2)) + 1;
    Else;
       substStart = %subst(factor2:x+1);
    EndIf;

    sourceLine = %trim(result) + ' = %subst('
               + %subst(factor2:1:x-1) + ':'
               + %trim(substStart)
               + ':' + %trim(substLen) + ');';

    // Set resulting indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// Convert TAG
//-------------------------------------------------------------------------------------------
BegSr subUserCvt_TAG;

   If tagCount > 0;
      tagName = %xlate(LO:UP:factor1);
      x = %lookup(tagName:tagList(*).tagName:1:tagCount);
      If x > 0 and tagList(x).tagUsageCount = 0;
         If @pSuppressMsgs <> 'Y';
            savedSRCDTA = SRCDTA;
            lineType = *Blank;
            directive = *Blanks;
            codeLine = '// >>>>> Automatically removed by conversion';
            writeLine();
            SRCDTA = savedSRCDTA;
         EndIf;

         // Comment it out.
         sourceLine = '//' + nonPrefix;
         lineType = *Blank;
         inComment = *On;
         convert = *On;
      EndIf;
   EndIf;

EndSr;
//-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert TEST.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_TEST;

    If operator = 'TEST';
       operator = 'Test(E)';
    EndIf;

    sourceLine = %trim(operator) + ' ' + %trim(factor1) + ' '
               + %trim(result) + ';';

    // Set resulting indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert TIME.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_TIME;

    sourceLine = %trim(result) + ' = %dec(%time());';

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert UNLOCK.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_UNLOCK;

    sourceLine = %trim(operator) + ' ' + %trim(factor2) + ';';

    // Check indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert UPDATE.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_UPDATE;

    sourceLine = %trim(operator) + ' ' + %trim(factor2);

    // Append datastructure?
    If result <> *Blanks;
       sourceLine = %trim(sourceLine)  + ' ' + %trim(result) + ';';
    Else;
       sourceLine = %trim(sourceLine)  + ';';
    EndIf;

    // Check indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert WHEN.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_WHEN;

    // Returning for a multi-line IF?  Reinstate original opcode.
    If inWhen;
       operator = whenOperator;
    EndIf;

    checkSpan();  // Does this line span more than one line?

    If operator = 'WHEN';     // Use Extended Factor2.
       If not inWhen;            // First line of IF.
          sourceLine = %trim(operator) + ' ' + %trim(extFactor2);
          If not inSpan;
             sourceLine = %trim(sourceLine) + ';';
          Else;
             inWhen = *On;
             inSpan = *Off;
          EndIf;
       Else;                   // Second line of WHEN.
          //            sourceLine = *Blanks;
          //            %subst(sourceLine:40) = %trim(extFactor2);
          sourceLine = %trim(extFactor2);
          If not inSpan;
             sourceLine = %trimr(sourceLine) + ';';
             //               inWhen = *Off;
          EndIf;
          inSpan = *Off;
       EndIf;
    Else;
       // Fixed format.
       opCode = %xlate(lo:up:opCode);
       If not inWhen;         // First line of WHEN.
          whenCompare = %subst(opCode:5:2);
          sourceLine = 'When';
       Else;                // Second line of WHEN.
          If %subst(opCode:1:3) = 'AND';
             whenCompare = %subst(opCode:4:2);
             sourceLine = 'And';
          Else;
             whenCompare = %subst(opCode:3:2);
             sourceLine = 'Or';
          EndIf;
       EndIf;
       If whenCompare = 'EQ';
          whenCompare = '=';
       ElseIf whenCompare = 'GT';
          whenCompare = '>';
       ElseIf whenCompare = 'GE';
          whenCompare = '>=';
       ElseIf whenCompare = 'LT';
          whenCompare = '<';
       ElseIf whenCompare = 'LE';
          whenCompare = '<=';
       ElseIf whenCompare = 'NE';
          whenCompare = '<>';
       EndIf;
       sourceLine = %trimr(sourceLine) + ' ' + %trim(factor1)
                          + ' ' + %trim(whenCompare) + ' '
                          + %trim(factor2);
       If not inSpan;
          sourceLine = %trimr(sourceLine) + ';';
          inWhen = *Off;
       Else;
          inWhen = *On;
          inSpan = *Off;
       EndIf;
    EndIf;

    // Multi-line IF?  Retain original opcode.
    If inWhen;
       whenOperator = operator;
    Else;
       whenOperator = *Blanks;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert WRITE.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_WRITE;

    sourceLine = %trim(operator) + ' ' + %trim(factor2);

    // Append datastructure?
    If result <> *Blanks;
       sourceLine = %trim(sourceLine)  + ' ' + %trim(result) + ';';
    Else;
       sourceLine = %trim(sourceLine)  + ';';
    EndIf;

    // Check indicators?
    If eq <> *Blanks;
       EOFCheck = *On;
       EOFInd = eq;
       EOFFile = %trim(factor2);
    EndIf;
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// Convert XFOOT.
//-------------------------------------------------------------------------------------------
BegSr subUserCvt_XFOOT;

   // Not valid in free-format!
   Return;

   If %scan('H':operator) = 0;
      sourceLine = %trim(result) + ' = %xfoot(' + %trim(factor2)
                 + ');';
   Else;
      // Half-adjust.
      sourceLine = 'Eval(H) ' + %trim(result) + ' = %xfoot('
                 + %trim(factor2) + ');';
   EndIf;

   convert = *On;

EndSr;
//-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert XLATE.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_XLATE;

    //      // Pad the result?
    //      x = %scan('P':operator:6);
    //      If x > 0;
    //         padResult = *On;
    //         padTarget = result;
    //         // Drop the extender.
    //         operator = 'XLATE';
    //      EndIf;

    // Derive from and to.
    x = %scan(':':factor1);
    If x = 0;
       LeaveSr;    // Invalid specification - there MUST be a from and to - don't convert.
    Else;
       xlateFrom = %subst(factor1:1:x-1);
       xlateTo = %subst(factor1:x+1);
    EndIf;

    // Check for start position.
    x = %scan(':':factor2);
    If x = 0;
       xlateStart = *Blanks;
       xlateBase = factor2;
    Else;
       xlateStart = %subst(factor2:x+1);
       xlateBase = %subst(factor2:1:x-1);
    EndIf;

    // Build new line.
    sourceLine = %trim(result) + ' = %xlate('
               + %trim(xlateFrom) + ':' + %trim(xlateTo) + ':'
               + %trim(xlateBase);
    If xlateStart <> *Blanks;
       sourceLine = %trimr(sourceLine) + ':' + %trim(xlateStart);
    EndIf;
    sourceLine = %trimr(sourceLine) + ');';

    // Set resulting indicators?
    If lw <> *Blanks;
       ERRCheck = *On;
       ERRInd = lw;
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert Z-ADD.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_Z_ADD;

    sourceLine = %trim(result) + ' = ' + %trim(factor2) + ';';

    // Half-adjust required?
    If %len(%trim(operator)) > 5;
       sourceLine = 'Eval(H) ' + %trim(sourceLine);
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

/Eject
 //-------------------------------------------------------------------------------------------
 // Convert Z-SUB.
 //-------------------------------------------------------------------------------------------
 BegSr subUserCvt_Z_SUB;


    sourceLine = %trim(result) + ' = ' + %trim(factor2) + ' * -1;';

    // Half-adjust required?
    If %len(%trim(operator)) > 5;
       sourceLine = 'Eval(H) ' + %trim(sourceLine);
    EndIf;

    convert = *On;

 EndSr;
 //-------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================

/Eject
//==========================================================================================
// Convert D-Spec
//==========================================================================================
Dcl-Proc convertD_Spec;

// -- Procedure Interface ------------------------------------------------------------------
// -- Data Structures ----------------------------------------------------------------------
// -- Variables ----------------------------------------------------------------------------
Dcl-C DSKEYWORDS '*PROC *STATUS *OPCODE *ROUTINE *PARMS *FILE *RECORD *SIZE *INP *OUT *MODE';

Dcl-S inDatastructureDecl           Ind;
Dcl-S fieldName                    Char(80);

//-------------------------------------------------------------------------------------------

//////   // Move Prototype Definitions to here?
//////   If seqProcDefs = 0;
//////      seqProcDefs = SRCSEQ - 0.01;
//////   EndIf;

    // Keep blank lines.
    If codeLine = *Blanks;
       sourceLine = *Blanks;
       convert = *On;
       Return;
    EndIf;

    sourceLine = fullLine;

    //      declType = %xlate(lo:up:declType);
    workDeclAttr = %xlate(lo:up:declAttr);

    checkSpan();  // Does this line span more than one line?

    //If not inDeclaration;
    If not inDeclaration or declName = *Blanks;
       If not inDeclaration;
          //Exsr subUserGetDeclarationType;
          GetDeclarationType(workDeclType:savedName:workDeclLine);
       EndIf;

       //-------------------------------------------------------------------------
       // Stand-alone Field Definition.
       //-------------------------------------------------------------------------
       If workDeclType = 'S';      // Stand-alone field.
          Exsr subStandAlone;

          //-------------------------------------------------------------------------
          // Constant Definition.
          //-------------------------------------------------------------------------
       ElseIf workDeclType = 'C';
          Exsr subConstant;

          //-------------------------------------------------------------------------
          // Prototype/Interface/Datastructure Definition.
          //-------------------------------------------------------------------------
       ElseIf workDeclType = 'PR'
           or inPrototype
           or workDeclType = 'PI'
           or inInterface
           or workDeclType = 'DS'
           or inDatastructure;
           Exsr subBlockDefinition;

          //-------------------------------------------------------------------------
          // Unsupported.
          //-------------------------------------------------------------------------
       Else;
          inDeclaration = *Off;
          convert = *Off;
          Return;
       EndIf;

       //-------------------------------------------------------------------------
       // Second+ line of declaration.
       //-------------------------------------------------------------------------
    Else;
       Clear DCLS;
       DCLS.definition = %trim(declKeyWords);
       If not inSpan;
          DCLS.definition = %trim(DCLS.definition) + ';';
          inDeclaration = *Off;
       EndIf;
       sourceLine = DCLS;
       inSpan = *Off;
    EndIf;

    convert = *On;

   Return;

//------------------------------------------------------------------------------------------
// Stand-alone field definition.
//------------------------------------------------------------------------------------------
BegSr subStandAlone;

   inDeclaration = *On;

   Clear DCLS;

   // FROMFILE is not allowed.
   If %scan('FROMFILE':%xlate(lo:up:declKeywords)) > 0;
      inDeclaration = *Off;
      nonConvRsn = 'FROMFILE not allowed in Free-Form';
      convert = *Off;
      LeaveSr;
   EndIf;

   If savedName <> *Blanks;
      DCLS.decl = 'Dcl-S ';
      %subst(DCLS:7) = savedName;

      // Store name?
      storeVariable(savedName);
   EndIf;

   If DCLPR.fieldName <> *Blanks;
   EndIf;

   // Type.
   If workDeclAttr = *Blanks
   and DCLS.type = *Blanks;
      If declLen = *Blanks;
         // No definition (probably in keywords - e.g. LIKE()).
      ElseIf declScale = *Blanks;
         workDeclAttr = 'A';
      Else;
         If inDatastructure;
            workDeclAttr = 'S';
         Else;
            workDeclAttr = 'P';
         EndIf;
      EndIf;
   EndIf;

   If workDeclAttr = *Blanks;
      // No definition (probably in keywords - e.g. LIKE()).
   ElseIf workDeclAttr = 'A';
      x = %scan('VARYING':%xlate(lo:up:declKeywords));
      If x > 0;
         DCLS.type = '  VarChar';
         declKeywords = %subst(declKeywords:x+7);
      Else;
         DCLS.type = '     Char';
      EndIf;
   ElseIf workDeclAttr = 'P';
      DCLS.type = '   Packed';
   ElseIf workDeclAttr = 'D';
      DCLS.type = '     Date';
      x = %scan('DATFMT':%xlate(lo:up:declKeywords));
      If x > 0;
         x = %scan('(':declKeywords:x);
         y = %scan(')':declKeywords:x);
         DCLS.definition = '('
                   + %subst(declKeywords:x+1:y-x-1)
                   + ')';
         declKeywords = %subst(declKeywords:y+1);
      EndIf;
   ElseIf workDeclAttr = 'T';
      DCLS.type = '     Time';
      x = %scan('TIMFMT':%xlate(lo:up:declKeywords));
      If x > 0;
         x = %scan('(':declKeywords:x);
         y = %scan(')':declKeywords:x);
         DCLS.definition = '('
                   + %subst(declKeywords:x+1:y-x-1)
                   + ')';
         declKeywords = %subst(declKeywords:y+1);
      EndIf;
   ElseIf workDeclAttr = 'Z';
      DCLS.type = 'TimeStamp';
   ElseIf workDeclAttr = 'I';
      DCLS.type = '      Int';
   ElseIf workDeclAttr = 'U';
      DCLS.type = '      Uns';
   ElseIf workDeclAttr = 'S';
      DCLS.type = '    Zoned';
   ElseIf workDeclAttr = 'F';
      DCLS.type = '    Float';
   ElseIf workDeclAttr = 'N';
      DCLS.type = '      Ind';
   ElseIf workDeclAttr = '*';
      DCLS.type = '  Pointer';
   ElseIf workDeclAttr = 'B';
      DCLS.type = '   BinDec';
   ElseIf workDeclAttr = 'G';
      x = %scan('VARYING':%xlate(lo:up:declKeywords));
      If x > 0;
         DCLS.type = ' VarGraph';
         declKeywords = %subst(declKeywords:x+7);
      Else;
         DCLS.type = '    Graph';
      EndIf;
   Else;
      inDeclaration = *Off;
      convert = *Off;
      LeaveSr;
   EndIf;

   // Attributes.
   If workDeclAttr <> '*'
   and workDeclAttr <> 'N'
   and workDeclAttr <> 'D'
   and workDeclAttr <> 'T'
   and workDeclAttr <> 'Z'
   and workDeclAttr <> *Blank
   and DCLS.type <> *Blanks;
      DCLS.definition = '(' + %trim(declLen);
      If declScale <> *Blanks;
         DCLS.definition = %trimr(DCLS.definition)
                         + ':' + %trim(declScale);
      EndIf;
      DCLS.definition = %trimr(DCLS.definition) + ')';
   EndIf;

   // Keywords.
   If declKeyWords <> *Blanks;
      // Expand DTAARA?
      x = %scan('DTAARA(':%xlate(lo:up:declKeywords));
      If x > 0;
         i = %scan(')':declKeywords:x+1);
         If i > 0;
            If %scan('*VAR':%subst(declKeywords:x+7:i-x-7)) > 0;

/if defined(V7R3M0)
               j = %scan(':':declKeywords:x+7:i-x-7);
/else
               j = %scan(':':declKeywords:x+7);
               If j >= i-x-7;
                  j = 0;
               EndIf;
/endif

               declKeywords = %subst(declKeywords:1:x+6)
                  + %trim(%subst(declKeywords:j+1:i-j-1))
                  + %subst(declKeywords:i);
            Else;
               If %scan('''':%subst(declKeywords:x+7:i-x-7)) = 0;
                  declKeywords = %subst(declKeywords:1:x+6)
                     + ''''
                     + %xlate(lo:up:%trim(%subst(declKeywords:x+7:i-x-7)))
                     + ''''
                     + %subst(declKeywords:i);
               EndIf;
            EndIf;
         EndIf;
      EndIf;

      // Try to put the keywords into the new line.
      If DCLS.definition = *Blanks and DCLS.type = *Blanks;         // Expand DTAARA?

         DCLS.definition = %trim(declKeyWords);
      Else;
         // How big is it?
         x = %len(%trim(%trim(DCLS.definition) + ' ' + %trim(declKeyWords)));
         If x > 38;
            x = %len(%trim(%trim(DCLS.type)
                                 + %trim(DCLS.definition) + ' '
                                 + %trim(declKeyWords)));

               %subst(DCLS:71-x) = %trim(%trim(DCLS.type)
                                 + %trim(DCLS.definition) + ' '
                                 + %trim(declKeyWords));
         Else;
            DCLS.definition = %trimr(DCLS.definition) + ' '
                            + %trim(declKeyWords);
         EndIf;
      EndIf;
   EndIf;

   If comment <> *Blanks;
      If %subst(%trim(comment):1:2) = '//';
         DCLS.comment = '   ' + comment;
      Else;
         DCLS.comment = '// ' + comment;
      EndIf;
   EndIf;

   If not inSpan;
      DCLS.definition = %trimr(DCLS.definition) + ';';
      // Continuation of constant must start at left margin.
      If inContinuation;
         DCLS = DCLS.definition;
      EndIf;
      inDeclaration = *Off;
   Else;
      // Continuation of constant must start at left margin.
      If inContinuation;
         DCLS = DCLS.definition;
      EndIf;
      inSpan = *Off;
   EndIf;

   If %subst(DCLS:%len(%trim(DCLS)):1) = '-';
      inContinuation = *On;
   Else;
      inContinuation = *Off;
   EndIf;

   // Converted line...
   sourceLine = DCLS;
   If not inSpan;
      savedName = *Blanks;
   EndIf;

EndSr;
//------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------
// Constant definition.
//------------------------------------------------------------------------------------------
BegSr subConstant;

   inDeclaration = *On;

   Clear DCLS;
   If savedName <> *Blanks;
      DCLS.decl = 'Dcl-C ';
      %subst(DCLS:7) = %xlate(lo:up:savedName);
   EndIf;

   // Keywords.
   If declKeyWords <> *Blanks;
      If DCLS.definition = *Blanks;
         DCLS.definition = %trimr(declKeyWords);
      Else;
         DCLS.definition = %trimr(DCLS.definition) + ' '
                         + %trim(declKeyWords);
      EndIf;
   EndIf;

   // Strip off CONST keyword...
   x = %scan('CONST(':%xlate(lo:up:DCLS.definition));
   If x > 0;
      DCLS.definition = %subst(DCLS.definition:x+6);
   EndIf;

/if defined(V7R3M0)
   x = %scanr(')':DCLS.definition);
/else
   x = 0;
   For i = %len(DCLS.definition) downto 1;
      If %subst(DCLS.definition:i:1) = ')';
         x = i;
         Leave;
      EndIf;
   EndFor;
/endif
   If x > 0
   and x = %len(%trimr(DCLS.definition));
      DCLS.definition = %subst(DCLS.definition:1:x-1);
   EndIf;

   If comment <> *Blanks;
      If %subst(%trim(comment):1:2) = '//';
         DCLS.comment = '   ' + comment;
      Else;
         DCLS.comment = '// ' + comment;
      EndIf;
   EndIf;

   If not inSpan;
      DCLS.definition = %trimr(DCLS.definition) + ';';
      // Continuation of constant must start at left margin.
      If DCLS.decl = *Blanks;
         DCLS = DCLS.definition;
      EndIf;
      inDeclaration = *Off;
   Else;
      // Continuation of constant must start at left margin.
      If DCLS.decl = *Blanks;
         DCLS = DCLS.definition;
      EndIf;
      inSpan = *Off;
   EndIf;

   // Converted line...
   sourceLine = DCLS;
   If not inSpan;
      savedName = *Blanks;
   EndIf;

EndSr;
//------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------
// Prototype/Interface/Datastructure definition.
//------------------------------------------------------------------------------------------
BegSr subBlockDefinition;

   Clear DCLPR;

   // Determine where to end the structure.
   If not inPrototype
   and not inInterface
   and not inDatastructure;
      getDeclarationEndLine();
      If workDeclType = 'PR';
         inPrototype = *On;
      ElseIf workDeclType = 'PI';
         inInterface = *On;
      ElseIf workDeclType = 'DS';
         inDatastructure = *On;
         inDatastructureDecl = *On;
         endDS = *On;
      EndIf;
      DCLPR.decl = 'Dcl-' + workDeclType;
      If savedName = *Blanks;
         savedName = '*N';
      EndIf;
      %subst(DCLPR:8) = savedName;
      //DCLPR.procName = savedName;
      endDeclType = workDeclType;
      workDeclName = savedName;
   Else;
//      If savedName = *Blanks;
//         savedName = '*N';
//      EndIf;
      DCLPR.fieldName = savedName;
   EndIf;

   If not inDeclaration;
      If DCLPR.fieldName = *Blanks;
         DCLPR.fieldName = '*N';
      EndIf;
      inDeclaration = *On;
   EndIf;

   // Store name?
   If inDatastructure
   and DCLPR.fieldName <> *Blanks;
      If %subst(DCLPR.fieldName:1:1) = '-';
         fieldName = %xlate(lo:up:%subst(DCLPR.fieldName:5));
      Else;
         fieldName = %xlate(lo:up:DCLPR.fieldName);
      EndIf;

      storeVariable(fieldName);
   EndIf;

   // Type.
   If workDeclAttr = *Blanks
   and DCLPR.type = *Blanks;
      If declLen = *Blanks or declLen = 'E';
         // No definition (probably in keywords - e.g. LIKE()).
      ElseIf declScale = *Blanks;
         workDeclAttr = 'A';
      Else;
         If inDatastructure;
            workDeclAttr = 'S';
         Else;
            workDeclAttr = 'P';
         EndIf;
      EndIf;
   EndIf;

   If workDeclAttr = *Blanks;
      // No definition (probably in keywords - e.g. LIKE()).
   ElseIf workDeclAttr = 'A';
      If DCLPR.decl = 'Dcl-DS';
         If declLen <> *Blanks;
            DCLPR.type = '      Len';
         EndIf;
      Else;
         x = %scan('VARYING':%xlate(lo:up:declKeywords));
         If x > 0;
            DCLPR.type = '  VarChar';
            declKeywords = %subst(declKeywords:x+7);
         Else;
            DCLPR.type = '     Char';
         EndIf;
      EndIf;
   ElseIf workDeclAttr = 'P';
      DCLPR.type = '   Packed';
   ElseIf workDeclAttr = 'D';
      DCLPR.type = '     Date';
      x = %scan('DATFMT':%xlate(lo:up:declKeywords));
      If x > 0;
         x = %scan('(':declKeywords:x);
         y = %scan(')':declKeywords:x);
         DCLS.definition = '('
                   + %subst(declKeywords:x+1:y-x-1)
                   + ')';
         declKeywords = %subst(declKeywords:y+1);
      EndIf;
   ElseIf workDeclAttr = 'T';
      DCLPR.type = '     Time';
      x = %scan('TIMFMT':%xlate(lo:up:declKeywords));
      If x > 0;
         x = %scan('(':declKeywords:x);
         y = %scan(')':declKeywords:x);
         DCLS.definition = '('
                   + %subst(declKeywords:x+1:y-x-1)
                   + ')';
         declKeywords = %subst(declKeywords:y+1);
      EndIf;
   ElseIf workDeclAttr = 'Z';
      DCLPR.type = 'TimeStamp';
   ElseIf workDeclAttr = 'I';
      DCLPR.type = '      Int';
   ElseIf workDeclAttr = 'U';
      DCLPR.type = '      Uns';
   ElseIf workDeclAttr = 'S';
      DCLPR.type = '    Zoned';
   ElseIf workDeclAttr = 'F';
      DCLPR.type = '    Float';
   ElseIf workDeclAttr = 'N';
      DCLPR.type = '      Ind';
   ElseIf workDeclAttr = '*';
      DCLPR.type = '  Pointer';
   ElseIf workDeclAttr = 'B';
      DCLPR.type = '   BinDec';
   ElseIf workDeclAttr = 'G';
      x = %scan('VARYING':%xlate(lo:up:declKeywords));
      If x > 0;
         DCLPR.type = ' VarGraph';
         declKeywords = %subst(declKeywords:x+7);
      Else;
         DCLPR.type = '    Graph';
      EndIf;
   Else;
      inDeclaration = *Off;
      convert = *Off;
      LeaveSr;
   EndIf;

   // Attributes.
   If workDeclAttr <> '*'
   and workDeclAttr <> 'N'
   and workDeclAttr <> 'D'
   and workDeclAttr <> 'T'
   and workDeclAttr <> 'Z'
   and workDeclAttr <> *Blank
   and DCLPR.type <> *Blanks;
      DCLPR.definition = '(';
      If inDatastructure and declFrom <> *Blanks;
         workLength = %dec(%trim(declLen):7:0)
                    - %dec(%trim(declFrom):7:0) + 1;
         If workDeclAttr = 'B';
            workLength = workLength * 2;
         ElseIf workDeclAttr = 'P';
            workLength = (workLength * 2) - 1;
         EndIf;
         adjustArrayLength(workLength);
         DCLPR.definition = %trim(DCLPR.definition)
                          + %char(workLength);
      Else;
         DCLPR.definition = %trim(DCLPR.definition)
                          + %trim(declLen);
      EndIf;

      If declScale <> *Blanks;
         DCLPR.definition = %trimr(DCLPR.definition)
                         + ':' + %trim(declScale);
      EndIf;
      DCLPR.definition = %trimr(DCLPR.definition) + ')';
   EndIf;

   // From specified?
   If inDatastructure;
      If declFrom <> *Blanks
      and %scan('...':declOptions) = 0;
         If %scan(%xlate(lo:up:%trim(declFrom)):DSKEYWORDS) > 0;
            declKeywords = %xlate(LO:UP:declFrom) + %xlate(LO:UP:declLen)
                         + ' ' + declKeywords;
         Else;
            declKeywords = 'Pos(' + %trim(declFrom) + ') ' + declKeywords;
         EndIf;
      Else;
         // Overlay specified using the base datastructure name?
         // This is not permitted in free-form, so convert it to 'POS'.
         x = %scan('OVERLAY(':%xlate(lo:up:declKeywords));
         If x > 0;
            i = %scan(':':declKeywords:x);
            If i > 0;
               If %trim(%xlate(lo:up
                       :%subst(declKeywords:x+8:i-x-8))) =
                  %xlate(lo:up:workDeclName);
                  j = %scan(')':declKeywords:i);
                  If j > 0;
                     If x = 1;
                        declKeywords
                         = 'Pos('
                         + %trim(%subst(declKeywords:i+1:j-i-1))
                         + %subst(declKeywords:j);
                     Else;
                        declKeywords
                          = %trim(%subst(declKeywords:1:x-1))
                          + ' Pos('
                          + %trim(%subst(declKeywords:i+1:j-i-1))
                          + %subst(declKeywords:j);
                     EndIf;
                  EndIf;
               EndIf;
            EndIf;
         EndIf;
      EndIf;

      // Require End-DS?
      If inDatastructureDecl;
         x = %scan('LIKEDS(':%xlate(lo:up:declKeywords));
         If x > 0;
            // Nope.
            endDS = *Off;
         EndIf;
         x = %scan('LIKEREC(':%xlate(lo:up:declKeywords));
         If x > 0;
            // Nope.
            endDS = *Off;
         EndIf;
      EndIf;
   EndIf;

   // Datastructure type?
   If declPrefix = 'S';       // Program Status
      declKeywords = 'PSDS ' + declKeywords;
      If savedName = DCLPR.procName;
         %subst(savedName:16:1) = *Blank;
      EndIf;
      %subst(DCLPR.procName:16:1) = *Blank;

   ElseIf declPrefix = 'U';   // Dataarea
      // If not already defined as a data area, do it now.
      If %scan('DTAARA':%xlate(lo:up:declKeywords)) = 0;
         If declName = *Blanks;
            declKeywords = 'DTAARA(*AUTO) ' + declKeywords;
         Else;
            declKeywords = 'DTAARA ' + declKeywords;
         EndIf;
      EndIf;
      %subst(DCLPR.procName:16:1) = *Blank;
   EndIf;

   // Keywords.
   If declKeyWords <> *Blanks;
      // Expand EXTNAME?
      x = %scan('EXTNAME(':%xlate(lo:up:declKeywords));
      If x > 0;
         i = %scan(')':declKeywords:x+1);
         If i > 0;
            If %scan('''':%subst(declKeywords:x+8:i-x-8)) = 0;
               declKeywords = %subst(declKeywords:1:x+7)
                  + ''''
                  + %xlate(lo:up:%trim(%subst(declKeywords:x+8:i-x-8)))
                  + ''''
                  + %subst(declKeywords:i);
            EndIf;
         EndIf;
      EndIf;
      // Expand DTAARA?
      x = %scan('DTAARA(':%xlate(lo:up:declKeywords));
      If x > 0;
         i = %scan(')':declKeywords:x+1);
         If i > 0;
            If %scan('*VAR':%subst(declKeywords:x+7:i-x-7)) > 0;
/if defined(V7R3M0)
               j = %scan(':':declKeywords:x+7:i-x-7);
/else
               j = %scan(':':declKeywords:x+7);
               If j >= i-x-7;
                  j = 0;
               EndIf;
/endif
               declKeywords = %subst(declKeywords:1:x+6)
                  + %trim(%subst(declKeywords:j+1:i-j-1))
                  + %subst(declKeywords:i);
            Else;
               If %scan('''':%subst(declKeywords:x+7:i-x-7)) = 0;
                  declKeywords = %subst(declKeywords:1:x+6)
                     + ''''
                     + %xlate(lo:up:%trim(%subst(declKeywords:x+7:i-x-7)))
                     + ''''
                     + %subst(declKeywords:i);
               EndIf;
            EndIf;
         EndIf;
      EndIf;
      If DCLPR.definition = *Blanks and DCLPR.type = *Blanks;
         DCLPR.definition = %trim(declKeyWords);
      Else;
         DCLPR.definition = %trimr(DCLPR.definition) + ' '
                         + %trim(declKeyWords);
      EndIf;
   EndIf;

   If comment <> *Blanks;
      If %subst(%trim(comment):1:2) = '//';
         DCLPR.comment = '   ' + comment;
      Else;
         DCLPR.comment = '// ' + comment;
      EndIf;
   EndIf;

   If not inSpan;
      If DCLPR.definition = *Blanks and DCLPR.type = *Blanks;
         DCLPR.procName = %trimr(DCLPR.procName) + ';';
      Else;
         DCLPR.definition = %trimr(DCLPR.definition) + ';';
      EndIf;
      inDeclaration = *Off;
      inDatastructureDecl = *Off;
   Else;
      inSpan = *Off;
   EndIf;

   // Converted line...
   sourceLine = DCLPR;
   If not inSpan;
      savedName = *Blanks;
   EndIf;

EndSr;
//------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================

/Eject
//==========================================================================================
// Convert F-Spec ro fre--format.
//==========================================================================================
Dcl-Proc convertF_Spec;

// -- Procedure Interface ------------------------------------------------------------------
Dcl-PI *N;
End-PI;

// -- Data Structures ----------------------------------------------------------------------
// -- Variables ----------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------

//////   // Move Prototype Definitions to here?
//////   If SRCSEQ >= seqProcDefs;
//////      seqProcDefs = SRCSEQ + 0.01;
//////   EndIf;

    // Keep blank lines.
    If codeLine = *Blanks;
       sourceLine = *Blanks;
       convert = *On;
       Return;
    EndIf;

    sourceLine = fullLine;

    workFileUsage  = %xlate(lo:up:fileUsage);
    workFileDesig  = %xlate(lo:up:fileDesig);
    workFileAdd    = %xlate(lo:up:fileAdd);
    workFileDevice = %xlate(lo:up:fileDevice);
    workFileKeyed  = %xlate(lo:up:fileKeyed);

    checkSpan();  // Does this line span more than one line?

    If not inDeclaration;

       // Validate whether this can be converted.
       If workFileUsage = 'I'
       and (workFileDesig = 'P'
       or workFileDesig = 'S'
       or workFileUsage = 'T')

       or workFileUsage = 'O'
       and workFileAdd = 'A'

       or workFileUsage = 'U'
       and (workFileDesig = 'P'
       or workFileDesig = 'S')

       or workFileUsage = 'C'
       and workFileDesig = 'T';

          // Not supported in free-form.
          inDeclaration = *Off;
          convert = *Off;
          nonConvRsn = 'File usage not supported in free-form';
          Return;
       EndIf;

       savedName = %trim(fileName);

       If %xlate(lo:up:fileExternal) = 'E';       // Externally-described file.
          inDeclaration = *On;

          Clear DCLF;
          DCLF.decl = 'Dcl-F ';
          %subst(DCLF:7) = %xlate(lo:up:savedName);

          // Set device type.
          If workFileDevice <> 'DISK';
             DCLF.device = workFileDevice;
          EndIf;

          // Set usage.
          If workFileUsage = 'I';
             If workFileAdd = ' ';
                If workFileDevice <> 'DISK'
                and workFileDevice <> 'SEQ'
                and workFileDevice <> 'SPECIAL';
                   DCLF.definition = '*INPUT';
                EndIf;
             Else;
                DCLF.definition = '*INPUT:*OUTPUT';
             EndIf;
          ElseIf workFileUsage = 'U';
             If workFileAdd = ' ';
                DCLF.definition = '*UPDATE:*DELETE';
             Else;
                DCLF.definition = '*UPDATE:*DELETE:*OUTPUT';
             EndIf;
          ElseIf workFileUsage = 'O';
             If workFileDevice <> 'PRINTER';
                DCLF.definition = '*OUTPUT';
             EndIf;
          ElseIf workFileUsage = 'C';
             If workFileDevice <> 'WORKSTN';
                DCLF.definition = '*INPUT:*OUTPUT';
             EndIf;
          EndIf;

          // Pad out usage.
          If DCLF.definition <> *Blanks;
             DCLF.definition = 'Usage(' + %trim(DCLF.definition) + ')';
          EndIf;

          // Keyed file?
          If workFileKeyed = 'K';
             DCLF.definition = %trim(%trim(DCLF.definition)
                                     + ' ' + 'Keyed');
          EndIf;

          If comment <> *Blanks;
             If %subst(%trim(comment):1:2) = '//';
                DCLF.comment = '   ' + comment;
             Else;
                DCLF.comment = '// ' + comment;
             EndIf;
          EndIf;

          // Keywords.
          If fileKeyWords <> *Blanks;
             // Do we have room to insert the keywords here?
             checkLength = %len(%trim(%trim(DCLF.definition)
                                     + ' ' + %trim(fileKeyWords))) + 1;

             If comment <> *Blanks;
                checkLength += 3;
             EndIf;

             If checkLength > %len(DCLF.definition);
                // Not enoungh room for the keywords, so output the current line.
                savedSRCDTA = SRCDTA;
                lineType = *Blank;
                directive = *Blanks;
                codeLine = DCLF;
                writeLine();
                SRCDTA = savedSRCDTA;
                // ...and move the keywords to their own line.
                Clear DCLF;
                DCLF.definition = fileKeywords;
                savedComment = *Blanks;
             Else;
                DCLF.definition = %trim(%trim(DCLF.definition)
                                        + ' ' + %trim(fileKeyWords));
             EndIf;
          EndIf;

          If not inSpan;
             DCLF.definition = %trimr(DCLF.definition) + ';';
             inDeclaration = *Off;
          Else;
             inSpan = *Off;
          EndIf;

          // Converted line...
          sourceLine = DCLF;

       Else;
          inDeclaration = *Off;
          convert = *Off;
          nonConvRsn = 'File not externally-described';
          Return;
       EndIf;

    Else;                   // Second+ line of declaration
       Clear DCLF;
       DCLF.definition = %trim(fileKeyWords);
       If not inSpan;
          DCLF.definition = %trim(DCLF.definition) + ';';
       EndIf;
       sourceLine = DCLF;
       inSpan = *Off;
    EndIf;

    convert = *On;

   Return;

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================

/Eject
//==========================================================================================
// Convert H-Spec
//==========================================================================================
Dcl-Proc convertH_Spec;

// -- Procedure Interface ------------------------------------------------------------------
Dcl-PI *N;
End-PI;

// -- Data Structures ----------------------------------------------------------------------
// -- Variables ----------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------

//////   // Move Prototype Definitions to here?
//////   If SRCSEQ >= seqProcDefs;
//////      seqProcDefs = SRCSEQ + 0.01;
//////   EndIf;

    // Keep blank lines.
    If codeLine = *Blanks;
       sourceLine = *Blanks;
       convert = *On;
       Return;
    EndIf;

    sourceLine = codeLine;

    checkSpan();  // Does this line span more than one line?

    If not inDeclaration;
       inDeclaration = *On;

       Clear DCLH;
       DCLH.decl = 'Ctl-Opt ';
       DCLH.options = %trim(declOptions);

       If comment <> *Blanks;
          If %subst(%trim(comment):1:2) = '//';
             DCLH.comment = '   ' + comment;
          Else;
             DCLH.comment = '// ' + comment;
          EndIf;
       EndIf;

       If not inSpan;
          DCLH.options = %trimr(DCLH.options) + ';';
          inDeclaration = *Off;
       Else;
          inSpan = *Off;
       EndIf;

       // Converted line...
       sourceLine = DCLH;

    Else;                   // Second+ line of declaration
       Clear DCLH;
       DCLH.options = %trim(declOptions);
       If not inSpan;
          DCLH.options = %trim(DCLH.options) + ';';
       EndIf;
       sourceLine = DCLH;
       inSpan = *Off;
    EndIf;

    convert = *On;

   Return;

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================

/Eject
//==========================================================================================
// Convert P-Spec
//==========================================================================================
Dcl-Proc convertP_Spec;

// -- Procedure Interface ------------------------------------------------------------------
Dcl-PI *N;
End-PI;

// -- Data Structures ----------------------------------------------------------------------
// -- Variables ----------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------

    // Keep blank lines.
    If codeLine = *Blanks;
       sourceLine = *Blanks;
       convert = *On;
       Return;
    EndIf;

    sourceLine = fullLine;

    checkSpan();  // Does this line span more than one line?

    If not inDeclaration;   // First line of procedure start/end.
       If not inDeclaration;
          //Exsr subUserGetDeclarationType;
          GetDeclarationType(workDeclType:savedName:workDeclLine);
       EndIf;

       If workDeclType = 'B'       // Begin.
       or workDeclType = 'E'       // End.
       or declName <> *Blanks;
          inDeclaration = *On;

          Clear DCLP;
          //            If savedName <> *Blanks;
          If workDeclType = 'B';
             DCLP.decl = 'Dcl-Proc ';
          Else;
             DCLP.decl = 'End-Proc ';
          EndIf;
          DCLP.definition = savedName;
          //            EndIf;

          If procKeyWords <> *Blanks;
             DCLP.definition = %trimr(DCLP.definition)
                             + ' ' + %trim(procKeyWords);
          EndIf;

          If comment <> *Blanks;
             If %subst(%trim(comment):1:2) = '//';
                DCLP.comment = '   ' + comment;
             Else;
                DCLP.comment = '// ' + comment;
             EndIf;
          EndIf;

          If not inSpan;
             DCLP.definition = %trimr(DCLP.definition) + ';';
             inDeclaration = *Off;
          Else;
             inSpan = *Off;
          EndIf;

          // Converted line...
          sourceLine = DCLP;
          savedName = *Blanks;

       Else;
          inDeclaration = *Off;
          convert = *Off;
          Return;
       EndIf;

    Else;                   // Second+ line of procedure start/end.
       Clear DCLP;
       DCLP.definition = %trim(declKeyWords);
       If not inSpan;
          DCLP.definition = %trimr(DCLP.definition) + ';';
       EndIf;
       sourceLine = DCLP;
       inSpan = *Off;
    EndIf;

    convert = *On;

   Return;

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================

/Eject
//==========================================================================================
// Get the line number at which the current structure ends.
//==========================================================================================
Dcl-Proc getDeclarationEndLine;

// -- Procedure Interface ------------------------------------------------------------------
Dcl-PI *N;
End-PI;

// -- Data Structures ----------------------------------------------------------------------
// -- Variables ----------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------

    savedSRCDTA = SRCDTA;
    endLine = 0;
    endFound = *Off;

    // Read ahead to find the start of the next declaration.
    Read INPSRC InpLine;
    x = 1;
    DoW not %eof();
       If lineType <> *Blanks;
          If %xlate(lo:up:lineType) = workLineType;
             If codeLine = *Blanks;
                // Ignore empty lines.
             ElseIf %subst(directive:1:1) = '/';
                // Ignore directives.
             ElseIf %subst(directive:2:1) = '*'
                 or %len(%trim(codeLine)) >= 2
                and %subst(%trim(codeLine):1:2) = '//';
                // Ignore comment.
             ElseIf inSpan
                and declName = *Blanks
                and SRCSEQ = workDeclLine;
                // Ignore the curent declaration.
             ElseIf declType = *Blanks
                and (declLen <> *Blanks or declKeywords <> *Blanks);
                // Ignore sub-field definition.
             ElseIf declType = *Blanks
                and declName <> *Blanks
                and %scan('...':declOptions) = 0;
                // Ignore sub-field definition.
             ElseIf %scan('...':declOptions) > 0;
                // We have a continuation line, but is it a sub-field or a new
                // delcaration?
                GetDeclarationType(tempDeclType
                                  :tempSavedName
                                  :tempDeclLine);
                If tempDeclType <> *Blanks;
                   // We've hit the next declaration or code.
                   Leave;
                EndIf;
             Else;
                // We've hit the next declaration or code.
                Leave;
             EndIf;
          Else;
             // We've found a different line type.
             Leave;
          EndIf;
       Else;
          If %len(%trim(codeLine)) >= 4;
             If %xlate(lo:up:%subst(codeLine:1:4)) = 'DCL-';
                // We've found a different line type.
                Leave;
             EndIf;
          EndIf;
       EndIf;

       Read INPSRC InpLine;
       x += 1;     // Keep a track of how many lines we have read.
    EndDo;

    // End of file breaks the logic!  We need to reposition to the last record before
    // continuing.
    If %eof(INPSRC);
       SetGT *HIVAL INPSRC;
       SRCSEQ += 0.01;
    EndIf;

    // We are now at the start of the next declaration.
    endLine = SRCSEQ;

    // Return to the previous point.
    For i = 1 to x;
       ReadP INPSRC InpLine;

       // Move the end point for blank lines or comments.
       If not endFound;
          If (lineType = *Blanks
          or %subst(directive:1:1) = '*'
          or %subst(directive:1:2) = '//'
          or (%len(%trim(codeLine)) > 0
          and %subst(%trim(codeLine):1:2) = '//'))
          and %xlate(lo:up:%subst(directive:1:6)) <> '/ENDIF';
             endLine = SRCSEQ;
          Else;
             endFound = *On;
          EndIf;
       EndIf;
    EndFor;

    SRCDTA = savedSRCDTA;

   Return;

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================

/Eject
//==========================================================================================
// Get the type of declaration encountered - it may not be on the current line!
//==========================================================================================
Dcl-Proc getDeclarationType;

// -- Procedure Interface ------------------------------------------------------------------
Dcl-PI GetDeclarationType;
   @pDeclType               Char( 2 );
   @pSavedName              Char( 80 );
   @pDeclLine                        Like(SRCSEQ);
End-PI;

// -- Data Structures ----------------------------------------------------------------------

// -- Variables ----------------------------------------------------------------------------
Dcl-S savedLineType        Char(  1 );
Dcl-S x                  Packed( 3:0 );
Dcl-S savedSRCDTA          Char( 100 );

//-------------------------------------------------------------------------------------------

   // Start with what we've got.
   If ((declExt = ' ' and declPrefix  = ' ')
   or declPrefix = 'S' or declPrefix = 'U')
   and declSuffix = ' ';
      @pDeclType = %xlate(lo:up:declType);
      @pSavedName = %trim(declName);
   Else;
      @pDeclType = *Blank;
      @pSavedName = %trim(%subst(fullLine:1:74));
   EndIf;

   x = %scan(' ':@pSavedName);
   If x > 1;
      @pSavedName = %subst(@pSavedName:1:x-1);
   EndIf;

   // If we already have the declaration type, then stop.
   If @pDeclType = 'S'
   or @pDeclType = 'DS'
   or @pDeclType = 'C'
   or @pDeclType = 'B'
   or @pDeclType = 'E'
   or @pDeclType = 'PR'
   or @pDeclType = 'PI'
   or @pDeclType = *Blanks and inPrototype;
      @pDeclLine = SRCSEQ;
      @pSavedName = %trimr(@pSavedName:'. ');
      Return;
   EndIf;

   savedSRCDTA = SRCDTA;
   savedLineType = %xlate(lo:up:lineType);      // Save current line type for comparison.
   @pDeclLine = 0;

   //   // Name of the variable/routine should be on this line.
   //   savedName = %trim(declOptions);

   // Trim any ellipsis from the name as this is not valid in free-form.
   x = %scan('...':@pSavedName);
   If x > 0;
      @pSavedName = %trimr(@pSavedName:'. ');
   ElseIf declFrom <> *Blanks
       or declLen <> *Blanks
       or declOptions <> *BLanks;
      // It's not a declaration - it's a subfield.
      @pDeclType = %xlate(lo:up:declType);
      @pDeclLine = SRCSEQ;
      Return;
   EndIf;

   // Read ahead to find the next line with a declaration type.
   x = 0;
   Read INPSRC InpLine;
   DoW not %eof();
      x += 1;     // Keep a track of how many lines we have read.

      lineType = %xlate(lo:up:lineType);

      If lineType <> savedLineType;
         // End of this declaration.
         Leave;
      EndIf;

      If declType <> *Blanks;
         // We have found the declaration.
         @pDeclType = %xlate(lo:up:declType);
         @pDeclLine = SRCSEQ;
         Leave;
      ElseIf declFrom <> *Blanks
          or declLen <> *Blanks
          or declOptions <> *BLanks;
         // It's not a declaration - it's a subfield.
         @pDeclType = %xlate(lo:up:declType);
         @pDeclLine = SRCSEQ;
         Leave;
      EndIf;

      Read INPSRC InpLine;
   EndDo;

   // End of file breaks the logic!  We need to reposition to the last record before
   // continuing.
   If %eof(INPSRC);
      SetGT *HIVAL INPSRC;
      ReadP INPSRC InpLine;
   EndIf;

   // Return to the previous point.
   For i = 1 to x;
      ReadP INPSRC InpLine;
   EndFor;

   SRCDTA = savedSRCDTA;

   Return;

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================

/Eject
//==========================================================================================
// Move in-line definitions to the end of the declarations.
//==========================================================================================
Dcl-Proc moveDefinitions;

   // -- Procedure Interface ------------------------------------------------------------------

   // -- Data Structures ----------------------------------------------------------------------
   Dcl-DS movedDefs                       Qualified DIM(999);
      variableName                    Char(14);
      sourceLine                      Char(93);
   End-DS;

   // -- Variables ----------------------------------------------------------------------------
   Dcl-S x                             Int(5);
   Dcl-S moved                         Ind;
   Dcl-S moveDef                       Ind;
   Dcl-S useINArray                    Ind;

   //-------------------------------------------------------------------------------------------

   codeStart = SRCSEQ;   // Save the start of the source.
   savedSRCDTA = SRCDTA;

   Clear movedDefs;
   Reset DCLS;
   moved = *Off;
   useINArray = *Off;

   // Read through the source and create a D-spec for every field definition found.
   DoW not %eof(INPSRC);
      // Stop if we hit either the start or end of a procedure (to preserve local
      // definitions of variables).
      If lineType = 'P'
      or %xlate(lo:up:%subst(%trim(codeLine) + '        ':1:8))
                                                   = 'DCL-PROC'
      or %xlate(lo:up:%subst(%trim(codeLine) + '        ':1:8))
                                                   = 'END-PROC';
         Leave;
      EndIf;

      If %xlate(lo:up:lineType) = 'C'
      and %subst(directive:1:1) = ' ';
         opCode = %xlate(lo:up:opCode);
         // C-Spec with a size definition.
         If opCode <> *Blanks
         and %subst(opCode:1:4) <> 'EVAL'
         and opCode <> 'IF'
         and opCode <> 'WHEN'
         and opCode <> 'DOW'
         and opCode <> 'DOU'
         and opCode <> 'DSPLY'
         and %subst(opCode:1:5) <> 'CALLP'
         and (len <> *Blanks or opCode = 'DEFINE' or opCode = 'DO' and result = *Blanks)
         or  opCode = 'MOVEA'
         and %subst(result:1:3) = '*IN'
         and (%scan('''1':factor2) > 0 or %scan('''0':factor2) > 0);
            moveDef = *Off;
            // Special case: DO with a count variable.
            If opCode = 'DO' and result = *Blanks;
               result = 'ZZ_doCount';
               len = '9';
               dec = '0';
            EndIf;
            // Special case: MOVEA referencing the indicator array.
            If opCode = 'MOVEA'
            and %subst(result:1:3) = '*IN'
            and (%scan('''1':factor2) > 0 or %scan('''0':factor2) > 0);
               useINArray = *On;
            EndIf;

            // Only do if not already moved.
            If %lookup(%xlate(lo:up:result):defVariable) = 0
            and %lookup(%xlate(lo:up:result):movedDefs(*).variableName) = 0;
               Reset DCLS;
               DCLS.decl = setOpCodeCase(DCLS.decl:@pOpCodeCase);
               // In-line definition.
               If len <> *Blanks
               and %scan('+':len) = 0 and %scan('-':len) = 0;
                  moveDef = *On;
                  DCLS.fieldName = result;
                  If dec = *Blanks;
                     DCLS.type = '     Char';
                  Else;
                     DCLS.type = '   Packed';
                  EndIf;
                  DCLS.definition = '(' + %trim(len);
                  If dec <> *Blanks;
                     DCLS.definition = %trimr(DCLS.definition)
                                     + ':' + %trim(dec);
                  EndIf;
                  DCLS.definition = %trimr(DCLS.definition) + ')';
               EndIf;

               // *LIKE Definition
               If %xlate(lo:up:opCode) = 'DEFINE';
                  moveDef = *On;
                  DCLS.fieldName = result;
                  If %xlate(lo:up:factor1) = '*LIKE';
                     %subst(DCLS.definition:8)
                                 = 'LIKE(' + %trimr(factor2);
                     // Length adjustment?
                     If %scan('+':len) > 0 or %scan('-':len) > 0;
                        len = %scanrpl(' ':'':len);
                        DCLS.definition = %trimr(DCLS.definition)
                                        + ':' + %trim(len);
                     EndIf;
                     DCLS.definition = %trimr(DCLS.definition) + ')';
                  Else;
                     If %xlate(lo:up:%trim(factor2)) = '*LDA';
                        DCLS.definition = %trimr(DCLS.definition)
                              + ' DTAARA(' + %trimr(factor2) + ')';
                     ElseIf factor2 = *Blanks;
                        DCLS.definition = %trimr(DCLS.definition)
                          + ' DTAARA';
                     Else;
                        DCLS.definition = %trimr(DCLS.definition)
                          + ' DTAARA(''' + %trimr(factor2) + ''')';
                     EndIf;
                  EndIf;
               EndIf;

               If moveDef;
                  // Put any additional keywords needed here!
                  DCLS.definition = %trimr(DCLS.definition) + ';';
                  If comment <> *Blanks;
                     DCLS.comment = '// ' + comment;
                  EndIf;

                  // Store the moved definition.
                  x = %lookup(' ':movedDefs(*).variableName);
                  movedDefs(x).variableName = %xlate(lo:up:result);
                  movedDefs(x).sourceLine = DCLS;
                  moved = *On;
               EndIf;
            EndIf;
         EndIf;
      EndIf;

      Read INPSRC InpLine;
   EndDo;

   // Provide variables to perform conversion of indicator array moves.
   If useINArray;
      Reset DCLS;

      result = 'zz_indArray';
      DCLS.fieldName = 'zz_indArray';
      DCLS.type = '     Char';
      DCLS.definition = '(99) Based(zz_IndArrayPtr);';

      // Store the moved definition.
      x = %lookup(' ':movedDefs(*).variableName);
      movedDefs(x).variableName = %xlate(lo:up:result);
      movedDefs(x).sourceLine = DCLS;

      result = 'zz_indArrayPtr';
      DCLS.fieldName = 'zz_indArrayPtr';
      DCLS.type = '  Pointer';
      DCLS.definition = '     Inz(%addr(*IN));';

      // Store the moved definition.
      x = %lookup(' ':movedDefs(*).variableName);
      movedDefs(x).variableName = %xlate(lo:up:result);
      movedDefs(x).sourceLine = DCLS;
      moved = *On;
   EndIf;

   // Anything to output?
   If moved;
      SortA movedDefs(*).variableName;
      For x = 1 to %elem(movedDefs);
         If movedDefs(x).variableName <> *Blanks;
            If not defsMoved;
               // Log start of moved field block;
               SRCDTA = *Blanks;
               codeLine = @comments(1);
               writeLine();
               codeLine = @comments(2);
               writeLine();
               codeLine = @comments(1);
               writeLine();
               defsMoved = *On;
            EndIf;

            lineType = ' ';
            codeLine = movedDefs(x).sourceLine;
            countMoved += 1;

            writeLine();
         EndIf;
      EndFor;

      If defsMoved;
         // Log end of moved field block;
         SRCDTA = *Blanks;
         codeLine = @comments(1);
         writeLine();
         codeLine = @comments(3);
         writeLine();
         codeLine = @comments(1);
         writeLine();
      EndIf;
   EndIf;

   // Reposition source file pointer to the start of the source again.
   SetLL *Start INPSRC;
   Read INPSRC InpLine;
   DoW SRCSEQ <> codeStart;
      Read INPSRC InpLine;
   EndDo;

   defsMoved = *On;
   SRCDTA = savedSRCDTA;

   Return;

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================

/Eject
//==========================================================================================
// If factor1 a key list, expand it to contain the key fields.
//==========================================================================================
Dcl-Proc getKeyList;

   // -- Procedure Interface ------------------------------------------------------------------
   Dcl-PI *N                  VarChar(93);
      factor1                    Char(14);
   End-PI;

   // -- Data Structures ----------------------------------------------------------------------
   // -- Variables ----------------------------------------------------------------------------
   Dcl-S keyFields         VarChar(93);
   Dcl-S listName             Char(14);
   Dcl-S x                     Int(3);
   //-------------------------------------------------------------------------------------------

   keyFields = %trim(factor1);

   // Do we have any key lists, and if so, is factor1 the name of one?
   If keyListCount > 0
   and factor1 <> *Blanks;
      listName = %xlate(LO:UP:%trim(factor1));

      x = %lookup(listName:keyList(*).listName:1:keyListCount);

      If x > 0;
         keyFields = '(' + %trim(keyList(x).keyFields) + ')';
      EndIf;
   EndIf;

   // Return the list of key fields (or just factor1 of none exist).
   Return keyFields;

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================

/Eject
//==========================================================================================
// Extract key lists for use in conversions.
//==========================================================================================
Dcl-Proc extractKeyLists;

   // -- Procedure Interface ------------------------------------------------------------------
   // -- Data Structures ----------------------------------------------------------------------

   // -- Variables ----------------------------------------------------------------------------
   Dcl-S x                             Int(5);
   Dcl-S inKeyList                     Ind;

   //-------------------------------------------------------------------------------------------

   Clear keyList;
   inKeyList = *Off;
   x = 0;
   keyListCount = 0;

   // Conversion of key lists requested?
   If @pConvKLIST <> 'Y';
      Return;
   EndIf;

   SetLL *Start INPSRC;
   Read INPSRC InpLine;

   // Read through the source and create a record of every key List found.
   DoW not %eof(INPSRC);

      If inKeyList;
         // End of key list?
         If lineType = 'C'
         and %xlate(LO:UP:opCode) <> 'KFLD'
         and %subst(directive:1:1) <> '*'
         and opCode <> *Blanks;
            inKeyList = *Off;
            // Avoid an empty key list.
            If keyList(x).keyFields = *Blanks;
               keyList(x).listName = *Blanks;
               x -= 1;
            EndIf;

         // New key field.
         ElseIf lineType = 'C'
         and %xlate(LO:UP:opCode) = 'KFLD'
         and %subst(directive:1:1) <> '*';
            If factor2 = *Blanks;
               If keyList(x).keyFields = *Blanks;
                  keyList(x).keyFields = %xlate(LO:UP:result);
               Else;
                  keyList(x).keyFields = %trim(keyList(x).keyFields) + ':' + %xlate(LO:UP:result);
               EndIf;
            Else;
               // Key field conditioning indicator detected - abort the extraction of this key list.
               inKeyList = *Off;
               keyList(x).listName = *Blanks;
               keyList(x).keyFields = *Blanks;
               x -= 1;
            EndIf;
         EndIf;
      EndIf;

      If not inKeyList;
         // New key list - store the name.
         If lineType = 'C' and %xlate(LO:UP:opCode) = 'KLIST'
         and %subst(directive:1:1) <> '*';
            inKeyList = *On;
            x += 1;
            keyList(x).listName  = %xlate(LO:UP:factor1);
            keyList(x).keyFields = *Blanks;
         EndIf;
      EndIf;

      Read INPSRC InpLine;
   EndDo;

   keyListCount = x;

   Return;

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================

/Eject
//==========================================================================================
// Extract parameter list for use in conversions.
//==========================================================================================
Dcl-Proc extractParameterLists;

   // -- Procedure Interface ------------------------------------------------------------------
   // -- Data Structures ----------------------------------------------------------------------

   // -- Variables ----------------------------------------------------------------------------
   Dcl-S x                             Int(5);
   Dcl-S f                             Int(5);
   Dcl-S p                             Int(5);
   Dcl-S inParmList                     Ind;
   Dcl-S inArrayData                    Ind;

   //-------------------------------------------------------------------------------------------

   Clear parmList;
   inParmList = *Off;
   inArrayData = *Off;
   x = 0;
   p = 0;
   parmListCount = 0;

   // Conversion of parameter lists requested?
   If @pConvPLIST <> 'Y';
      Return;
   EndIf;

   SetLL *Start INPSRC;
   Read INPSRC InpLine;

   // Read through the source and create a record of every parameter List found.
   DoW not %eof(INPSRC);

      If %subst(SRCDTA:1:2) = '**';
         inArrayData = *On;
      EndIf;

      // Save position of output prototypes?
      If not inArrayData
         and (lineType = 'H' or lineType = 'F');
         seqProcDefs = SRCSEQ + 0.01;
      EndIf;

      If inParmList;
         // End of parameter list?
         If lineType = 'C'
         and %xlate(LO:UP:opCode) <> 'PARM'
         and %subst(directive:1:1) <> '*'
         and opCode <> *Blanks;
            inParmList = *Off;

         // New parameter.
         ElseIf lineType = 'C'
         and %xlate(LO:UP:opCode) = 'PARM'
         and %subst(directive:1:1) <> '*';
            p += 1;
            Clear DCLS;
            DCLS.fieldName = result;
            // In-line definition.
            If len <> *Blanks
            and %scan('+':len) = 0 and %scan('-':len) = 0;
               If dec = *Blanks;
                  DCLS.type = '     Char';
               Else;
                  DCLS.type = '   Packed';
               EndIf;
               DCLS.definition = '(' + %trim(len);
               If dec <> *Blanks;
                  DCLS.definition = %trimr(DCLS.definition)
                                  + ':' + %trim(dec);
               EndIf;
               DCLS.definition = %trimr(DCLS.definition) + ')';
            Else;
               DCLS.definition = 'Like(' + %trimr(DCLS.fieldName) + ')';
            EndIf;

            DCLS = %trimr(DCLS) + ';';
            If comment <> *Blanks;
               DCLS.comment = '// ' + comment;
            EndIf;

            parmList(x).parameterDef(p).parmName = result;
            parmList(x).parameterDef(p).parmInput = factor2;
            parmList(x).parameterDef(p).parmOutput = factor1;
            parmList(x).parameterDef(p).parmDef = DCLS;

            // For *ENTRY with mapped parameters, flag that we have already output it so that it
            // doesn't get converted - this is temporary until I get time to code the mappings
            // correctly.
            If parmList(x).listName = '*ENTRY'
            and (factor1 <> *Blanks or factor2 <> *Blanks);
               parmList(x).convert = *Off;
            EndIf;
         EndIf;
      EndIf;

      If not inParmList;
         // New parameter list - store the name.
         If lineType = 'C'
         and (%xlate(LO:UP:opCode) = 'PLIST'
           or %xlate(LO:UP:opCode) = 'CALL'
           or %xlate(LO:UP:opCode) = 'CALLB'
           or %xlate(LO:UP:%subst(opCode:1:5)) = 'CALL('
           or %xlate(LO:UP:%subst(opCode:1:6)) = 'CALLB(')
         and %subst(directive:1:1) <> '*';
            inParmList = *On;
            x += 1;
            parmList(x).lineNumber = SRCSEQ;
            If %xlate(LO:UP:opCode) = 'PLIST';
               parmList(x).listName  = %xlate(LO:UP:factor1);
               parmList(x).listType = 'PLIST';
            Else;
               parmList(x).listName  = %xlate(LO:UP:factor2);
               parmList(x).listProgram = %xlate(LO:UP:factor2);
               If %subst(parmList(x).listName:1:1) <> '''';     // Variable program call.
                  parmList(x).listName = %trim(parmList(x).listName) + '_';
               EndIf;
               parmList(x).listType = 'PGM';
               If result <> *Blanks;   // Program call uses a real parameter list.
                  parmList(x).listPList = %xlate(LO:UP:result);
               EndIf;
            EndIf;
            parmList(x).convert = *On;
            p = 0;
            Clear parmList(x).parameterDef;
         EndIf;
      EndIf;

      Read INPSRC InpLine;
   EndDo;

   parmListCount = x;

   Return;

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================

/Eject
//==========================================================================================
// Extract a list of TAGs and whether or not they are used.
//==========================================================================================
Dcl-Proc extractTAGs;

   // -- Procedure Interface ------------------------------------------------------------------
Dcl-PI *N                              Int(5) End-PI;

   // -- Data Structures ----------------------------------------------------------------------

   // -- Variables ----------------------------------------------------------------------------
   Dcl-S tagCount                        Int(5);
   Dcl-S tagName                        Char(14);
   Dcl-S wkFactor1                      Char(14);
   Dcl-S wkFactor2                      Char(14);
   Dcl-S wkOpCode                       Char(14);
   Dcl-S thisTag                         Int(5);

   //-------------------------------------------------------------------------------------------

   Clear tagList;
   tagCount = 0;

   SetLL *Start INPSRC;
   Read INPSRC InpLine;

   // Read through the source and create list of every tag found.
   DoW not %eof(INPSRC);

      // New key list - store the name.
      If lineType = 'C'
      and %subst(directive:1:1) <> '*';

         wkOpCode = %xlate(LO:UP:opCode);
         wkFactor1 = %xlate(LO:UP:factor1);

         Select;
            When wkOpCode = 'TAG';
               tagName = wkFactor1;
               Exsr subUserAddToArray;

               tagList(thisTag).tagType = 'TAG';

            When wkOpCode = 'ENDSR' and factor1 <> *Blanks;
               tagName = wkFactor1;
               Exsr subUserAddToArray;

               tagList(thisTag).tagType = 'ENDSR';

            When wkOpCode = 'GOTO';
               tagName = %xlate(LO:UP:factor2);
               Exsr subUserAddToArray;

               tagList(thisTag).tagUsed = *On;
               tagList(thisTag).tagUsageCount += 1;

            When wkOpCode = 'GOTO' or %subst(wkOpCode:1:3) = 'CAB';
               tagName = %xlate(LO:UP:result);
               Exsr subUserAddToArray;

               tagList(thisTag).tagUsed = *On;
               tagList(thisTag).tagUsageCount += 1;

         EndSl;
      EndIf;

      Read INPSRC InpLine;
   EndDo;


   Return tagCount;
//-------------------------------------------------------------------------------------------

/Eject
//-------------------------------------------------------------------------------------------
// Add to array.
//-------------------------------------------------------------------------------------------
BegSr subUserAddToArray;

   // Get the index for this TAG.
   thisTag = %lookup(tagName:tagList(*).tagName:1:tagCount);

   // If not already in the array, add it.
   If thisTag = 0;
      tagCount += 1;
      thisTag = tagCount;
      tagList(thisTag).tagName = tagName;
   EndIf;

EndSr;
//-------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================

/Eject
//==========================================================================================
// Remove non-printable characters from the line.
//==========================================================================================
Dcl-Proc removeNonPrintable;

   // -- Procedure Interface ------------------------------------------------------------------
   Dcl-PI *N;
      codeLine                     Char(93);
   End-PI;

   // -- Data Structures ----------------------------------------------------------------------
   //
   Dcl-C PRINTABLE                 ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-
-=¬!"£$%^&*()_+\|,<.>/?[{]};:@#~''';

   // -- Variables ----------------------------------------------------------------------------
   Dcl-S length                    Int(3);
   Dcl-S x                         Int(3);
   Dcl-S comment               VarChar(93);

   //-------------------------------------------------------------------------------------------

   // Only if requested.
   If @pRmvNonPrint <> 'Y';
      Return;
   EndIf;

   comment = %trimr(codeLine);
   length = %len(%trimr(comment));

   x = %check(PRINTABLE:comment);

   DoW x > 0;
      %subst(comment:x:1) = ' ';

      x = %check(PRINTABLE:comment:x);
   EndDo;

   codeLine = %trimr(comment);

   Return;

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================

/Eject
//==========================================================================================
// Remove end-of-comment markers.
//==========================================================================================
Dcl-Proc removeEndCommentMarker;

   // -- Procedure Interface ------------------------------------------------------------------
   Dcl-PI *N;
      removeMarkers                Char(1) Const;
      codeLine                     Char(93);
   End-PI;

   // -- Data Structures ----------------------------------------------------------------------

   // -- Variables ----------------------------------------------------------------------------
   Dcl-S length                    Int(3);
   Dcl-S comment               VarChar(93);

   //-------------------------------------------------------------------------------------------

   // Only if requested.
   If removeMarkers <> 'Y';
      Return;
   EndIf;

   comment = %trimr(codeLine);
   length = %len(%trimr(comment));

   If length >= 4;
      If %subst(comment:length-1:2) = ' *';
         codeLine = %subst(comment:1:length-2);
      ElseIf %subst(codeLine:length-2:3) = ' //';
         codeLine = %subst(comment:1:length-3);
      EndIf;
   EndIf;

   Return;

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================

/Eject
//==========================================================================================
// Write out any prototype definitions.
//==========================================================================================
Dcl-Proc outputPrototypeDefs;

   // -- Procedure Interface ------------------------------------------------------------------
   // -- Data Structures ----------------------------------------------------------------------

   // -- Variables ----------------------------------------------------------------------------
   Dcl-S x                         Int(3);
   Dcl-S y                         Int(3);
   Dcl-S p                         Int(3);
   Dcl-S protTitle                 Ind;
   Dcl-S protName                 Char(14);
   //-------------------------------------------------------------------------------------------

   // Only do this once.
   procsOutput = *On;

   // No prototypes to output.
   If parmListCount =0;
      Return;
   EndIf;

   // *ENTRY list first.
   For x = 1 to parmListCount;
      If parmList(x).listName = '*ENTRY'
      and parmList(x).convert;
         savedSRCDTA = SRCDTA;
         Clear SRCDTA;

         writeLine('');
         writeLine('       // Procedure Interface');
         writeLine('       Dcl-PI ' + %trim(@pFromMbr) + ';');
         For p = 1 to %elem(parmList.parameterDef);
            If parmList(x).parameterDef(p).parmDef = *Blanks;
               Leave;
            EndIf;
            writeLine('    ' + parmList(x).parameterDef(p).parmDef);
            If parmList(x).parameterDef(p).parmDef <> *Blanks;

   // Store names?
   storeVariable(parmList(x).parameterDef(p).parmName);

            EndIf;
         EndFor;
         writeLine('       End-PI;');

         SRCDTA = savedSRCDTA;
      EndIf;
   EndFor;

   // Prototypes next.
   For x = 1 to parmListCount;
      If parmList(x).listType = 'PGM' and not parmList(x).listOutput;
         protName = parmList(x).listName;
         savedSRCDTA = SRCDTA;
         Clear SRCDTA;

         writeLine('');
         If not protTitle;
            writeLine('       // Prototypes');
            protTitle = *On;
         EndIf;

         Reset DCLPR;
         DCLPR.procName = %scanrpl('''':'':parmList(x).listName);
         DCLPR.definition = 'ExtPgm(' + %trim(parmList(x).listProgram) + ');';
         writeLine('       ' + DCLPR);
         parmList(x).listOutput =*On;

         If parmList(x).listPList <> *Blanks;
            y = %lookup(parmList(x).listPList:parmList(*).listName);
         Else;
            y = x;
         EndIf;
         For p = 1 to %elem(parmList.parameterDef);
            If parmList(y).parameterDef(p).parmDef = *Blanks;
               Leave;
            EndIf;
            writeLine('    ' + parmList(y).parameterDef(p).parmDef);
         EndFor;
         writeLine('       End-PR;');

         // Flag any duplicates as output so we don't try to output them again.
         For y = 1 to parmListCount;
            If parmList(y).listType = 'PGM'
            and parmList(y).listName = protName
            and parmList(y).listOutput = *Off;
               parmList(y).listOutput = *On;
            EndIf;
         EndFor;

         SRCDTA = savedSRCDTA;
      EndIf;
   EndFor;

   writeLine('');

   Return;

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================

/Eject
//==========================================================================================
// Write out a line to the output member.
//==========================================================================================
Dcl-Proc writeLine;

   // -- Procedure Interface ------------------------------------------------------------------
Dcl-PI *N;
   outputSource          Char(240) Const   Options(*NoPass);
End-PI;

   // -- Data Structures ----------------------------------------------------------------------
Dcl-DS OutLine            Len(256) Qualified;
   SRCSEQ               Zoned(6:2);
   SRCDAT               Zoned(6:0);
   SRCDTA                Char(240);
End-DS;

   // -- Variables ----------------------------------------------------------------------------
Dcl-S lineMarker         Char(5);

   //-------------------------------------------------------------------------------------------

   countTarget += 1;

   If %parms() = 0;
      OutLine = InpLine;
   Else;
      OutLine.SRCSEQ = SRCSEQ;
      OutLine.SRCDAT = SRCDAT;
      OutLine.SRCDTA = outputSource;
   EndIf;

   // Using fully-free?  Shift to left margin.
   If fullyFree;
      lineMarker = %subst(OutLine.SRCDTA:1:5);
      If %subst(OutLine.SRCDTA:7:1) <> *Blank;
         OutLine.SRCDTA = %subst(OutLine.SRCDTA:7);
      Else;
         OutLine.SRCDTA = %subst(OutLine.SRCDTA:8);
      EndIf;

      If lineMarker <> *Blanks and @pRetLineMaker = 'Y';
         %subst(OutLine.SRCDTA:94) = '//' + lineMarker;
      EndIf;
   EndIf;

   Write OUTSRC OutLine;

   Return;

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================

/Eject
//==========================================================================================
// Check if the current line spans more than one line.
//==========================================================================================
Dcl-Proc checkSpan;

   // -- Procedure Interface ------------------------------------------------------------------
   // -- Data Structures ----------------------------------------------------------------------
   // -- Variables ----------------------------------------------------------------------------
   Dcl-S nameEnd                    Uns(5);
   Dcl-S ellipsis                   Uns(5);

   //-------------------------------------------------------------------------------------------

   inspan = *Off;
   savedSRCDTA = SRCDTA;
   savedLineType = %xlate(lo:up:lineType);      // Save current line type for comparison.
   x = 0;

   // Is the current line a continuation line?
   If savedLineType = 'D';
      If declName <> *Blanks;
         nameEnd = %scan(' ':declOptions);
         ellipsis = %scan('...':%trim(declOptions));
         If ellipsis > 0 and ellipsis < nameEnd;
            // Yes - so we must be in a span.
            inSpan = *On;
         EndIf;
      EndIf;
   EndIf;

   If not inSpan;
      //       x = -1;   // Start by looking at the current line.
      Read INPSRC inpLine;

      DoW not %eof();

         x += 1;     // Keep a track of how many lines we have read.

         lineType = %xlate(lo:up:lineType);

         If lineType <> *Blank
         and lineType <> savedLineType;
            // Not a spanned line.
            Leave;

         ElseIf lineType <> *Blank
            and fullLine = *Blanks;
            // Comment line, so ignore.

         ElseIf lineType = 'D'
         and %subst(directive:1:1) <> '*';                       // D-spec and no comment
            If declName = *Blanks
            and declType = *Blanks
            and (declLen = *Blanks and declAttr = *Blanks)
            and declKeyWords <> *Blanks;
               //               and ((declType <> *Blanks and workDeclType = *Blanks)
               //                    or (declType <> *Blanks and declType <> workDeclType)
               //                    or (declType = *Blanks and declKeyWords <> *Blanks));
               inSpan = *On;
            EndIf;
            Leave;

         ElseIf lineType = 'P'
         and %subst(directive:1:1) <> '*';                       // P-spec and no comment
            If declName = *Blanks
            and (procType <> *Blanks or procKeyWords <> *Blanks);
               inSpan = *On;
            EndIf;
            Leave;

         ElseIf lineType = 'H'
         and %subst(directive:1:1) = *Blank;                     // H-spec and no comment
            inSpan = *On;
            Leave;

         ElseIf lineType = 'C'
         and %subst(directive:1:1) = *Blank;                      // C-spec and no comment
            opCode = %xlate(lo:up:opCode);
            If condInd <> *Blanks;                                 // Conditioning indicators
               // Not a spanned line.
               Leave;
            ElseIf %subst(operator:1:4) = 'EVAL';
               If opCode = *Blanks and extFactor2 <> *Blanks;     // EVAL continues.
                  inSpan = *On;
               EndIf;
               Leave;
            ElseIf %subst(operator:1:5) = 'CALLP';
               If opCode = *Blanks;                               // CALLP continues.
                  inSpan = *On;
               EndIf;
               Leave;
            ElseIf operator = 'IF';                               // IF Continues.
               If opCode = *Blanks;
                  inSpan = *On;
               EndIf;
               Leave;
            ElseIf %subst(operator:1:2) = 'IF';                   // IF Continues.
               If %subst(opCode:1:2) = 'OR'
               or %subst(opCode:1:3) = 'AND'
               or opCode = *Blanks;
                  inSpan = *On;
               EndIf;
               Leave;
            ElseIf %subst(operator:1:2) = 'DO';                   // DO Continues.
               If %subst(opCode:1:2) = 'OR'
               or %subst(opCode:1:3) = 'AND'
               or opCode = *Blanks;
                  inSpan = *On;
               EndIf;
               Leave;
            ElseIf %subst(operator:1:4) = 'WHEN';                 // WHEN Continues.
               If %subst(opCode:1:2) = 'OR'
               or %subst(opCode:1:3) = 'AND'
               or opCode = *Blanks;
                  inSpan = *On;
               EndIf;
               Leave;
            EndIf;

         ElseIf lineType = 'C'
         and %subst(directive:1:1) = '+';                        // Embedded SQL
            inSpan = *On;
            Leave;

         ElseIf lineType = 'F'
         and %subst(directive:1:1) <> '*';                       // F-spec and no comment
            If fileName = *Blanks and fileKeyWords <> *Blanks;
               inSpan = *On;
            EndIf;
            Leave;

         ElseIf %subst(directive:1:1) = '/';          // Directive, so line must end here.
            Leave;
         //            ElseIf lineType = ' '
         //            and opCode <> *Blanks;
         //               Leave;                                       // Free-format line.
         EndIf;

         Read INPSRC InpLine;
      EndDo;
   EndIf;

   // End of file breaks the logic!  We need to reposition to the last record before
   // continuing.
   If %eof(INPSRC);
      SetGT *HIVAL INPSRC;
      ReadP INPSRC InpLine;
   EndIf;

   // Return to the previous point.
   For i = 1 to x;
      ReadP INPSRC InpLine;
   EndFor;

   SRCDTA = savedSRCDTA;

   Return;

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================

/Eject
//==========================================================================================
// Check for an array definition and adjust the length according to the number of elements.
//==========================================================================================
Dcl-Proc adjustArrayLength;

   // -- Procedure Interface ------------------------------------------------------------------
   Dcl-PI AdjustArrayLength;
      @pLength               Packed( 7:0 );
   End-PI;

   // -- Data Structures ----------------------------------------------------------------------

   // -- Variables ----------------------------------------------------------------------------
   Dcl-S x                  Packed( 3:0 );
   Dcl-S i                  Packed( 3:0 );
   Dcl-S j                  Packed( 3:0 );
   Dcl-S elements           Packed( 5:0 );
   Dcl-S savedSRCDTA          Char( 100 );

   //-------------------------------------------------------------------------------------------

   savedSRCDTA = SRCDTA;
   x = 0;

   // Read ahead to find the next line with a declaration type.
   DoW not %eof();
      // Array definition on the current line?
      i = %scan('DIM(':%xlate(lo:up:declKeywords));

      If i > 0;
         j = %scan(')':declKeywords:i+4);
         elements = %dec(%subst(declKeywords:i + 4:j - i - 4):7:0);
         // Adjust the length of the variable.
         If %rem(@pLength:elements) = 0;
            @pLength = %div(@pLength:elements);
         EndIf;
         Leave;
      EndIf;

      Read INPSRC InpLine;
      If not %eof(INPSRC);
         x += 1;     // Keep a track of how many lines we have read.

         lineType = %xlate(lo:up:lineType);

         If lineType <> *Blank
         and lineType <> 'D';
            // Not part of this definition - stop looking for array definition.
            Leave;

         ElseIf lineType = 'D'
         and %subst(directive:1:1) <> '*';                       // D-spec and no comment
            If declName <> *Blanks;
               // A new declaration - stop looking for array definition.
               Leave;
            EndIf;
         ElseIf %scan('DCL-':%xlate(lo:up:%trim(codeLine))) > 0;
            // A new declaration - stop looking for array definition.
            Leave;
         EndIf;
      EndIf;
   EndDo;

   // End of file breaks the logic!  We need to reposition to the last record before
   // continuing.
   If %eof(INPSRC);
      SetGT *HIVAL INPSRC;
      ReadP INPSRC InpLine;
   EndIf;

   // Return to the previous point.
   For i = 1 to x;
      ReadP INPSRC InpLine;
   EndFor;

   SRCDTA = savedSRCDTA;

   Return;

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================

/Eject
//==========================================================================================
// Store a variable name.
//==========================================================================================
Dcl-Proc storeVariable;

   // -- Procedure Interface ------------------------------------------------------------------
   Dcl-PI *N;
      variableName               Char(80) Const;
   End-PI;

   // -- Data Structures ----------------------------------------------------------------------
   // -- Variables ----------------------------------------------------------------------------
   Dcl-S x                        Int(5);
   Dcl-S name                    Char(80);

   //-------------------------------------------------------------------------------------------

   If variableName = *Blanks;
      Return;
   EndIf;

   name = %xlate(lo:up:variableName);

   x = %lookup(name:defVariable);
   If x > 0;
      Return;
   EndIf;

   x = %lookup(' ':defVariable);
   defVariable(x) = name;

   Return;

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================

/Eject
//==========================================================================================
// Renumber the input source lines: existing numbers cannot be trusted!
//==========================================================================================
Dcl-Proc renumberSource;

   // -- Procedure Interface ------------------------------------------------------------------
   Dcl-PI *N;
   End-PI;

   // -- Data Structures ----------------------------------------------------------------------
   // -- Variables ----------------------------------------------------------------------------
   Dcl-S seqNumber              Zoned(6:2);

   //-------------------------------------------------------------------------------------------

   seqNumber = 0;

   SetLL *Start INPSRC;
   Read INPSRC inpLine;

   DoW not %eof(INPSRC);
      seqNumber += 0.01;
      inpLine.SRCSEQ = seqNumber;
      Update INPSRC inpLine;
      Read INPSRC inpLine;
   EndDo;

      seqNumber += 0.01;
      inpLine.SRCSEQ = seqNumber;
      inpLine.SRCDTA = *Blanks;
      Write INPSRC inpLine;

   Return;

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================

/Eject
//==========================================================================================
// Set the case of the opcode or declaration.
//==========================================================================================
Dcl-Proc setOpCodeCase;

   // -- Procedure Interface ------------------------------------------------------------------
   Dcl-PI *N               VarChar(10);
      @pOpCode             VarChar(10) Const;
      @pCase                  Char(6)  Const;
   End-PI;

   // -- Data Structures ----------------------------------------------------------------------
   // -- Variables ----------------------------------------------------------------------------
   Dcl-S opCode            VarChar(10);

   //-------------------------------------------------------------------------------------------

   opCode = @pOpCode;

   Select;
      When @pCase = '*UPPER';
         opCode = %xlate(lo:up:opCode);

      When @pCase = '*LOWER';
         opCode = %xlate(up:lo:opCode);

      Other;
         // Leave as is, as it should already be 'mixed'.
   EndSl;

   Return opCode;

//------------------------------------------------------------------------------------------
End-Proc;
//==========================================================================================
**CTDATA @opCodeUP
ACQ       Acq
BEGSR     BegSr
CALLP     CallP
CHAIN     Chain
CLEAR     Clear
CLOSE     Close
COMMIT    Commit
DEALLOC   DeAlloc
DELETE    Delete
DOU       DoU
DOW       DoW
DSPLY     Dsply
DUMP      Dump
ELSE      Else
ELSEIF    ElseIf
ENDDO     EndDo
ENDFOR    EndFor
ENDIF     EndIf
ENDMON    EndMon
ENDSL     EndSl
ENDSR     EndSr
EVAL      Eval
EVALR     EvalR
EVAL-CORR Eval-Corr
EXCEPT    Except
EXFMT     Exfmt
EXSR      Exsr
EXEC SQL  Exec SQL
FEOD      FEOD
FOR       For
FORCE     Force
IF        If
IN        In
ITER      Iter
LEAVE     Leave
LEAVESR   LeaveSr
MONITOR   Monitor
NEXT      Next
ON-ERROR  On-Error
OPEN      Open
OTHER     Other
OUT       Out
POST      Post
READ      Read
READC     ReadC
READE     ReadE
READP     ReadP
READPE    ReadPE
REL       Rel
RESET     Reset
RETURN    Return
ROLBK     RolBk
SELECT    Select
SETGT     SetGT
SETLL     SetLL
SORTA     SortA
TEST      Test
UNLOCK    Unlock
UPDATE    Update
WHEN      When
WRITE     Write
XML-INTO  XML-Into
XMLSAX    XMLSAX
ENDCS     ----------
AND       and
OR        or
**CTDATA @declUP
DCL-F     Dcl-F
DCL-S     Dcl-S
DCL-C     Dcl-C
DCL-PR    Dcl-PR
DCL-PI    Dcl-PI
DCL-PROC  Dcl-Proc
DCL-DS    Dcl-DS
END-DS    End-DS
END-PR    End-PR
END-PI    End-PI
END-PROC  End-Proc
CTL-OPT   Ctl-Opt
**CTDATA @comments
//===========================================================================================
// Start of moved field definitions.
// End of moved field definitions. 
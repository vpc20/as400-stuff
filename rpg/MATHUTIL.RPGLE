**FREE

// ============================================================
// Service Program: MATHUTIL
// Description   : Math utility procedures
// ============================================================

CTL-OPT NOMAIN;  // No main entry point  this is a service program

// -------------------------------------------------------
// Procedure: AddNumbers
// Returns the sum of two integers
// -------------------------------------------------------
DCL-PROC AddNumbers EXPORT;
    DCL-PI *N INT(10);
        pNum1 INT(10) VALUE;
        pNum2 INT(10) VALUE;
    END-PI;

    RETURN pNum1 + pNum2;

END-PROC;


// -------------------------------------------------------
// Procedure: MultiplyNumbers
// Returns the product of two integers
// -------------------------------------------------------
DCL-PROC MultiplyNumbers EXPORT;
    DCL-PI *N INT(10);
        pNum1 INT(10) VALUE;
        pNum2 INT(10) VALUE;
    END-PI;

    RETURN pNum1 * pNum2;

END-PROC;


// -------------------------------------------------------
// Procedure: DivideNumbers
// Returns the result of dividing two decimals
// Returns -1 if division by zero is attempted
// -------------------------------------------------------
DCL-PROC DivideNumbers EXPORT;
    DCL-PI *N PACKED(15:5);
        pNum1 PACKED(15:5) VALUE;
        pNum2 PACKED(15:5) VALUE;
    END-PI;

    IF pNum2 = 0;
        RETURN -1;
    ENDIF;

    RETURN pNum1 / pNum2;

END-PROC;


// ## Binding Source  MATHUTILBND.BND in VPCRZKH1/QSRVSRC
// This defines what procedures are **exported** from the service program.

// /* Step 1: Compile the source into a module */
// CRTRPGMOD MODULE(VPCRZKH1/MATHUTIL)
//            SRCFILE(VPCRZKH1/QRPGLESRC)
//            SRCMBR(MATHUTIL)
//            DBGVIEW(*ALL)

// /* Step 2: Create the service program from the module */
// CRTSRVPGM  SRVPGM(VPCRZKH1/MATHUTIL)
//            MODULE(VPCRZKH1/MATHUTIL)
//            SRCFILE(VPCRZKH1/QSRVSRC)
//            SRCMBR(MATHUTIL)
//            EXPORT(*SRCFILE)
//            ACTGRP(*CALLER)


// /* One-time setup: add service program to a binding directory */
// CRTBNDDIR  BNDDIR(VPCRZKH1/MYBNDDIR)
// ADDBNDDIRE BNDDIR(VPCRZKH1/MYBNDDIR) OBJ((VPCRZKH1/MATHUTIL *SRVPGM))


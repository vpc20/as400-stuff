**FREE

CTL-OPT DFTACTGRP(*NO) ACTGRP(*NEW) BNDDIR('VPCRZKH1/MYBNDDIR');

// Prototype declarations
DCL-PR AddNumbers      INT(10);
    pNum1 INT(10) VALUE;
    pNum2 INT(10) VALUE;
END-PR;

DCL-PR MultiplyNumbers INT(10);
    pNum1 INT(10) VALUE;
    pNum2 INT(10) VALUE;
END-PR;

DCL-PR DivideNumbers   PACKED(15:5);
    pNum1 PACKED(15:5) VALUE;
    pNum2 PACKED(15:5) VALUE;
END-PR;

// Variables
DCL-S wSum     INT(10);
DCL-S wProduct INT(10);
DCL-S wResult  PACKED(15:5);

// Call the service program procedures
wSum     = AddNumbers(10 : 25);
wProduct = MultiplyNumbers(6 : 7);
wResult  = DivideNumbers(100 : 3);

DSPLY ('Sum: '     + %CHAR(wSum));
DSPLY ('Product: ' + %CHAR(wProduct));
DSPLY ('Divide: '  + %CHAR(wResult));

*INLR = *ON;


// CRTBNDRPG PGM(VPCRZKH1/CALLDEMO)
//            SRCFILE(VPCRZKH1/QRPGLESRC)
//            SRCMBR(CALLDEMO)
//            DBGVIEW(*ALL)



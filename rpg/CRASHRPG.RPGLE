**free
dcl-f CRASHDSP workstn;

// This will populate the field with the "poison" hex character
FLD1 = 'ABC' + x'04' + '123';
//FLD1 = 'ABC' + '123';

exfmt CRASHREC;

*inlr = *on;

// Message ID . . . . . . :   RNQ1251
// Message . . . . :   Permanent I/O error occurred in file CRASHDSP (C G D F).

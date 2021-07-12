**free

dcl-s daten1 zoned(8);

daten1 = 12312019;
test(de) *usa daten1;
if %error;
   dsply 'invalid date';
else;
   dsply 'valid date';
endif;

daten1 = 31122019;
test(de) *usa daten1;
if %error;
   dsply 'invalid date';
else;
   dsply 'valid date';
endif;

*inlr = *on;

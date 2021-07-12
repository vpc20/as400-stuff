**free

dcl-s daten1 zoned(8);
dcl-s daten2 zoned(8);


daten1 = 20191231;
daten2 = %dec(%date(daten1:*iso):*usa);
dsply daten2;

daten1 = 12312019;
daten2 = %dec(%date(daten1:*usa):*iso);
dsply daten2;

*inlr = *on;

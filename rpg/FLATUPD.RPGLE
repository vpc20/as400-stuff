**free
// Purpose: Write 3 sample records to flat file

dcl-f flatfile usage(*output) usropn qualified;

dcl-ds flatrec1 likerec(flatfile.flatrec: *all);

// Data structure for the 20-byte field
dcl-ds RecordDS qualified;
  msgText  CHAR(10);
  valZonedPos  zoned(7:2);   // 7 bytes
  valZonedNeg  zoned(7:2);   // 7 bytes
  valPackedPos packed(7:2);  // 4 bytes
  valPackedNeg packed(7:2);  // 4 bytes
  valBinaryPos int(10);      // 4 bytes
  valBinaryNeg int(10);      // 4 bytes
end-ds;

dcl-pr qcmdexc extpgm;
  theCmd char(3000) const;
  cmdLen packed(15 : 5) const;
        // 3rd parameter is optional
        // dbcs char(3) const options(*nopass);
end-pr;

dcl-s cmd varchar(100);

cmd = 'CLRPFM FILE(VPCRZKH1/FLATFILE)';
qcmdexc (cmd : %len(cmd));

open flatfile;

RecordDS.msgText      = 'Hello';
RecordDS.valZonedPos  =  123.45;
RecordDS.valZonedNeg  = -234.56;
RecordDS.valPackedPos =  345.67;
RecordDS.valPackedNeg = -456.78;
RecordDS.valBinaryPos =  5;
RecordDS.valBinaryNeg = -8;
flatrec1 = RecordDS;
write flatfile.flatrec flatrec1;

close flatfile;

*inlr = *on;
return;


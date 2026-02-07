**FREE
// Program: WRFLAT
// Purpose: Write 3 sample records to flat file
// The flat file has a 7-byte field that will contain:
//   - 4 bytes for item code (character)
//   - 3 bytes for packed decimal amount (5,2)

dcl-f flatfile usage(*output) usropn qualified;

dcl-ds flatrec1 likerec(flatfile.flatrec: *all);

// Data structure for the 7-byte field
dcl-ds RecordDS qualified;
  ItemCode CHAR(4);
  Amt PACKED(5:2);
end-ds;

// Open the file
open flatfile;

// Write 3 sample records
RecordDS.ItemCode = 'A001';
RecordDS.Amt = 125.50;
flatrec1 = RecordDS;
write flatfile.flatrec flatrec1;

RecordDS.ItemCode = 'B002';
RecordDS.Amt = 250.75;
flatrec1 = RecordDS;
write flatfile.flatrec flatrec1;

RecordDS.ItemCode = 'C003';
RecordDS.Amt = 99.99;
flatrec1 = RecordDS;
write flatfile.flatrec flatrec1;

close flatfile;

*inlr = *on;
return;


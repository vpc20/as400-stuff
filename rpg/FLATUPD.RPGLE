**free
    // Purpose: Write 3 sample records to flat file

     dcl-f flatfile usage(*output) usropn qualified;

     dcl-ds flatrec1 likerec(flatfile.flatrec: *all);

    // Data structure for the 20-byte field
     dcl-ds RecordDS qualified;
       ItemCode CHAR(4);
       valPackedPos packed(5:2);  // 3 bytes
       valPackedNeg packed(5:2);  // 3 bytes
       valZonedPos  zoned(5:2);   // 5 bytes
       valZonedNeg  zoned(5:2);   // 5 bytes
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

    // Write 3 sample records
     RecordDS.ItemCode = 'A001';
     RecordDS.valPackedPos =  121.50;
     RecordDS.valPackedNeg = -122.50;
     RecordDS.valZonedPos  =  123.50;
     RecordDS.valZonedNeg  = -124.50;
     flatrec1 = RecordDS;
     write flatfile.flatrec flatrec1;

     RecordDS.ItemCode = 'B002';
     RecordDS.valPackedPos =  51.50;
     RecordDS.valPackedNeg = -52.50;
     RecordDS.valZonedPos  =  53.50;
     RecordDS.valZonedNeg  = -54.50;
     flatrec1 = RecordDS;
     write flatfile.flatrec flatrec1;

     RecordDS.ItemCode = 'C003';
     RecordDS.valPackedPos =  1.99;
     RecordDS.valPackedNeg = -2.99;
     RecordDS.valZonedPos  =  3.99;
     RecordDS.valZonedNeg  = -4.99;
     flatrec1 = RecordDS;
     write flatfile.flatrec flatrec1;

     close flatfile;

     *inlr = *on;
     return;

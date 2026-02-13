**free
ctl-opt main(Main) dftactgrp(*no) alwnull(*usrctl);

       // Database file (USRGRP table)
dcl-f usrgrp keyed usropn usage(*update:*delete:*output) qualified;

       // Display file
dcl-f wrkusrgrpd workstn usropn indds(indic) qualified sfile(sflrec1:rrn);

       // Record Structures
dcl-ds usrgrpDs    likerec(usrgrp.usrgrp : *all);
dcl-ds sflrec1Ds   likerec(wrkusrgrpd.sflrec1 : *all);
dcl-ds sflctl1Ds   likerec(wrkusrgrpd.sflctl1 : *all);
dcl-ds fkeys1Ds    likerec(wrkusrgrpd.fkeys1  : *all);
dcl-ds recdtl1DS       likerec(wrkusrgrpd.recdtl1 : *all);


       // Key definitions
dcl-ds keyUsr      likerec(usrgrp.usrgrp : *key);

       // Constants and Variables
dcl-c maxSflSize   13;
dcl-c kAdd         'ADD';
dcl-c kChg         'CHG';
dcl-c kDel         'DEL';
dcl-c kDsp         'DSP';

dcl-s rrn          zoned(4:0);
dcl-s usrprf1      char(10);
dcl-s reloadSfl    ind;
dcl-s validData    ind;

       // Indicator Data Structure
dcl-ds indic qualified;
  exitKey         ind pos(3);
  addKey          ind pos(6);
  cancelKey       ind pos(12);

  mandatoryUsr    ind pos(25);
  mandatoryGrp    ind pos(26);

  protectKeys     ind pos(50);
  protectNonKeys  ind pos(51);

  sflMore         ind pos(70);
  sflDsp          ind pos(80);
  sflClr          ind pos(81);
  pageDown        ind pos(90);
  pageUp          ind pos(91);
end-ds;

       //-----------------------------------------------------------------------
dcl-proc Main;

  open usrgrp;
  open wrkusrgrpd;

         // Initial Load
  indic.exitKey = *off;
  clear sflctl1Ds.posto;

  setll *loval usrgrp;
  sflctl1Ds.rcdnbr = 1;
  LoadSubfile();

  dow not indic.exitKey;
    write wrkusrgrpd.fkeys1 fkeys1Ds;
    exfmt wrkusrgrpd.sflctl1 sflctl1Ds;

    select;
            //  when indic.exitKey;
              //  leave;

             // Position To logic
      when sflctl1Ds.posto <> *blanks;
        keyUsr.usrprf = sflctl1Ds.posto;
        setll %kds(keyUsr) usrgrp;
        LoadSubfile();
        sflctl1Ds.posto = *blanks;

      when indic.addKey;  // F6
        reloadSfl = *off;
        HandleDetail(kAdd : *blanks);
        if reloadSfl;
          LoadSubfile();
        endif;

      when indic.pageDown;
        if indic.sflMore;
          LoadSubfile();
        endif;

      when indic.pageUp;
        SubfilePageUp();

      other;
        reloadSfl = *off;
        ProcessSubfile();
        if reloadSfl;
          LoadSubfile();
        endif;

    endsl;
  enddo;

  close usrgrp;
  close wrkusrgrpd;
  *inlr = *on;
end-proc;

       //-----------------------------------------------------------------------
dcl-proc LoadSubfile;

         // Clear Subfile
  indic.sflClr = *on;
  write wrkusrgrpd.sflctl1 sflctl1Ds;
  indic.sflClr = *off;

  indic.sflDsp = *off;
  rrn = 0;

  read usrgrp usrgrpDs;
  dow not %eof(usrgrp) and rrn < maxSflSize;
    rrn += 1;
    sflrec1Ds.opt = *blanks;
    eval-corr sflrec1Ds = usrgrpDs;
    write wrkusrgrpd.sflrec1 sflrec1Ds;
    if rrn = 1;
      usrprf1 = sflrec1Ds.usrprf;
    endif;
    read usrgrp usrgrpDs;
  enddo;

         // 3. Set Display and More indicators
  if rrn > 0;
    indic.sflDsp = *on;
  endif;

         // display More or Bottom
  if %eof(usrgrp);
    indic.sflMore = *off;
  else;
    indic.sflMore = *on;
    readp usrgrp usrgrpDs;
  endif;
end-proc;

       //-----------------------------------------------------------------------
dcl-proc SubfilePageUp;

         // To Page Up in a page-at-a-time subfile, we must move the pointer
         // back two pages (the current page and the previous one)
  dcl-s i int(10);

         // Set cursor to the first record currently on screen
  chain 1 wrkusrgrpd.sflrec1 sflrec1Ds;
  if %found;
    keyUsr.usrprf = sflrec1Ds.usrprf;
    setll %kds(keyUsr) usrgrp;

            // Read backwards to get to the start of the previous page
    for i = 1 to (maxSflSize + 1);
      readp usrgrp usrgrpDs;
      if %eof(usrgrp);
        setll *loval usrgrp;
        leave;
      endif;
    endfor;
          //else;
          //  setll *loval usrgrp;
    LoadSubfile();
  endif;


end-proc;

       //-----------------------------------------------------------------------
dcl-proc ProcessSubfile;

  readc wrkusrgrpd.sflrec1 sflrec1Ds;
  dow not %eof(wrkusrgrpd);
    select;
      when %trim(sflrec1Ds.opt) = '2';   // Edit
        HandleDetail(kChg : sflrec1Ds.usrprf);
      when %trim(sflrec1Ds.opt) = '4';   // Delete
        HandleDetail(kDel : sflrec1Ds.usrprf);
      when %trim(sflrec1Ds.opt) = '5';   // Display
        HandleDetail(kDsp : sflrec1Ds.usrprf);
    endsl;

           // Reset option and update subfile record
    if %trim(sflrec1Ds.opt) = '4' and reloadSfl;   // Delete
      sflctl1Ds.rcdnbr = 1;
    else;
      sflctl1Ds.rcdnbr = sflctl1Ds.csrrrn;
    endif;
    sflrec1Ds.opt = *blanks;
    update wrkusrgrpd.sflrec1 sflrec1Ds;
    readc wrkusrgrpd.sflrec1 sflrec1Ds;
  enddo;

end-proc;

       //-----------------------------------------------------------------------
dcl-proc HandleDetail;

  dcl-pi *n;
    mode char(3) const; // 'ADD', 'CHG', 'DEL', 'DSP'
    pUsr char(10) const;
  end-pi;

  dcl-s confirmed ind inz(*off);

         // prepare data
  if mode = kAdd;
    clear recdtl1DS;
  else;
    keyUsr.usrprf = pUsr;
    chain %kds(keyUsr) usrgrp usrgrpDs;
    eval-corr recdtl1DS = usrgrpDs;
  endif;

         // protect fields depending on mode
  select;
    when mode = kAdd;
      indic.protectKeys    = *off;
      indic.protectNonKeys = *off;
    when mode = kChg;
      indic.protectKeys    = *on;
      indic.protectNonKeys = *off;
    when mode = kDel or mode = kDsp;
      indic.protectKeys    = *on;
      indic.protectNonKeys = *on;
  endsl;

         // 2. Display Loop
  dow not indic.cancelKey;

    exfmt wrkusrgrpd.recdtl1 recdtl1DS;

    if indic.cancelKey;
      leave;
    endif;

    ValidateRecdtl1();
    if not validData;
      iter;
    endif;

           // 3. Confirmation Logic
           // We "Display" the data, then wait for another Enter to confirm
           // This acts as the "Press Enter to Confirm" step.

    select;
      when mode = kAdd;
        usrgrpDs.usrprf = recdtl1DS.usrprf; // Ensure key is set
        usrgrpDs.grpprf = recdtl1DS.grpprf;
        write usrgrp.usrgrp usrgrpDs;
        keyUsr.usrprf = usrgrpDs.usrprf;
        setll %kds(keyUsr) usrgrp;
        sflctl1Ds.rcdnbr = 1;
        reloadSfl = *on;
        leave;

      when mode = kChg;
               // Re-chain for update lock
        chain %kds(keyUsr) usrgrp usrgrpDs;
        if %found;
          usrgrpDs.grpprf = recdtl1DS.grpprf;
          update usrgrp.usrgrp usrgrpDs;
          keyUsr.usrprf = usrprf1;
          setll %kds(keyUsr) usrgrp;
          reloadSfl = *on;
          leave;
        endif;

      when mode = kDel;
               // Confirmation for Delete
        chain %kds(keyUsr) usrgrp usrgrpDs;
        if %found;
          delete usrgrp.usrgrp;
          keyUsr.usrprf = usrprf1;
          setll %kds(keyUsr) usrgrp;
          reloadSfl = *on;
          leave;
        endif;

      when mode = kDsp;
        leave;

    endsl;
  enddo;

         // Reset indicators for next time
  indic.cancelKey = *off;

end-proc;

dcl-proc ValidateRecdtl1;

  validData = *on;
  indic.mandatoryUsr = *off;
  indic.mandatoryGrp = *off;

  if recdtl1DS.usrprf = *blanks;
    indic.mandatoryUsr = *on;
    validData = *off;
    recdtl1Ds.usrdesc = 'User profile';
  endif;

  if recdtl1DS.grpprf = *blanks;
    indic.mandatoryGrp = *on;
    validData = *off;
    recdtl1Ds.grpdesc = 'User group';
  endif;

end-proc;


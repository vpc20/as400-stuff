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

       // Key definitions
       dcl-ds keyUsr      likerec(usrgrp.usrgrp : *key);

       // Constants and Variables
       dcl-c maxSflSize   13; // Matches SFLPAG
       dcl-s rrn          zoned(4:0);
       dcl-s usrprf1      char(10);
       dcl-s reloadSfl    ind;

       // Indicator Data Structure
       dcl-ds indic qualified;
         exitKey    ind pos(3);
         addKey     ind pos(6);
         cancelKey  ind pos(12);
         sflMore    ind pos(70);
         sflDsp     ind pos(80);
         sflClr     ind pos(81);
         pageDown   ind pos(90);
         pageUp     ind pos(91);
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
               HandleDetail('ADD': *blanks);
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
             when sflrec1Ds.opt = '2'; // Edit
               HandleDetail('CHG': sflrec1Ds.usrprf);
             when sflrec1Ds.opt = '4'; // Delete
               HandleDetail('DLT': sflrec1Ds.usrprf);
             when sflrec1Ds.opt = '5'; // Display
               HandleDetail('DSP': sflrec1Ds.usrprf);
           endsl;

           // Reset option and update subfile record
           if sflrec1Ds.opt = '4';  // Delete
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
           mode char(3) const; // 'ADD', 'CHG', 'DLT', 'DSP'
           pUsr char(10) const;
         end-pi;

         dcl-ds dtlDs likerec(wrkusrgrpd.recdtl1 : *all);
         dcl-s confirmed ind inz(*off);

         // 1. Prepare Data
         if mode = 'ADD';
           clear dtlDs;
         else;
           keyUsr.usrprf = pUsr;
           chain %kds(keyUsr) usrgrp usrgrpDs;
           eval-corr dtlDs = usrgrpDs;
         endif;

         // 2. Display Loop
         dow not indic.cancelKey;

           exfmt wrkusrgrpd.recdtl1 dtlDs;

           if indic.cancelKey;
             leave;
           endif;

           // 3. Confirmation Logic
           // We "Display" the data, then wait for another Enter to confirm
           // This acts as the "Press Enter to Confirm" step.

           select;
             when mode = 'ADD';
               usrgrpDs.usrprf = dtlDs.usrprf; // Ensure key is set
               usrgrpDs.grpprf = dtlDs.grpprf;
               write usrgrp.usrgrp usrgrpDs;
               keyUsr.usrprf = usrgrpDs.usrprf;
               setll %kds(keyUsr) usrgrp;
               sflctl1Ds.rcdnbr = 1;
               reloadSfl = *on;
               leave;

             when mode = 'CHG';
               // Re-chain for update lock
               chain %kds(keyUsr) usrgrp usrgrpDs;
               if %found;
                 usrgrpDs.grpprf = dtlDs.grpprf;
                 update usrgrp.usrgrp usrgrpDs;
                 keyUsr.usrprf = usrprf1;
                 setll %kds(keyUsr) usrgrp;
                 reloadSfl = *on;
                 leave;
               endif;

             when mode = 'DLT';
               // Confirmation for Delete
               chain %kds(keyUsr) usrgrp usrgrpDs;
               if %found;
                 delete usrgrp.usrgrp;
                 keyUsr.usrprf = usrprf1;
                 setll %kds(keyUsr) usrgrp;
                 reloadSfl = *on;
                 leave;
               endif;

             when mode = 'DSP';
                 leave;

           endsl;
         enddo;

         // Reset indicators for next time
         indic.cancelKey = *off;

       end-proc;

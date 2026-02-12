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
      //  dcl-s lastKey      char(10);

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
               HandleDetail('ADD': *blanks);
               LoadSubfile(); // Refresh after add

             when indic.pageDown;
               if indic.sflMore;
                 LoadSubfile();
               endif;

             when indic.pageUp;
               SubfilePageUp();

             other;
               ProcessSubfile();
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
           sflrec1Ds.opt = *blanks;
           update wrkusrgrpd.sflrec1 sflrec1Ds;
           readc wrkusrgrpd.sflrec1 sflrec1Ds;
         enddo;

         LoadSubfile(); // Reload to show changes

       end-proc;

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
           // In ADD mode, USRPRF is output in your DDS,
           // but normally it should be input.
           // We'll assume the user fills GRPPRF.
         else;
           keyUsr.usrprf = pUsr;
           chain %kds(keyUsr) usrgrp usrgrpDs;
           eval-corr dtlDs = usrgrpDs;
         endif;

         // 2. Display Loop
         dow not indic.exitKey and not indic.cancelKey;

           exfmt wrkusrgrpd.recdtl1 dtlDs;

           if indic.exitKey or indic.cancelKey;
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
               leave;

             when mode = 'CHG';
               // Re-chain for update lock
               chain %kds(keyUsr) usrgrp usrgrpDs;
               if %found;
                 usrgrpDs.grpprf = dtlDs.grpprf;
                 update usrgrp.usrgrp usrgrpDs;
                 chain 1 wrkusrgrpd.sflrec1 sflrec1Ds;
                 keyUsr.usrprf = sflrec1Ds.usrprf;
                 setll %kds(keyUsr) usrgrp;
               endif;
               leave;

             when mode = 'DLT';
               // Confirmation for Delete
               chain %kds(keyUsr) usrgrp usrgrpDs;
               if %found;
                 delete usrgrp.usrgrp;
                 chain 1 wrkusrgrpd.sflrec1 sflrec1Ds;
                 keyUsr.usrprf = sflrec1Ds.usrprf;
                 setll %kds(keyUsr) usrgrp;
               endif;
               leave;

             when mode = 'DSP';
               leave;
           endsl;
         enddo;

         // Reset indicators for next time
         indic.exitKey = *off;
         indic.cancelKey = *off;
       end-proc;

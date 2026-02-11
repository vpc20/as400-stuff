**free
       ctl-opt main(Main) dftactgrp(*no) alwnull(*usrctl);

       // Database file (USRGRP table)
       dcl-f usrgrp keyed usage(*update:*delete:*output) qualified;

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
         sflMore    ind pos(70);
         sflDsp     ind pos(80);
         sflClr     ind pos(81);
         pageDown   ind pos(90);
         pageUp     ind pos(91);
       end-ds;

       //-----------------------------------------------------------------------
       dcl-proc Main;
         open wrkusrgrpd;

         // Initial Load
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

         close wrkusrgrpd;
         *inlr = *on;
       end-proc;

       //-----------------------------------------------------------------------
       dcl-proc LoadSubfile;
         // 1. Clear Subfile
         indic.sflClr = *on;
         write wrkusrgrpd.sflctl1 sflctl1Ds;
         indic.sflClr = *off;

         // 2. Fill Subfile
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
         else;
           setll *loval usrgrp;
         endif;

         LoadSubfile();
       end-proc;

       //-----------------------------------------------------------------------
       dcl-proc ProcessSubfile;
         readc wrkusrgrpd.sflrec1 sflrec1Ds;
         dow not %eof(wrkusrgrpd);

           select;
             when sflrec1Ds.opt = '2'; // Edit
               // Placeholder for Detail Logic
             when sflrec1Ds.opt = '4'; // Delete
               // Placeholder for Delete Logic
             when sflrec1Ds.opt = '5'; // Display
               // Placeholder for Display Logic
           endsl;

           // Reset option and update subfile record
           sflrec1Ds.opt = *blanks;
           update wrkusrgrpd.sflrec1 sflrec1Ds;

           readc wrkusrgrpd.sflrec1 sflrec1Ds;
         enddo;
       end-proc;

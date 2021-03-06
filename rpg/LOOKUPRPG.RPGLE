**free
       dcl-pi *N;
          lookupgrpParm char(10);
          lookupkeyParm char(10);
       end-pi;

       dcl-f lookuppf keyed;
       dcl-f lookupgrpf keyed;
       dcl-f lookupdsp workstn indds(dsp) sfile(sflrec1:recnum);

       dcl-ds keyLookup   likerec(lookuprec:*key);
       // dcl-ds keyLookupGr likerec(lookupgrec:*key);

       dcl-c maxSflSize 10;
       dcl-s recnum zoned(4:0);

       dcl-ds dsp qualified ;
         exitKey    ind pos(3);
         sflMore    ind pos(70);
         sflDsp     ind pos(80);
         sflClr     ind pos(81);
         pageDown   ind pos(90);
         pageUp     ind pos(91);
       end-ds ;

       chain (lookupgrpParm) lookupgrpf;
       if %found;
          hdrdesc   = lookupgrds;
          lookupgrd = lookupgrds;
       endif;

       keyLookup.lookupgrp = lookupgrpParm;
       keyLookup.lookupkey = *blank;
       setll %kds(keyLookup) lookuprec;
       exsr LoadSubfile;

       //-----------------------------------------------------------------------

       dow not dsp.exitKey;
          write wdwrec1;
          exfmt sflctl1;

          select;
             when poskey <> *blanks;
                keyLookup.lookupgrp = lookupgrpParm;
                keyLookup.lookupkey = poskey ;
                setll %kds(keyLookup) lookuprec;
                exsr LoadSubfile;

             when dsp.pageDown;
                if dsp.sflMore;
                   exsr LoadSubfile;
                endif;

             when dsp.pageUp;
                exsr SubfilePageUp;

             other;
                exsr ProcessSubfile;
          endsl;
       enddo;

       *inlr = *on;

       //-----------------------------------------------------------------------

       begsr LoadSubfile;
          write wdwrec1;
          // clear subfile
          dsp.sflClr = *on;
          write sflctl1;
          dsp.sflClr = *off;

          // fill subfile
          dsp.sflDsp = *off;

          for recnum = 1 to maxSflSize;
             reade %kds(keyLookup:1) lookuprec;
             if not %eof(lookuppf);
                opt = *zeros;
                write sflrec1;
             else;
                leave;
             endif;
          endfor;

          if recnum > 0;
             dsp.sflDsp = *on;
          endif;


          // display More or Bottom
          read lookuprec;
          if %eof(lookuppf);
             dsp.sflMore = *off;
          else;
             dsp.sflMore = *on;
             readp lookuprec;
          endif;

       endsr;

       //-----------------------------------------------------------------------

       begsr SubfilePageUp;

          chain 1 sflrec1;
          if %found;
             keyLookup.lookupgrp = lookupgrpParm;
             keyLookup.lookupkey = lookupkey;
             chain %kds(keyLookup) lookuprec;
          else;
             leavesr;
          endif;

          for recnum = 1 to maxSflSize + 1;
             readpe %kds(keyLookup:1) lookuprec;
             if %eof(lookuppf);
                keyLookup.lookupgrp = lookupgrpParm;
                keyLookup.lookupkey = *blank;
                setll %kds(keyLookup) lookuprec;
                leave;
             endif;
          endfor;

          exsr LoadSubfile;
       endsr;

       //-----------------------------------------------------------------------

       begsr ProcessSubfile;
          readc sflrec1;

          dow not %eof(lookupdsp);
             lookupkeyParm = lookupkey;
             return;
             readc sflrec1;
          enddo;
       endsr;

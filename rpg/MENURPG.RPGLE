**free
       ctl-opt main(Main) dftactgrp(*no) alwnull(*usrctl);

       dcl-f menupf keyed qualified;
       dcl-f menudspf workstn indds(indic) qualified sfile(sflrec:recnum);

       dcl-ds menupfDs  likerec(menupf.menupf: *all);
       dcl-ds sflrecDs  likerec(menudspf.sflrec: *all);
       dcl-ds sfctlDs   likerec(menudspf.sflctl: *all);
       dcl-ds fkeyrecDs likerec(menudspf.fkeyrec: *all);

       dcl-ds keyMenupf  likerec(menupf.menupf:*key);

       dcl-c maxSflSize  36;
       dcl-s recnum      zoned(4:0);

       dcl-ds indic qualified ;
         exitKey    ind pos(3);
         sflMore    ind pos(70);
         sflDsp     ind pos(80);
         sflClr     ind pos(81);
         pageDown   ind pos(90);
         pageUp     ind pos(91);
       end-ds ;


       //-----------------------------------------------------------------------

       dcl-proc Main;

          indic.exitKey = *off;

          keyMenupf.parentmenu = 'MAIN';
          keyMenupf.menuseq    = 0;
          setll %kds(keyMenupf) menupf;
          LoadSubfile();

          dow not indic.exitKey;
             write menudspf.fkeyrec fkeyrecDs;
             exfmt menudspf.sflctl  sfctlDs;

             select;
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

          *inlr = *on;
          return;

       end-proc;

       //-----------------------------------------------------------------------

       dcl-proc LoadSubfile;

       // write menudspf.fkeyrec fkeyrecDs;
          // clear subfile
          indic.sflClr = *on;
          write menudspf.sflctl sfctlDs;
          indic.sflClr = *off;

          // fill subfile
          indic.sflDsp = *off;
          recnum = 0;

          reade %kds(keyMenupf:1) menupf.menupf menupfDs;
          dow not %eof(menupf) and recnum <> maxSflSize;
             recnum += 1;
             eval-corr sflrecDs = menupfDs;
             sflrecDs.ctlfld = 0;
             write menudspf.sflrec sflrecDs;
             reade %kds(keyMenupf:1) menupf.menupf menupfDs;
          enddo;

          if recnum > 0;
             indic.sflDsp = *on;
          endif;


          // display More or Bottom
          if %eof(menupf);
             indic.sflMore = *off;
          else;
             indic.sflMore = *on;
             // readp because of the 1 extra read in the load subfile loop
             readp menupf.menupf menupfDs;
          endif;

       end-proc;

       //-----------------------------------------------------------------------

       dcl-proc SubfilePageUp;

          chain 1 menudspf.sflrec sflrecDs;
          if %found;
             chain %kds(keyMenupf) menupf.menupf menupfDs;
          else;
             return;
          endif;

          for recnum = 1 to maxSflSize + 1;
             readp menupf.menupf menupfDs;
             if %eof(menupf);
                keyMenupf.parentmenu = 'MAIN';
                keyMenupf.menuseq    = 0;
                setll %kds(keyMenupf) menupf;
                leave;
             endif;
          endfor;

          LoadSubfile();

       end-proc;

       //-----------------------------------------------------------------------

       dcl-proc ProcessSubfile;

          readc menudspf.sflrec sflrecDs;

          if sflrecDs.ctlfld = 1;
             dsply (sflrecDs.menuopt + ' ' + sflrecDs.menuopttyp);
             sflrecDs.ctlfld = 0;
             update menudspf.sflrec sflrecDs;
          endif;


       end-proc;

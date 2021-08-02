**free
       ctl-opt main(Main) dftactgrp(*no) alwnull(*usrctl);

       dcl-f procs keyed qualified;
       dcl-f procsdsp workstn usropn indds(indic) qualified sfile(sflrec1:recnum);

       dcl-ds procsrec likerec(procs.procs: *all);
       dcl-ds sfrec1  likerec(procsdsp.sflrec1: *all);
       dcl-ds sfctl1  likerec(procsdsp.sflctl1: *all);
       dcl-ds fkrec1  likerec(procsdsp.fkyrec1: *all);

       dcl-ds keyProcs   likerec(procs.procs:*key);

       dcl-c maxSflSize  16;
       dcl-s recnum      zoned(4:0);
       dcl-s prevSchema  char(10);

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

          dcl-pi *n;
             parmSchema char(10);
          end-pi;

          open procsdsp;
          indic.exitKey = *off;
          sfctl1.sflRcdNbr = 1;
          sfctl1.specschema = parmSchema;
          prevSchema = parmSchema;

          keyProcs.specschema = parmSchema;
          keyProcs.specname = *blanks;
          setll %kds(keyProcs) procs;
          LoadSubfile();

          dow not indic.exitKey;
             write procsdsp.fkyrec1 fkrec1;
             exfmt procsdsp.sflctl1 sfctl1;

             select;
                when (sfctl1.specSchema <> prevSchema
                     or sfctl1.posto <> *blanks);
                   keyProcs.specschema = sfctl1.specSchema;
                   keyProcs.specname = sfctl1.posto;
                   setll %kds(keyProcs) procs;
                   LoadSubfile();
                   prevSchema = sfctl1.specSchema;

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

          close procsdsp;
          *inlr = *on;

       end-proc;

       //-----------------------------------------------------------------------

       dcl-proc LoadSubfile;

          // clear subfile
          indic.sflClr = *on;
          write procsdsp.sflctl1 sfctl1;
          indic.sflClr = *off;

          // fill subfile
          indic.sflDsp = *off;
          recnum = 0;

          reade %kds(keyProcs:1) procs.procs procsrec;
          dow not %eof(procs) and recnum <> maxSflSize;
             recnum += 1;
             sfrec1.opt = *blanks;
             eval-corr sfrec1 = procsrec;
             write procsdsp.sflrec1 sfrec1;
             reade %kds(keyProcs:1) procs.procs procsrec;
          enddo;

          if recnum > 0;
             indic.sflDsp = *on;
          endif;

          // display More or Bottom
          if %eof(procs);
             indic.sflMore = *off;
          else;
             indic.sflMore = *on;
             readpe %kds(keyProcs:1) procs.procs procsrec;  // loop above has 1 extra read
            //  readp procs.procs procsrec;  // loop above has 1 extra read
          endif;

       end-proc;

       //-----------------------------------------------------------------------

       dcl-proc SubfilePageUp;

          chain 1 procsdsp.sflrec1 sfrec1;
          if %found;
             keyProcs.specschema = sfctl1.specschema;
             keyProcs.specname = sfrec1.specname;
             chain %kds(keyProcs) procs.procs procsrec;
          else;
             return;
          endif;

          for recnum = 1 to maxSflSize + 1;
             readpe %kds(keyProcs:1) procs.procs procsrec;  // loop above has 1 extra read
             if %eof(procs);
                keyProcs.specschema = sfctl1.specschema;
                keyProcs.specname = *blanks;
                setll %kds(keyProcs) procs;
                leave;
             endif;
          endfor;

          LoadSubfile();

       end-proc;

       //-----------------------------------------------------------------------

       dcl-proc ProcessSubfile;

          readc procsdsp.sflrec1 sfrec1;

          if not %eof(procsdsp);
             indic.exitKey = *on;
             return;
          endif;

       end-proc;

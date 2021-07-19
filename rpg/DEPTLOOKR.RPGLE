**free
       ctl-opt main(Main) dftactgrp(*no) alwnull(*usrctl);

       dcl-f department keyed qualified;
       dcl-f deptlookds workstn usropn indds(indic) qualified sfile(sflrec1:recnum);

       dcl-ds deptrec likerec(department.department: *all);
       dcl-ds sfrec1  likerec(deptlookds.sflrec1: *all);
       dcl-ds sfctl1  likerec(deptlookds.sflctl1: *all);
       dcl-ds wdrec1  likerec(deptlookds.wdwrec1: *all);

       dcl-c maxSflSize  10;
       dcl-s recnum      zoned(4:0);
       dcl-s selDeptno   char(3);

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
             parmDeptno char(3);
          end-pi;

          open deptlookds;
          indic.exitKey = *off;

          setll *start department;
          LoadSubfile();

          dow not indic.exitKey;
             write deptlookds.wdwrec1 wdrec1;
             exfmt deptlookds.sflctl1 sfctl1;

             select;
                when sfctl1.poskey <> *blanks;
                   setll sfctl1.poskey department.department;
                   LoadSubfile();

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

          close deptlookds;
          *inlr = *on;
          parmDeptno = selDeptno;
          return;

       end-proc;

       //-----------------------------------------------------------------------

       dcl-proc LoadSubfile;

          write deptlookds.wdwrec1 wdrec1;
          // clear subfile
          indic.sflClr = *on;
          write deptlookds.sflctl1 sfctl1;
          indic.sflClr = *off;

          // fill subfile
          indic.sflDsp = *off;
          recnum = 0;

          read department.department deptrec;
          dow not %eof(department) and recnum <> maxSflSize;
             recnum += 1;
             sfrec1.opt = *blanks;
             eval-corr sfrec1 = deptrec;
             write deptlookds.sflrec1 sfrec1;
             read department.department deptrec;
          enddo;

          if recnum > 0;
             indic.sflDsp = *on;
          endif;


          // display More or Bottom
          if %eof(department);
             indic.sflMore = *off;
          else;
             indic.sflMore = *on;
             readp department.department deptrec;
          endif;

       end-proc;

       //-----------------------------------------------------------------------

       dcl-proc SubfilePageUp;

          chain 1 deptlookds.sflrec1 sfrec1;
          if %found;
             chain sfrec1.deptno department.department deptrec;
          else;
             return;
          endif;

          for recnum = 1 to maxSflSize + 1;
             readp department.department deptrec;
             if %eof(department);
                setll *blanks department.department;
                leave;
             endif;
          endfor;

          LoadSubfile();

       end-proc;

       //-----------------------------------------------------------------------

       dcl-proc ProcessSubfile;

          readc deptlookds.sflrec1 sfrec1;

          if not %eof(deptlookds);
              selDeptno = sfrec1.deptno;
             indic.exitKey = *on;
             return;
          endif;

       end-proc;

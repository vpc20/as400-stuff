**free
       ctl-opt main(Main) dftactgrp(*no);

       dcl-f empl1 keyed qualified usage(*input : *output : *update : *delete);
       dcl-f employee keyed qualified usage(*input);
       dcl-f empdsp workstn indds(indic) qualified sfile(sflrec1:recnum);

       dcl-ds emprec  likerec(empl1.employee: *all);
       dcl-ds emplrec likerec(employee.employee: *all);
       dcl-ds sfrec1  likerec(empdsp.sflrec1: *all);
       dcl-ds sfctl1  likerec(empdsp.sflctl1: *all);
       dcl-ds fkrec1  likerec(empdsp.fkyrec1: *all);
       dcl-ds dsrec1  likerec(empdsp.dsprec1: *all);

       dcl-ds kempl1  likerec(empl1.employee:*key);

       dcl-c maxSflSize 14;

       dcl-s recnum      zoned(4:0);
       dcl-s maintMode   char(1);
       dcl-s validEntry  ind;

       dcl-ds indic qualified ;
         exitKey            ind pos(3);
         listKey            ind pos(4);
         addKey             ind pos(6);
         printKey           ind pos(21);
         deleteKey          ind pos(23);
         empnoRequired      ind pos(31);
         firstnmeRequired   ind pos(32);
         lastnameRequired   ind pos(33);
         duplicateEmpno     ind pos(35);
         invalidHiredate    ind pos(36);
         protEmpno          ind pos(61);
         protNonKey         ind pos(62);
         sflMore            ind pos(70);
         sflDsp             ind pos(80);
         sflClr             ind pos(81);
         pageDown           ind pos(90);
         pageUp             ind pos(91);
         addMsg             ind pos(92);
         updMsg             ind pos(93);
         delMsg             ind pos(94);
         dspFkey95          ind pos(95);
         dspFkey96          ind pos(96);
       end-ds ;

       //***********************************************************************

       dcl-proc Main;

          indic.exitKey = *off;

          sfctl1.sflRcdNbr = 1;
          setll *start empl1;
          LoadSubfile();

          // loop until exit key is pressed
          dow not indic.exitKey;
             write empdsp.fkyrec1 fkrec1;
             exfmt empdsp.sflctl1 sfctl1;
             indic.addMsg = *off;
             indic.updMsg = *off;
             indic.delMsg = *off;

             select;
                when sfctl1.posto <> *blanks;
                   kempl1.lastname = sfctl1.posto;
                   kempl1.firstnme = *blanks;
                   kempl1.midinit  = *blanks;
                   setll %kds(kempl1) empl1.employee;
                   if not %found(empl1);
                      setll *end empl1;
                      readp(n) empl1.employee emprec;
                   endif;
                   LoadSubfile();

                when indic.addKey;
                      maintMode = 'A';
                      clear dsrec1;
                      dsrec1.maintDesc = 'New Record';
                      indic.protEmpno = *off;
                      indic.protNonKey = *off;
                      indic.dspFkey95 = *on;
                      indic.dspFkey96 = *on;
                      EmpDtlScreen();

                when indic.pageDown;
                   if indic.sflMore;
                      LoadSubfile();
                   endif;

                when indic.pageUp;
                   if indic.sflDsp = *on;
                      SubfilePageUp();
                   endif;

                other;
                   ProcessSubfile();
             endsl;
          enddo;

          *inlr = *on;
          return;

       end-proc;

       //**********************************************************************

       dcl-proc LoadSubfile;

          // clear subfile
          indic.sflClr = *on;
          write empdsp.sflctl1 sfctl1;
          indic.sflClr = *off;

          // fill subfile
          indic.sflDsp = *off;
          recnum = 0;

          read(n) empl1.employee emprec;
          dow not %eof(empl1) and recnum <> maxSflSize;
             recnum += 1;
             sfrec1.opt = *zeros;
             eval-corr sfrec1 = emprec;
             write empdsp.sflrec1 sfrec1;
             read(n) empl1.employee emprec;
          enddo;

          if recnum > 0;
             indic.sflDsp = *on;
          else;
             sfctl1.sflRcdNbr = 0;
             indic.sflMore = *off;
             return;
          endif;

          // display More or Bottom
          if %eof(empl1);
             indic.sflMore = *off;
          else;
             indic.sflMore = *on;
             readp(n) empl1.employee emprec;
          endif;

        end-proc;

       //**********************************************************************

       dcl-proc SubfilePageup;

          chain 1 empdsp.sflrec1 sfrec1;
          eval-corr kempl1 = sfrec1;
          chain(n) %kds(kempl1) empl1.employee emprec;

          for recnum = 1 to maxSflSize + 1;
             readp(n) empl1.employee emprec ;
             if %eof(empl1);
                setll *loval empl1.employee;
                leave;
             endif;
          endfor;

          LoadSubfile();

       end-proc;

       //**********************************************************************

       dcl-proc ProcessSubfile;
          recnum = 1;
          chain recnum empdsp.sflrec1 sfrec1;

          dow %found(empdsp);
             if sfrec1.opt <> *blanks;
                indic.protEmpno = *off;
                indic.protNonKey = *off;

                select;
                   when %trim(sfrec1.opt) = '2';
                      maintMode = 'U';
                      dsrec1.maintDesc = 'Update Record';
                      indic.protEmpno = *on;
                      indic.dspFkey95 = *on;
                      indic.dspFkey96 = *on;
                   when %trim(sfrec1.opt) = '4';
                      maintMode = 'D';
                      dsrec1.maintDesc = 'Delete Record';
                      indic.protEmpno = *on;
                      indic.protNonKey = *on;
                      indic.dspFkey95 = *off;
                      indic.dspFkey96 = *on;
                   when %trim(sfrec1.opt) = '5';
                      maintMode = 'I';
                      dsrec1.maintDesc = 'Inquire Record';
                      indic.protEmpno = *on;
                      indic.protNonKey = *on;
                      indic.dspFkey95 = *on;
                      indic.dspFkey96 = *off;
                      update empdsp.sflrec1 sfrec1;  // clear input field opt
                endsl;

                sfctl1.sflRcdNbr = recnum;
                eval-corr kempl1 = sfrec1;
                chain %kds(kempl1) empl1.employee emprec;
                eval-corr dsrec1 = emprec;
                dsrec1.hiredate = *zeros;
               //  dsrec1.hiredate = %dec(%char(emprec.hiredate:*usa/):8:0);
               //  dsrec1.hiredate = %dec(%scanrpl('/': '': %CHAR(emprec.hiredate:*usa)):8:0);
                dsrec1.hiredate = %dec(emprec.hiredate:*usa);
                EmpDtlScreen();
             endif;
             recnum += 1;
             chain recnum empdsp.sflrec1 sfrec1;
          enddo;

          if maintMode = 'U' or maintMode = 'D';
             chain 1 empdsp.sflrec1 sfrec1;
             eval-corr kempl1  = sfrec1;
             setll %kds(kempl1) empl1.employee;
             readp(n) empl1.employee emprec;
             if %eof(empl1);
                setll *start empl1;
             endif;
             LoadSubfile();
          endif;

       end-proc;

       //**********************************************************************

       dcl-proc EmpDtlScreen;

          dow not indic.exitKey;
             exfmt empdsp.dsprec1 dsrec1;

             select;
                when indic.listKey;
                   dsply dsrec1.csrfld;

                when maintMode = 'A';
                   if ValidEntries();
                      eval-corr emprec = dsrec1;
                      emprec.hiredate = %date(dsrec1.hiredate:*usa);
                      write empl1.employee emprec;
                      eval-corr kempl1 = emprec;
                      setll %kds(kempl1) empl1.employee;
                      sfctl1.sflRcdNbr = 1;
                      indic.addMsg = *on;
                      LoadSubfile();
                      leave;
                   endif;
                when maintMode = 'U';
                   if ValidEntries();
                      eval-corr emprec = dsrec1;
                      update empl1.employee emprec;
                      indic.updMsg = *on;
                      leave;
                   endif;
                when maintMode = 'D';
                   if indic.deleteKey;
                      delete empl1.employee;
                      eval-corr kempl1 = emprec;
                      setll %kds(kempl1) empl1.employee;
                      indic.delMsg = *on;
                      leave;
                   endif;
             endsl;
           enddo;

           indic.exitKey = *off;

       end-proc;

       //**********************************************************************

       dcl-proc ValidEntries;

          dcl-pi *n ind end-pi;

          validEntry = *on;
          indic.empnoRequired = *off;
          indic.firstnmeRequired = *off;
          indic.lastnameRequired = *off;
          indic.duplicateEmpno = *off;
          indic.invalidHiredate = *off;


          if dsrec1.empno = *blanks;
             indic.empnoRequired = *on;
             validEntry = *off;
          else;
             if maintMode = 'A';
                chain(n) (dsrec1.empno) employee.employee emplrec;
                if %found(employee);
                   indic.duplicateEmpno = *on;
                   validEntry = *off;
                endif;
             endif;
          endif;

          if dsrec1.firstnme = *blanks;
             indic.firstnmeRequired = *on;
             validEntry = *off;
          endif;

          if dsrec1.lastname = *blanks;
             indic.lastnameRequired = *on;
             validEntry = *off;
          endif;

          test(de) *usa dsrec1.hiredate;
          if %error;
             indic.invalidHiredate = *on;
             validEntry = *off;
          endif;

          return validEntry;

       end-proc;

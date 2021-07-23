**free

ctl-opt main(Main) dftactgrp(*no);

dcl-f datesdsp workstn usropn indds(indic) qualified;

dcl-ds dsrec1  likerec(datesdsp.dsprec1: *all);

dcl-ds indic qualified ;
  exitKey    ind pos(3);
end-ds ;

//-----------------------------------------------------------------------

dcl-proc Main;

   open datesdsp;
   indic.exitKey = *off;

   dsrec1.curdate = %date();
   dsrec1.curtime = %time();
   dsrec1.curts = %timestamp();

   dsrec1.dateiso = %date();

   dsrec1.ndays = 1;
   dsrec1.nmonths = 1;
   dsrec1.nyears = 1;

   dow not indic.exitKey;
      exfmt datesdsp.dsprec1 dsrec1;

      dsrec1.dateusa = %char(dsrec1.dateiso : *usa);
      dsrec1.dateeur = %char(dsrec1.dateiso : *eur);

      dsrec1.dateplusd = dsrec1.dateiso + %days(dsrec1.ndays);
      dsrec1.dateplusm = dsrec1.dateiso + %months(dsrec1.nmonths);
      dsrec1.dateplusy = dsrec1.dateiso + %years(dsrec1.nyears);

      dsrec1.durd = %diff(dsrec1.enddate : dsrec1.strdate : *days);
      dsrec1.durm = %diff(dsrec1.enddate : dsrec1.strdate : *months);
      dsrec1.dury = %diff(dsrec1.enddate : dsrec1.strdate : *years);

   enddo;

   close datesdsp;
   *inlr = *on;
   return;

end-proc;



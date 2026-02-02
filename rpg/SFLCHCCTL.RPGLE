**free
       ctl-opt dftactgrp(*no) actgrp(*caller);

       dcl-f SFLCHCDSP workstn usropn indds(indic) qualified sfile(sflrcd:sflkey);

       dcl-ds sfrec1  likerec(sflchcdsp.sflrcd: *all);
       dcl-ds sfctl1  likerec(sflchcdsp.sflctl: *all);

       dcl-s sflKey   zoned(4:0);
       dcl-s name     char(30);
       dcl-s i        int(10);

       dcl-ds indic qualified ;
         exitKey    ind pos(3);
       end-ds ;

       // Load subfile with sample data
       open SFLCHCDSP;
       sfrec1.ctlfld = 0;

       for i = 1 to 10;
         sflKey = i;
         sfrec1.name = %trim('Sample name ' + %char(i));
         write SFLCHCDSP.SFLRCD SFrec1;
       endfor;

       dow '1';
         exfmt SFLCHCDSP.SFLCTL SFCTL1;
         // If user selected PF3/Exit then leave
         if indic.exitkey;
           leave;
         endif;

      // dsply sfrec1.ctlfld;

      // Process subfile records where choice = '1'
      // read SFLCHCDSP.sflrcd SFrec1;
      // dow not %eof;
      //   if choice = '1';
      //     // placeholder: do something with selected record
      //     dsply ('Selected: ' + %char(sflKey) + ' ' + %trim(name));
      //   endif;
      //   read SFLCHCDSP.sflrcd SFLrcd;
      // enddo;

       for i = 1 to 10;
         sflKey = i;
         chain  sflkey SFLCHCDSP.SFLRCD SFrec1;
         if sfrec1.ctlfld = 1;
            dsply ('selected ' + %char(sflkey));
         endif;
       endfor;

      enddo;

       close SFLCHCDSP;
       *inlr = *on;
       return;

**free

ctl-opt dftactgrp(*no) actgrp(*caller);

dcl-f SFLCHCDSP workstn usropn indds(indic) qualified sfile(sflrcd:sflkey);

dcl-ds sfrec1  likerec(sflchcdsp.sflrcd: *all);
dcl-ds sfctl1  likerec(sflchcdsp.sflctl: *all);
dcl-ds fkeyds  likerec(sflchcdsp.fkey1: *all);

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
  write sflchcdsp.fkey1 fkeyds;
  exfmt SFLCHCDSP.SFLCTL SFCTL1;
  // If user selected PF3/Exit then leave
  if indic.exitkey;
    leave;
  endif;

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

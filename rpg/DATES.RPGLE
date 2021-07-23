**free

       dcl-s  createTimestamp   timestamp;
       dcl-s  diffDays          packed(15:0);

       createTimestamp = z'2021-07-20-09.15.20';
       diffDays = %diff(%date() : createTimestamp : *days);
       dsply diffDays;

       *inlr = *on;


**free

       DCL-S date date inz(D'2001-12-31');
       DCL-S date1 date;

       dsply ('Date to char(default format): ' + %char(date));

       dsply ('Date to char(*iso format)   : ' + %char(date:*iso));
       dsply ('Date to char(*usa format)   : ' + %char(date:*usa));
       dsply ('Date to char(*eur format)   : ' + %char(date:*eur));

       dsply ('Date to char(*ymd format)   : ' + %char(date:*ymd));
       dsply ('Date to char(*mdy format)   : ' + %char(date:*mdy));
       dsply ('Date to char(*dmy format)   : ' + %char(date:*dmy));

       date1 = *loval;
       dsply ('Date 4-digit year format *loval: ' + %char(date1));
       date1 = *hival;
       dsply ('Date 4-digit year format *hival: ' + %char(date1));

       dsply 'Date to numeric(*usa format)';
       dsply %dec(%scanrpl('/': '': %char(date:*usa)):8:0);
       dsply %dec(date:*usa);

       *inlr = *on;

       // Date to char(default format): 2001-12-31
       // Date to char(*iso format)   : 2001-12-31
       // Date to char(*usa format)   : 12/31/2001
       // Date to char(*eur format)   : 31.12.2001
       // Date to char(*ymd format)   : 01/12/31
       // Date to char(*mdy format)   : 12/31/01
       // Date to char(*dmy format)   : 31/12/01
       // Date 4-digit year format *loval: 0001-01-01
       // Date 4-digit year format *hival: 9999-12-31
       // Date to numeric(*usa format)
       // 12312001

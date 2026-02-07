     **free

       dcl-c MAX_ELEMS 100;
       dcl-c default_city_name 'London';

       // The zone portion of the low-order byte indicates the sign (positive or negative) of the 
       // decimal number. The standard signs are used: hexadecimal F for positive numbers and 
       // hexadecimal D for negative numbers. In zoned-decimal format, each digit in a decimal 
       // number includes a zone portion; however, only the low-order zone portion serves as the sign. 
       dcl-s salaryz zoned(7 : 2);
       dcl-s agez zoned(3);

       //  The maximum number of digits is 63 (32 bytes).
       dcl-s salaryp packed(5 : 2);
       dcl-s agep packed(3);

       dcl-s cust_name char(100);

       dcl-s num_elems1 int(3);  // -128 to 127
       dcl-s num_elems2 int(5);  // -32768 to 32767
       dcl-s num_elems3 int(10);  // -2147483648 to 2147483647
       dcl-s num_elems4 int(20);  // -9223372036854775808 to 9223372036854775807


       //    4-byte float (8 digits)
       // -3.4028235E+38 to -1.1754944E-38, 0.0E+0, +1.1754944E-38 to +3.4028235E+38
       dcl-s variance1 float(4);
       //  8-byte float (16 digits)
       //  -1.797693134862315E+308 to -2.225073858507201E-308, 0.0E+0, +2.225073858507201E-308 to +1.797693134862315E+308       
       dcl-s variance2 float(8);

       dcl-s found ind;
     
       dcl-s date_dft date;
       DCL-S date_mdy date(*MDY-);

       dcl-s time_dft time;
       dcl-s time_hms time(*HMS.);

       dcl-s ts0 timestamp(0); // YYYY-MM-DD-hh-mm-ss
       dcl-s ts1 timestamp(1); // YYYY-MM-DD-hh-mm-ss.f
       dcl-s ts6a timestamp; // YYYY-MM-DD-hh-mm-ss.ffffff
       dcl-s ts6b timestamp(6); // YYYY-MM-DD-hh-mm-ss.ffffff
       dcl-s ts12 timestamp(12); // YYYY-MM-DD-hh-mm-ss.ffffffffffff

       dcl-s salarybd bindec(5 : 2);
       dcl-s agebd bindec(3);

       dcl-s cust_nameg graph(100);

       dcl-s userspace pointer;
       dcl-s callback pointer(*proc);

       dcl-s uns3 uns(3);
       dcl-s uns5 uns(5);
       dcl-s uns10 uns(10);
       dcl-s uns20 uns(20);

       dcl-s cust_namevc varchar(50);
       dcl-s message1vc varchar(500 : 2);
       dcl-s message2vc varchar(500 : 4);

       dcl-s cust_namevg vargraph(50);
       dcl-s message1vg vargraph(500 : 2);
       dcl-s message2vg vargraph(500 : 4);

       dcl-s cust_nameucs2 ucs2(100);
       dcl-s cust_namevarucs2 varucs2(50);
       dcl-s messagevarucs2a varucs2(500 : 2);
       dcl-s messagevarucs2b varucs2(500 : 4);

       salaryz = 50000.25;
       dsply salaryz;

       *inlr = *on;

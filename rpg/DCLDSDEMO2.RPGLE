     **free
            dcl-ds info qualified;
               name char(10) inz('Sam');
               salary packed(9 : 2) inz(50000.25);
            end-ds;

            dcl-ds otherInfo likeds(info) inz(*likeds);

            dsply (%trim(info.name)
                 + ' has a salary of '
                 + %trim(%editw(info.salary:' ,   ,  0.  ')));

            otherInfo.name = 'Joe';
            otherInfo.salary += 10000;

            dsply (%trim(otherInfo.name)
                 + ' has a salary of '
                 + %trim(%editw(otherInfo.salary:' ,   ,  0.  ')));

            return;

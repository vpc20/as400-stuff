     **free
            ctl-opt dftactgrp(*no) actgrp(*new);

            dcl-s txt1 char(10);

            exec sql declare c cursor for
            select substr('hello world', 1, 5)
            from sysibm.sysdummy1;

            exec sql open c;

            exec sql fetch next from c into :txt1;
            dsply txt1;

            exec sql close c;
            *inlr = *on;
            return;


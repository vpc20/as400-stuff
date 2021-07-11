     **free
            ctl-opt dftactgrp(*no) actgrp(*new);

            dcl-s totDepSalary packed(15:2);
            dcl-s totBonusCount int(10);

            exec sql
               whenever sqlerror do exsr SqlErrorRtn;

            exec sql
               call return_dept_salary('C01', :totDepSalary, :totBonusCount);

            dsply totDepSalary;
            dsply totBonusCount;

            return;

          //----------------------------------------------------------------------------------------
            begsr SqlErrorRtn;

               dsply sqlcode;
               dsply sqlstate;

            endsr;

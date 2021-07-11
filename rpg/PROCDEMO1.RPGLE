     **free
            ctl-opt main(Main) dftactgrp(*no);

            dcl-proc Main;
               dsply Max(3:7);
               *inlr = *on;
            end-proc;

            dcl-proc Max;
               dcl-pi *n int(5);
                 iVal1 int(5) const;
                 iVal2 int(5) const;
               end-pi;

               if iVal1 > iVal2;
                 return iVal1;
               endif;
               return iVal2;
            end-proc;

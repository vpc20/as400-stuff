     **free
            ctl-opt dftactgrp(*no) actgrp(*new);

            dcl-pr system int(10) extproc('system');
               command pointer value options(*string);
            end-pr;

            if system('wrksplf output(*print)') = 0;
               dsply 'command successfully executed' ;
            else;
               dsply 'command execution failed';
            endif;

            *inlr = *on;
            return;


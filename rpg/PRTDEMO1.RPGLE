     **free
            dcl-c QPRINT_LEN 132;
            dcl-f qprint printer(QPRINT_LEN);
            dcl-ds qprint_ds len(QPRINT_LEN) end-ds;

            qprint_ds = 'Hello';
            write qprint qprint_ds;
            qprint_ds = 'world';
            write qprint qprint_ds;

            *inlr = *on;

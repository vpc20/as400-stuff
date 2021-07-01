     **free
            dcl-f objdpf keyed ;
            dcl-f lstobjp printer indds(indic) oflind(*in90);

            dcl-ds indic qualified ;
               eop   ind pos(90); // page overflow
            end-ds;

            write hdr1;
            read QLIDOBJD;

            dou (%eof);
               write dtl1;
               if indic.eop; // end of page
                  write hdr1;
                  indic.eop = *off;
               endif;
               read QLIDOBJD;
            enddo;

            *inlr = *on;


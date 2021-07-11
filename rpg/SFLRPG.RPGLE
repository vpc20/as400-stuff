**free
       dcl-f  cusmstl3 keyed;
       dcl-f cusmstdsp workstn indds(dsp) sfile(sflrec1:recnum);

       dcl-c maxSflSize 14;

       dcl-s recnum zoned(4:0);
       dcl-s lastname like(name);

       dcl-ds dsp qualified ;
         exitKey    ind pos(3);
         addKey     ind pos(6);
         sflMore    ind pos(70);
         sflDsp     ind pos(80);
         sflDspCtl  ind pos(81);
         pageDown   ind pos(90);
         pageUp     ind pos(91);
       end-ds ;

       // get last record
       setll (*hival) cusrec;
       readp cusrec;
       lastname = name;

       sflRcdNbr = 1;
       setll (*loval) cusrec;
       exsr LoadSubfile;

       // loop until exit key is pressed
       dow not dsp.exitKey;
          write fkey1;
          exfmt sflctl1;

          select;
             when poscust <> *blanks;
                setll (poscust) cusrec;
                exsr LoadSubfile;

             when dsp.pageDown;
                if dsp.sflMore;
                   exsr LoadSubfile;
                endif;

             when dsp.pageUp;
                exsr SubfilePageUp;
          endsl;
       enddo;

       *inlr = *on;

       //******************************************************************
       //   SUBROUTINE - LoadSubfile                                      *
       //   PURPOSE    - Fill subfile                                     *
       //******************************************************************
       begsr LoadSubfile;
          // clear subfile
          dsp.sflDspCtl = *off;
          write sflctl1;
          dsp.sflDspCtl = *on;

          // fill subfile
          dsp.sflDsp = *off;
          recnum = 0;
          dou recnum = maxSflSize or %eof(cusmstl3);
             read cusrec;
             if %eof(cusmstl3);
                leave;
             endif;

             recnum = recnum + 1;
             opt = *zeros;
             write sflrec1;
             dsp.sflDsp = *on;
          enddo;

          // display More or Bottom
          if name = lastname;
             dsp.sflMore = *off;
          else;
             dsp.sflMore = *on;
          endif;

       endsr;

       //******************************************************************
       //   SUBROUTINE - SubfilePageUp                                    *
       //   PURPOSE    - Fill subfile                                     *
       //******************************************************************
       begsr SubfilePageUp;

          chain 1 sflrec1;
          chain (name) cusrec;

          for recnum = 1 to maxSflSize + 1;
             readp cusrec;
             if %eof(cusmstl3);
                setll (*loval) cusrec;
                leave;
             endif;
          endfor;

          exsr LoadSubfile;
       endsr;

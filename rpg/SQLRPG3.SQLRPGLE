**free
       ctl-opt main(Main) dftactgrp(*no) actgrp(*new);

       dcl-s eof   ind;

       //**********************************************************************

       dcl-proc Main;
          dcl-pi *n;
             dirname   char(32);
             alldir    char(3);
             objType   char(32);
          end-pi;

          dcl-s stmt             varchar(1024);
          dcl-c qt               '''';
          dcl-s pathName         char(128);  // includes path

          exec sql whenever not found do SetEofInd();

          stmt = 'select path_name from table(qsys2.ifs_object_statistics(' +
                 qt + %trim(dirname) + qt + ', '  +
                 qt + %trim(alldir)  + qt + ', '  +
                 qt + %trim(objType) + qt + ')) ' +
                 'where days(current date) - days(create_timestamp) > 3 ' +
                 'and position(' + qt +  '/.' + qt + ', path_name) = 0';

          exec sql prepare s1 from :stmt;
          exec sql declare c1 cursor for s1;
          exec sql open c1;

          exec sql fetch next from c1 into :pathName;
          dou eof;
             exec sql fetch next from c1 into :pathName;
             dsply %subst(pathName:1:32);
          enddo;

          exec sql close c1;
          *inlr = *on;
          return;

       end-proc;

       //**********************************************************************

       dcl-proc SetEofInd;

          eof = *on;

       end-proc;

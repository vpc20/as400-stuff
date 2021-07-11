     **free
       dcl-f qrpglesrc qualified extmbr('HELLO');
       dcl-ds src LikeRec(qrpglesrc.qrpglesrc);

       read qrpglesrc.qrpglesrc src;
       dow not %eof;
          dsply %subst(src.srcdta:1:20);
          read qrpglesrc.qrpglesrc src;
       enddo;

       *inlr = *on;

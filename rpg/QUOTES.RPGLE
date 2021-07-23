**free

       dcl-s v1   varchar(52);
       dcl-c qt   '''';
       dcl-c dqt   '"';

       v1 = 'abc (' + qt + 'def' + qt +')';
       dsply v1 ;

       v1 = 'abc (' + dqt + 'def' + dqt +')';
       dsply v1 ;

       *inlr = *on;

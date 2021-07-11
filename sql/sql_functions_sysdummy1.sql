select current schema 
   from sysibm.sysdummy1;

select replace('ABCXYZ', 'ABC', '123')
   from sysibm.sysdummy1;

select replace('ABCXYZ', 'ABC', '')
   from sysibm.sysdummy1;

select repeat('abc', 2)
   from sysibm.sysdummy1;

select substr('abcdef', 2, 3)
   from sysibm.sysdummy1;

select left('abcdef', 3)
   from sysibm.sysdummy1;

select right('abcdef', 3)
   from sysibm.sysdummy1;

select trim(' abcdef   ')
   from sysibm.sysdummy1;

select trim('#' from '###abcdef###')
   from sysibm.sysdummy1;

-- ltrim and rtrim are also available

select upper('abcdef')
   from sysibm.sysdummy1;

select lower('ABCDEF')
   from sysibm.sysdummy1;

select lpad('abcdef', 15, ' ')
   from sysibm.sysdummy1;

select rpad('abcdef', 15, '#')
   from sysibm.sysdummy1;

select position('c', 'abcdef')
   from sysibm.sysdummy1;

select posstr('abcdef', 'c')
   from sysibm.sysdummy1;

select space(5)
   from sysibm.sysdummy1;

select truncate(873.726, 2),
       truncate(873.726, 1),
       truncate(873.726, 0),
       truncate(873.726, -1),
       truncate(873.726, -2),
       truncate(873.726, -3)
   from sysibm.sysdummy1; 

select ceiling(3.5),
       ceiling(3.1),
       ceiling(-3.1),
       ceiling(-3.5)
   from sysibm.sysdummy1;

select floor(3.5),
       floor(3.1),
       floor(-3.1),
       floor(-3.5)
   from sysibm.sysdummy1;

select coalesce(null,
      null,
      1,
      2, 3, null, 4)
   from sysibm.sysdummy1;

select insert('INSERTING', 4, 2, 'IS'),
       insert('INSERTING', 4, 0, 'IS'),
       insert('INSERTING', 4, 2, '')
   from sysibm.sysdummy1;   

select length('abcdef')
   from sysibm.sysdummy1;

-- similar to posstr with arguments inverted
select locate('c', 'abcdef')
   from sysibm.sysdummy1;


select * from qsys2.sysindexes i
join qsys2.syskeys k
on i.index_name = k.index_name
where table_schema = 'QSYS2';
      table_name = 'SYSROUTINES';

select * from qsys2.syskeys
where index_name = 'QASQRESL';

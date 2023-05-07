-- indexes
select *
   from qsys2.sysindexes i
   where table_schema = 'QSYS2'
         and table_name = 'SYSROUTINES';

-- key fields
select *
   from qsys2.syskeys
   where index_name = 'QASQRESL';

select index_name, column_name, ordinal_position, ordering
   from qsys2.syskeys
   where index_name = 'QASQRESL'
   order by ordinal_position;   


-- indexes and keys
select i.index_name, i.table_schema, i.table_name, k.ordinal_position, k.column_name, ordering
   from qsys2.sysindexes i
        join qsys2.syskeys k
           on i.table_schema = k.index_schema
              and i.index_name = k.index_name
   where i.table_schema = 'QSYS2'
         and i.table_name = 'SYSROUTINES'
   order by i.index_name, k.ordinal_position;


select i.index_name, i.table_schema, i.table_name, k.ordinal_position, k.column_name, k.ordering
   from qsys2.sysindexes i
        join qsys2.syskeys k
           on i.table_schema = k.index_schema
              and i.index_name = k.index_name
   where i.table_schema = 'VPCRZKH1'
         and i.table_name = 'EMPLOYEE'
   order by i.index_name, k.ordinal_position;
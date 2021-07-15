select i.index_name,
       i.table_schema,
       i.table_name,
       k.ordinal_position,
       k.column_name
   from qsys2.sysindexes i
        join qsys2.syskeys k
           on i.table_schema = k.index_schema
              and i.index_name = k.index_name
   where i.table_schema = 'VPCRZKH1'
         and i.table_name = 'EMPLOYEE'
   order by i.index_name,
            k.ordinal_position;
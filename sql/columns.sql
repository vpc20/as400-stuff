select table_schema, table_name, column_name, system_column_name, ordinal_position, data_type, length, numeric_scale,
       system_table_name, system_table_schema
   from qsys2.syscolumns2
   where table_schema = 'QSYS2'
   and table_name = 'SYSPROCS';

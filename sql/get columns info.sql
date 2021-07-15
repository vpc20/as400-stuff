select table_schema,
       table_name,
       column_name,
       ordinal_position,
       data_type,
       length,
       numeric_scale
   from qsys2.syscolumns2
   where sys_dname = 'VPCRZKH1'
         and sys_tname = 'EMPLOYEE'
   order by ordinal_position;       
   
select sys_dname,
       sys_tname,
       sys_cname,
       colno,
       coltype,
       length,
       scale
   from qsys2.syscolumns2
   where sys_dname = 'VPCRZKH1'
         and sys_tname = 'EMPLOYEE'
   order by colno;
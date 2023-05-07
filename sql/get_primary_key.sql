SELECT *
    FROM sysibm.sqlstatistics
    WHERE TABLE_SCHEM = 'VPCRZKH1'
          AND TABLE_NAME = 'PROCS'
          AND ORDINAL_POSITION IS NOT null
    ORDER BY ORDINAL_POSITION;


select table_cat, ordinal_position, column_name, asc_or_desc
   from sysibm.sqlstatistics
   where table_schem = 'VPCRZKH1'
         and table_name = 'PROCS'
         and ordinal_position is not null
   order by ordinal_position;


select table_cat, ordinal_position, column_name, asc_or_desc
   from sysibm.sqlstatistics
   where table_schem = 'VPCRZKH1'
         and table_name = 'MSGPF'
         and ordinal_position is not null
   order by ordinal_position;   
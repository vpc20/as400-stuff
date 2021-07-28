-- set current schema vpcrzkh1;

select * from qsys2.systables
   where system_table_schema = 'VPCRZKH1'
   and table_text = 'Output file for DSPFD TYPE(*MBR)';
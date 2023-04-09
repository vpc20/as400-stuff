set current schema vpcrzkh1;
set current path '"QSYS","QSYS2","SYSPROC","SYSIBMADM","VPCRZKH1"';

select *
   from qsys2.sysprocs
   where specific_schema = 'VPCRZKH1';

select distinct(external_language)
   from qsys2.sysprocs;

drop table vpcrzkh1.procs;

-- create table procs as
--          (select specific_schema, specific_name, routine_body, external_name,  parameter_style, external_language,
--                  sql_data_access, result_sets, in_parms, out_parms, inout_parms
--                from qsys2.sysprocs
--                where specific_schema = 'VPCRZKH1')
--          with data;
         
create table procs as
         (select specific_schema, specific_name, routine_body, external_name,  parameter_style, external_language,
                 sql_data_access, result_sets, in_parms, out_parms, inout_parms
               from qsys2.sysprocs
               where specific_schema in ('VPCRZKH1', 'QSYS2'))
         with data;         
         
select *  from procs;

select table_schema, table_name, column_name, system_column_name, ordinal_position, data_type, length, numeric_scale,
       system_table_name, system_table_schema
   from qsys2.syscolumns2
   where table_schema = 'VPCRZKH1'
   and table_name = 'PROCS';


ALTER TABLE vpcrzkh1.procs
   DROP primary key;

ALTER TABLE vpcrzkh1.procs
    ADD CONSTRAINT vpcrzkh1.procs_prikey 
    PRIMARY KEY (
    specific_schema,
    specific_name
    );
    
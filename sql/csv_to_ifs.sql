--
--  category:  SYSTOOLS
--  description:  Generate a spreadsheet, from a Db2 file
--  minvrm: v7r4m0
--
-- https://www.ibm.com/docs/en/i/7.5?topic=services-generate-spreadsheet-scalar-function
--
create table vpcrzkh1.seccfg as
      (select * from qsys2.security_info)
      with data;

VALUES SYSTOOLS.GENERATE_SPREADSHEET(
  PATH_NAME         => '/home/vpcrzkh/sec_info',
  LIBRARY_NAME      => 'VPCRZKH1', 
  FILE_NAME         => 'SECCFG',     
  SPREADSHEET_TYPE  => 'csv'    
);


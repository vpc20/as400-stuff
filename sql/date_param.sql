set current schema vpcrzkh1;

CREATE PROCEDURE vpcrzkh1.date_param (IN in_date DATE)
    LANGUAGE sql
    DYNAMIC RESULT SETS 1
BEGIN
  DECLARE c1 CURSOR FOR
    SELECT in_date
      FROM sysibm.sysdummy1;
  OPEN c1;
  RETURN;
END;

call vpcrzkh1.date_param('2024-12-31');

-- Data type mismatch
-- call vpcrzkh1.date_param('12/31/2024');
-- call vpcrzkh1.date_param('31.12.2024');

-- run from ACS Run SQL scripts to get interactive results

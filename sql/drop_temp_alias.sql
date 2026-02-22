SET current schema vpcrzkh1;

drop PROCEDURE vpcrzkh1.drop_temp_alias;

CREATE PROCEDURE vpcrzkh1.drop_temp_alias
   LANGUAGE SQL
   specific droptempal
   MODIFIES SQL DATA
--    set option dbgview = *source
BEGIN
   DECLARE sql_text VARCHAR(1000);
   DECLARE filename VARCHAR(128);
   DECLARE eof INT DEFAULT 0;

   DECLARE c1 CURSOR FOR sql1;
   DECLARE CONTINUE HANDLER FOR NOT FOUND
      SET eof = 1;


   -- Build dynamic SQL statement
   SET sql_text = 'SELECT table_name FROM qsys2.systables '
      || 'where table_owner = ''VPCRZKH'' '
      || 'and table_name like ''TEMP%'' '
      || 'and table_schema = ''ILEDITOR'' ';

   PREPARE sql1 FROM sql_text;
   OPEN c1;
   FETCH c1 INTO filename;
   WHILE eof = 0
      DO
         SET sql_text = 'DROP ALIAS ILEDITOR.' || filename;
         PREPARE sql2 FROM sql_text;
         EXECUTE sql2;
         -- call systools.lprintf(sql_text);
         FETCH c1 INTO filename;
      END WHILE;
END;

CALL vpcrzkh1.drop_temp_alias();

SELECT *
FROM qsys2.systables
where table_owner = 'VPCRZKH'
and table_name like 'TEMP%'
and table_schema = 'ILEDITOR';

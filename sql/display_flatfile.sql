set current schema vpcrzkh1;

__ display the packed_decimal from the flat file
SELECT SUBSTR(flatfld, 1, 4) AS itemcode, 
       SUBSTR(flatfld, 5, 3) AS rawpackedpos,
       INTERPRET(BINARY(SUBSTR(flatfld, 5, 3)) AS DECIMAL(5, 2)) as valpackedpos,
       SUBSTR(flatfld, 8, 3) AS rawpackedneg,
       INTERPRET(BINARY(SUBSTR(flatfld, 8, 3)) AS DECIMAL(5, 2)) as valpackedneg,
       SUBSTR(flatfld, 11, 5) AS rawzonedpos,
       INTERPRET(BINARY(SUBSTR(flatfld, 11, 5)) AS NUMERIC(5, 2)) as valzonedpos,
       SUBSTR(flatfld, 16, 5) AS rawzonedneg,
       INTERPRET(BINARY(SUBSTR(flatfld, 16, 5)) AS NUMERIC(5, 2)) as valzonedneg
  FROM flatfile;       

 
 SELECT SUBSTR(FLATFLD, 1, 4) AS ITEM_CODE,
INTERPRET(BINARY(SUBSTR(FLATFLD, 5, 3)) AS DECIMAL(5, 2)) AS VAL_PACKED_POS,
INTERPRET(BINARY(SUBSTR(FLATFLD, 8, 3)) AS DECIMAL(5, 2)) AS VAL_PACKED_NEG,
INTERPRET(BINARY(SUBSTR(FLATFLD, 11, 5)) AS NUMERIC(5, 2)) AS VAL_ZONED_POS,
INTERPRET(BINARY(SUBSTR(FLATFLD, 16, 5)) AS NUMERIC(5, 2)) AS VAL_ZONED_NEG
FROM FLATFILE;                                                                                   
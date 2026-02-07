set current schema vpcrzkh1;

-- display the packed-decimal from the flat file
SELECT SUBSTR(flatfld, 1, 4) AS itemcode, 
       SUBSTR(flatfld, 5, 3) AS rawpackedpos,
       INTERPRET(BINARY(SUBSTR(flatfld, 5, 3)) AS DECIMAL(5, 2)) valpackedpos,
       SUBSTR(flatfld, 8, 3) AS rawpackedneg,
       INTERPRET(BINARY(SUBSTR(flatfld, 8, 3)) AS DECIMAL(5, 2)) valpackedneg,
       SUBSTR(flatfld, 11, 5) AS rawzonedpos,
       INTERPRET(BINARY(SUBSTR(flatfld, 11, 5)) AS NUMERIC(5, 2)) valzonedpos,
       SUBSTR(flatfld, 16, 5) AS rawzonedneg,
       INTERPRET(BINARY(SUBSTR(flatfld, 16, 5)) AS NUMERIC(5, 2)) valzonedneg
  FROM flatfile;       

                                                                                      
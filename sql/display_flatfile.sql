set current schema vpcrzkh1;

-- display the packed-decimal from the flat file
SELECT                                                        
    INTERPRET(BINARY(SUBSTR(flatfld, 5, 3)) AS decimal(5,2))  
FROM flatfile ;       

                                                                                      
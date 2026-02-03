-- single quotes ---------------------------------------------------
-- Method 1: Using two single quotes ('')
SELECT 'Today is a beautiful' || ' day, isn''t it?' AS concat_string
  FROM sysibm.sysdummy1;
  
  
-- Method 2: Using the CHR(39) function
SELECT 'Today is a beautiful day, isn' || CHR(39) || 't it?' AS concat_string
  FROM sysibm.sysdummy1;


-- double quotes ---------------------------------------------------
SELECT 'He said "Hello"' FROM SYSIBM.SYSDUMMY1;
-- Result: He said "Hello"


SELECT 'My name is ' || CHR(34) || 'Frankenstein' || CHR(34)
  FROM sysibm.sysdummy1;
-- Result: Column"MY_NAME"

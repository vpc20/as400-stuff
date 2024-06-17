SET CURRENT schema vpcrzkh1;

SET PATH = "QSYS", "QSYS2", "SYSPROC", "SYSIBMADM", "VPCRZKH", "VPCRZKH1";

SELECT YEAR(CURRENT DATE - DATE('2021-07-03'))
  FROM sysibm.sysdummy1;

DROP FUNCTION age;

CREATE FUNCTION age (
      bday DATE
  )
  RETURNS INT
  LANGUAGE sql
  --
  BEGIN
    RETURN (YEAR(CURRENT DATE - bday));
  END;

SELECT age('1972-03-30')
  FROM sysibm.sysdummy1;
SET current schema vpcrzkh1;

SET PATH = "QSYS", "QSYS2", "SYSPROC", "SYSIBMADM", "VPCRZKH1";

--------------------------------------------------------------------------------
DROP FUNCTION projfunc;


-- This non-pipelined table function returns data based on a date. 
-- The RETURN statement must contain a query.
CREATE FUNCTION projfunc(indate DATE)
   RETURNS TABLE (
      projno   CHAR(6),
      actno    SMALLINT,
      acstaff  DECIMAL(5, 2),
      acstdate DATE,
      acendate DATE)
BEGIN
   RETURN SELECT *
             FROM projact
             WHERE acstdate <= indate;
END;

--------------------------------------------------------------------------------
DROP FUNCTION projfunc;

-- This pipelined table function returns data based on a date. In addition to the column values returned by
-- the query, it also returns an indication of whether the project has been carried over from a prior year.
CREATE FUNCTION projfunc(indate DATE)
   RETURNS TABLE (
      projno    CHAR(6),
      actno     SMALLINT,
      acstaff   DECIMAL(5, 2),
      acstdate  DATE,
      acendate  DATE,
      carryover CHAR(1))
BEGIN
   FOR c1 CURSOR FOR SELECT * FROM PROJACT
      WHERE ACSTDATE<=indate
      DO
         IF YEAR(acstdate) < YEAR(indate) THEN
            PIPE (projno, actno, acstaff, acstdate, acendate, 'Y');
         ELSE
            PIPE (projno, actno, acstaff, acstdate, acendate, 'N');
         END IF;
   END for;
   RETURN;
END;
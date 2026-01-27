--  Generate SQL 
--  Version:                   	V7R5M0 220415 
--  Generated on:              	26-01-27 09:56:33 
--  Relational Database:       	PUB400 
--  Standards Option:          	Db2 for i 
SET PATH "QSYS","QSYS2","SYSPROC","SYSIBMADM" ; 
  
CREATE PROCEDURE SYSTOOLS.LPRINTF ( 
	IN PRINT_STRING VARCHAR(30720) FOR SBCS DATA ) 
	LANGUAGE SQL 
	SPECIFIC SYSTOOLS.LPRINTF 
	NOT DETERMINISTIC 
	MODIFIES SQL DATA 
	CALLED ON NULL INPUT 
	SYSTEM_TIME SENSITIVE NO 
	SET OPTION  ALWBLK = *ALLREAD , 
	ALWCPYDTA = *OPTIMIZE , 
	COMMIT = *NONE , 
	DECRESULT = (31, 31, 00) , 
	DFTRDBCOL = QSYS2 , 
	DLYPRP = *NO , 
	DYNDFTCOL = *NO , 
	DYNUSRPRF = *USER , 
	SRTSEQ = *HEX , 
	USRPRF = *USER , 
	BINDOPT = 'BNDSRVPGM(QSYS/QP0ZCPA)'   
	BEGIN 
-- Additional setup steps are required before creating this procedure. 
--                                                        
-- Create a C source member that contains the code for LPRINTF. 
-- The procedure will embed this with the INCLUDE statement and 
-- bind to the appropriate service program using BINDOPT. 
--CL:CRTSRCPF FILE(QTEMP/QCSRC) RCDLEN(160) MBR(*NONE);   
--CL:ADDPFM FILE(QTEMP/QCSRC) MBR(LPRINTF);               
--INSERT INTO QTEMP.QCSRC(SRCSEQ,SRCDTA) VALUES           
-- (1,'{'),                                               
-- (2,'extern int Qp0zLprintf (char *format, ...);'),     
-- (3,'Qp0zLprintf("%.*s\n", LPRINTF.PRINT_STRING.LEN, LPRINTF.PRINT_STRING.DAT);'), 
-- (4,'}');                                               
IF PRINT_STRING IS NOT NULL THEN 
INCLUDE QTEMP / QCSRC ( LPRINTF ) ; 
END IF ; 
END  ; 
  
COMMENT ON SPECIFIC PROCEDURE SYSTOOLS.LPRINTF 
	IS 'DB2 FOR IBM i SUPPLIED OBJECT VERSION 07500120002' ; 
  
COMMENT ON PARAMETER SPECIFIC PROCEDURE SYSTOOLS.LPRINTF 
( PRINT_STRING IS 'string - Default: none' ) ; 
  
GRANT EXECUTE   
ON SPECIFIC PROCEDURE SYSTOOLS.LPRINTF 
TO PUBLIC ; 
  
GRANT ALTER , EXECUTE   
ON SPECIFIC PROCEDURE SYSTOOLS.LPRINTF 
TO QSYS WITH GRANT OPTION ; 
  

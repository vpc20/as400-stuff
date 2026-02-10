set current schema vpcrzkh1;

-- DROP TABLE vpcrzkh1.menupf;

CREATE TABLE vpcrzkh1.menupf (
      menucode CHAR(10) NOT NULL,
      menuseq NUMERIC(3) NOT NULL,
      menuopt CHAR(10) NOT NULL,
      menutext CHAR(30) NOT NULL,
      menuopttyp CHAR(5) NOT NULL,
      cmdtext CHAR(512) NOT NULL,
      PRIMARY KEY (menucode, menuseq)
    );

-- 1. Adding more items to the MAIN menu (including a Submenu link)
INSERT INTO vpcrzkh1.menupf
  VALUES ('MAIN', 1, 'CUSTPGM', 'Customer Maintenance', '*PGM', ' ');
INSERT INTO vpcrzkh1.menupf
  VALUES ('MAIN', 2, 'PRODPGM', 'Products Maintenance', '*PGM', ' ');
INSERT INTO vpcrzkh1.menupf
  VALUES ('MAIN', 3, 'REPORTS', 'Reporting Module', '*MENU', ' ');
INSERT INTO vpcrzkh1.menupf
  VALUES ('MAIN', 4, 'SETTPGM', 'Settings', '*PGM', ' ');
INSERT INTO vpcrzkh1.menupf
  VALUES ('MAIN', 5, 'UTILS', 'Utility Programs', '*MENU', ' ');
INSERT INTO vpcrzkh1.menupf
  VALUES ('MAIN', 6, 'SYSCMD', 'System Commands', '*MENU', ' ');
INSERT INTO vpcrzkh1.menupf
  VALUES ('MAIN', 7, 'SYSADMIN', 'System Administration', '*MENU', ' ');


-- 2. Defining the 'REPORTS' Submenu 
INSERT INTO vpcrzkh1.menupf VALUES ('REPORTS', 1, 'SALESRPT', 'Daily Sales Report', '*PGM', ' ');
INSERT INTO vpcrzkh1.menupf VALUES ('REPORTS', 2, 'INVTRPT', 'Inventory Levels', '*PGM', ' ');
INSERT INTO vpcrzkh1.menupf VALUES ('REPORTS', 3, 'TAXREPT', 'Tax Summary', '*PGM', ' ');

-- 3. Defining the 'SYSADMIN' Submenu 
INSERT INTO vpcrzkh1.menupf VALUES ('SYSADMIN', 1, 'USERMGT', 'User Management', '*PGM', ' ');
INSERT INTO vpcrzkh1.menupf VALUES ('SYSADMIN', 2, 'LOGSMNU', 'View System Logs', '*MENU', ' '); -- Nested Submenu

-- 4. Deeply Nested Menu: 'LOGSMNU' 
INSERT INTO vpcrzkh1.menupf VALUES ('LOGSMNU', 1, 'ERRLOG', 'Error Logs', '*PGM', ' ');
INSERT INTO vpcrzkh1.menupf VALUES ('LOGSMNU', 2, 'ACCLOG', 'Access Logs', '*PGM', ' ');


INSERT INTO vpcrzkh1.menupf VALUES ('UTILS', 1, 'WRKOBJREF', 'Work with Object References', '*PGM', 'WRKOBJREF');
INSERT INTO vpcrzkh1.menupf VALUES ('UTILS', 2, 'WRKPGMREF', 'Work with Program References', '*PGM', 'WRKPGMREF');

INSERT INTO vpcrzkh1.menupf VALUES ('SYSCMD', 1, 'WRKACTJOB', 'Work with Active Jobs', '*PGM', 'WRKACTJOB');
INSERT INTO vpcrzkh1.menupf VALUES ('SYSCMD', 2, 'WRKSPLF', 'Work with Spooled Files', '*PGM', 'WRKSPLF');


SELECT *
  FROM vpcrzkh1.menupf;

-- TRUNCATE vpcrzkh1.menupf;

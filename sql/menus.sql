set current schema vpcrzkh1;

-- DROP TABLE vpcrzkh1.appmenu;

CREATE TABLE vpcrzkh1.appmenu (
      parentmenu CHAR(10) NOT NULL,
      menuseq NUMERIC(3) NOT NULL,
      menuopt CHAR(10) NOT NULL,
      menutext CHAR(30) NOT NULL,
      menuopttyp CHAR(5) NOT NULL,
      PRIMARY KEY (parentmenu, menuseq)
    );

-- 1. Adding more items to the MAIN menu (including a Submenu link)
INSERT INTO vpcrzkh1.appmenu
  VALUES ('MAIN', 1, 'CUSTPGM', 'Customer Maintenance', '*PGM');
INSERT INTO vpcrzkh1.appmenu
  VALUES ('MAIN', 2, 'PRODPGM', 'Products Maintenance', '*PGM');
INSERT INTO vpcrzkh1.appmenu
  VALUES ('MAIN', 3, 'REPORTS', 'Reporting Module', '*MENU');
INSERT INTO vpcrzkh1.appmenu
  VALUES ('MAIN', 4, 'SETTPGM', 'Settings', '*PGM');
INSERT INTO vpcrzkh1.appmenu
  VALUES ('MAIN', 5, 'SYSADMIN', 'System Administration', '*MENU');

-- 2. Defining the 'REPORTS' Submenu (Points back to MAIN seq 4)
INSERT INTO vpcrzkh1.appmenu VALUES ('REPORTS', 1, 'SALESRPT', 'Daily Sales Report', '*PGM');
INSERT INTO vpcrzkh1.appmenu VALUES ('REPORTS', 2, 'INVTRPT', 'Inventory Levels', '*PGM');
INSERT INTO vpcrzkh1.appmenu VALUES ('REPORTS', 3, 'TAXREPT', 'Tax Summary', '*PGM');

-- 3. Defining the 'SYSADMIN' Submenu (Points back to MAIN seq 5)
INSERT INTO vpcrzkh1.appmenu VALUES ('SYSADMIN', 1, 'USERMGT', 'User Management', '*PGM');
INSERT INTO vpcrzkh1.appmenu VALUES ('SYSADMIN', 2, 'LOGSMNU', 'View System Logs', '*MENU'); -- Nested Submenu

-- 4. Deeply Nested Menu: 'LOGSMNU' (Points back to SYSADMIN seq 2)
INSERT INTO vpcrzkh1.appmenu VALUES ('LOGSMNU', 1, 'ERRLOG', 'Error Logs', '*PGM');
INSERT INTO vpcrzkh1.appmenu VALUES ('LOGSMNU', 2, 'ACCLOG', 'Access Logs', '*PGM');

SELECT *
  FROM vpcrzkh1.appmenu;

-- TRUNCATE vpcrzkh1.appmenu;

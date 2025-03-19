IF NOT EXISTS (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SALESTERMINAL' AND COLUMN_NAME = 'IsWSaleTerminal')
ALTER TABLE SALESTERMINAL ADD IsWSaleTerminal BIT

IF NOT EXISTS (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SALESTERMINAL' AND COLUMN_NAME = 'SmartQrTerminalID')
ALTER TABLE SALESTERMINAL ADD SmartQrTerminalID VARCHAR(25)

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SalesTerminal' AND COLUMN_NAME = 'allowNegativeStock')
ALTER TABLE SalesTerminal ADD  allowNegativeStock BIT DEFAULT 0 WITH VALUES

IF NOT EXISTS (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SALESTERMINAL' AND COLUMN_NAME = 'HBL_UserName')
ALTER TABLE SALESTERMINAL ADD HBL_UserName VARCHAR(50)

IF NOT EXISTS (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SALESTERMINAL' AND COLUMN_NAME = 'HBL_Password')
ALTER TABLE SALESTERMINAL ADD HBL_Password VARCHAR(50)
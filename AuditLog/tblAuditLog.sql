IF OBJECT_ID('tblAuditLog') IS NULL
CREATE TABLE tblAuditLog
(
	LogId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	LogTime DATETIME NOT NULL,
	TrnUser VARCHAR(50) NULL,
	TableName VARCHAR(100) NOT NULL,
	[Key] VARCHAR(200) NOT NULL,
	FieldName VARCHAR(100) NOT NULL,
	OldValue NVARCHAR(1000) NULL,
	NewValue NVARCHAR(1000) NULL,
	DbUser VARCHAR(100) NULL,
	AppName VARCHAR(500) NULL
)

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblAuditLog' AND COLUMN_NAME = 'DbUser')
ALTER TABLE tblAuditLog ADD DbUser VARCHAR(100) NULL

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblAuditLog' AND COLUMN_NAME = 'AppName')
ALTER TABLE tblAuditLog ADD AppName VARCHAR(500) NULL
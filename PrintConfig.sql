IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PrintConfig')
CREATE TABLE PrintConfig
(
	vname VARCHAR(100) NOT NULL,
	title VARCHAR(100) NOT NULL, 
	altTitle VARCHAR(100) NOT NULL,
	noOfCopy TINYINT NOT NULL,
	CONSTRAINT PK_PrintConfig PRIMARY KEY (vname)
)
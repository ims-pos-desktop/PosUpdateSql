IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'BarcodePrintVouchers')
BEGIN
	CREATE TABLE BarcodePrintVouchers
	(
		VoucherType VARCHAR(2) NOT NULL,
		VoucherName VARCHAR(50) NOT NULL,
		CONSTRAINT PK_BarcodePrintVouchers PRIMARY KEY (VoucherType)
	)

	INSERT INTO BarcodePrintVouchers VALUES
	('PI','Purchase Bill')
	,('GR','Goods Receipt Note')
	,('PO','Purchase Order')
	,('PD','Production Entry')
	,('OP','Opening Stock')
	,('TO','Branch Transfer Out')
	,('TR','Branch Transfer In')
END
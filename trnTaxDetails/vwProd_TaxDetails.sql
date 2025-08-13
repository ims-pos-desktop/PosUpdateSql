CREATE OR ALTER VIEW vwProd_TaxDetails WITH SCHEMABINDING
AS
SELECT VCHRNO, VoucherType, MCODE, SNO, taxName, taxAccount, taxableAmount, taxAmount, taxId, taxRate, isCompoundTax, taxOrder FROM dbo.trnProd_TaxDetails
UNION ALL
SELECT VCHRNO, VoucherType, MCODE, SNO, taxName, taxAccount, taxableAmount, taxAmount, taxId, taxRate, isCompoundTax, taxOrder FROM dbo.abbProd_TaxDetails
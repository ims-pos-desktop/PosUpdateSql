CREATE OR ALTER PROCEDURE [dbo].[RSP_PartyBalanceConfirmation]
--DECLARE 
	@DATE1 DATE,
	@DATE2 DATE,
	@DIV VARCHAR(3)='%',
	@CCENTER VARCHAR(50) = '%',
	@ACID VARCHAR(25) = 'PA%',
	@PHISCALID VARCHAR(25),
	@COMPANYID VARCHAR(25)
AS

--SELECT @DATE1 = '16 JUL 2023', @DATE2 = '16 JUL 2024', @PHISCALID = '80/81', @COMPANYID = '%', @ACID = 'PASFD38'

IF @ACID = '%' 
	SET @ACID = 'PA%'
	
set nocount ON

DECLARE @DIVISIONWISEVOUCHER AS TINYINT
SELECT @DIVISIONWISEVOUCHER = DIVISIONWISEVOUCHER FROM SETTING

IF OBJECT_ID('TEMPDB..#VLIST') IS NOT NULL DROP TABLE #VLIST
IF OBJECT_ID('TEMPDB..#RESULT1') IS NOT NULL DROP TABLE #RESULT1
IF OBJECT_ID('TEMPDB..#RESULT2') IS NOT NULL DROP TABLE #RESULT2
IF OBJECT_ID('TEMPDB..#RESULT3') IS NOT NULL DROP TABLE #RESULT3


SELECT D.PTYPE, D.ACNAME,D.VATNO, D.ADDRESS,A_ACID, SUM(CASE WHEN A.TRNDATE<@DATE1 OR A.VOUCHERTYPE IN ('AO','OB') THEN DRAMNT-CRAMNT ELSE 0 END) OPENINGBL,
SUM(IIF(A.VoucherType IN ('RV','PV','JV'), CRAMNT-DRAMNT, 0)) * IIF(ISNULL(D.PType, 'C') = 'C',1,-1) PAYMENT,
SUM(DRAMNT)-SUM(CRAMNT) CLOSINGBL INTO #RESULT1 FROM RMD_ACLIST D
LEFT JOIN
(
	SELECT A.VCHRNO, A.A_ACID, B.TRNDATE, A.VOUCHERTYPE, A.DRAMNT, A.CRAMNT FROM RMD_TRNTRAN A 
	JOIN RMD_TRNMAIN B ON A.VCHRNO = B.VCHRNO AND A.DIVISION = B.DIVISION 
	WHERE A.A_ACID LIKE @ACID AND ISNULL(A.COSTCENTER,'') LIKE @CCENTER AND A.PhiscalID = @PHISCALID
) A ON A.A_ACID = D.ACID 
WHERE D.ACID LIKE @ACID
GROUP BY A.A_ACID,D.ACNAME,D.VATNO,D.ADDRESS, D.PType

--SELECT * FROM #RESULT1


SELECT ISNULL(PARAC,TRNAC) TRNAC, SUM(IIF(VoucherType IN ('SI','TI','RE'), TAXABLE, 0) * IIF(VoucherType IN ('RE'), -1,1)) SALES_TAXABLE,
SUM(IIF(VoucherType IN ('PI', 'PR'), TAXABLE, 0) * IIF(VoucherType IN ('PR'), -1,1)) PURCHASE_TAXABLE,
SUM(IIF(VoucherType IN ('SI','TI','RE'), NONTAXABLE, 0) * IIF(VoucherType IN ('RE'), -1,1)) SALES_NONTAXABLE,
SUM(IIF(VoucherType IN ('PI', 'PR'), NONTAXABLE, 0) * IIF(VoucherType IN ('PR'), -1,1)) PURCHASE_NONTAXABLE,
SUM(IIF(VoucherType IN ('SI','TI','RE'), VATAMNT, 0) * IIF(VoucherType IN ('RE'), -1,1)) SALES_VAT,
SUM(IIF(VoucherType IN ('PI', 'PR'), VATAMNT, 0) * IIF(VoucherType IN ('PR'), -1,1)) PURCHASE_VAT,

SUM(IIF(VoucherType IN ('CN'), TAXABLE, 0)) SR_TAXABLE,
SUM(IIF(VoucherType IN ('DN'), TAXABLE, 0)) PR_TAXABLE,
SUM(IIF(VoucherType IN ('CN'), NONTAXABLE, 0)) SR_NONTAXABLE,
SUM(IIF(VoucherType IN ('DN'), NONTAXABLE, 0)) PR_NONTAXABLE,
SUM(IIF(VoucherType IN ('CN'), VATAMNT, 0)) SR_VAT,
SUM(IIF(VoucherType IN ('DN'), VATAMNT, 0)) PR_VAT
INTO #RESULT2 FROM RMD_TRNMAIN WHERE LEFT(VCHRNO,2) IN ('SI','TI','RE', 'PI', 'PR', 'CN','DN')
AND TRNDATE BETWEEN @DATE1 AND @DATE2 AND ISNULL(COSTCENTER,'') LIKE @CCENTER AND ISNULL(PARAC,TRNAC) LIKE @ACID 
GROUP BY ISNULL(PARAC,TRNAC)



SELECT A.ACNAME,A.VATNO,A.ADDRESS, A.PTYPE, A.OPENINGBL,
CONVERT(NUMERIC(18,2), B.SALES_TAXABLE) SALES_TAXABLE,CONVERT(NUMERIC(18,2), B.SALES_NONTAXABLE) SALES_NONTAXABLE,CONVERT(NUMERIC(18,2), B.SALES_VAT) SALES_VAT,
CONVERT(NUMERIC(18,2), B.SR_TAXABLE) SR_TAXABLE, CONVERT(NUMERIC(18,2), B.SR_NONTAXABLE) SR_NONTAXABLE, CONVERT(NUMERIC(18,2), B.SR_VAT) SR_VAT,
CONVERT(NUMERIC(18,2), B.PURCHASE_TAXABLE) PURCHASE_TAXABLE, CONVERT(NUMERIC(18,2), B.PURCHASE_NONTAXABLE) PURCHASE_NONTAXABLE, CONVERT(NUMERIC(18,2), B.PURCHASE_VAT) PURCHASE_VAT,
CONVERT(NUMERIC(18,2), B.PR_TAXABLE) PR_TAXABLE, CONVERT(NUMERIC(18,2), B.PR_NONTAXABLE) PR_NONTAXABLE, CONVERT(NUMERIC(18,2), B.PR_VAT) PR_VAT,
A.PAYMENT,	A.CLOSINGBL, A.A_aCID FROM #RESULT1 A 
LEFT JOIN #RESULT2 B ON A.A_ACID = B.TRNAC 
ORDER BY A.ACNAME


IF OBJECT_ID('TEMPDB..#RESULT1') IS NOT NULL DROP TABLE #RESULT1
IF OBJECT_ID('TEMPDB..#RESULT2') IS NOT NULL DROP TABLE #RESULT2
set nocount oFF
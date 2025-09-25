CREATE OR ALTER   procedure [dbo].[sp_PurchaseRegister]
--DECLARE 
@DATE1 DATETIME,
@DATE2 DATETIME,
@DIVISION VARCHAR(10)='%', 
@CHK_INCLUDEDEBITNOTE VARCHAR(2) = '',          --IncludeDebitNotes:DN:0
@CHK_ShowTradingPurchase BIT = 0,               --ShowTradingPurchase:1:1
@CHK_ShowNonTradingPurchase BIT = 0,               --ShowNonTradingPurchase:1:1
@FYID VARCHAR(10)='',
@CHK_OLDFORMAT TINYINT = 0                       --OldFomrat:1:0
AS
--set @DATE1='2024-9-20';set @DATE2='2024-09-20'; SET @FYID = '81/82'

drop table IF EXISTS #RMD_CAPTIALIZEPURCHASEPROD
SELECT VCHRNO,DIVISION,ACNAME INTO #RMD_CAPTIALIZEPURCHASEPROD 
FROM 
(
	SELECT ROW_NUMBER() OVER(Partition by VCHRNO ORDER BY VCHRNO) SN,VCHRNO,DIVISION,ACNAME FROM PURTRAN A 
	INNER JOIN RMD_ACLIST B ON A.A_ACID = B.ACID WHERE VoucherType = 'CP' AND DRAMNT > 0 AND A_ACID <> 'LB01003'
) A WHERE SN = 1

DROP TABLE IF EXISTS #RESULT
SELECT * INTO #RESULT FROM
(
	--Purchase Voucher
	SELECT TRNDATE [Date],RIGHT(BSDATE,4) + '.' + SUBSTRING(BSDATE,4,2) +'.'+LEFT(BSDATE,2) [Miti],A.VCHRNO,A.CHALANNO [Bill No], NULL PragyapanPatraNo,	
	CASE WHEN ISNULL(A.BILLTO,'') = '' THEN B.ACNAME ELSE A.BILLTO END [Supplier Name],
	CASE WHEN ISNULL(A.BILLTOTEL,'') = '' THEN B.VATNO ELSE A.BILLTOTEL END [Supplier PAN]
	,P.ITEMDESC ItemName, p.ALTQTY_IN Quantity, p.ALTUNIT Unit,
	P.TAXABLE + P.NONTAXABLE AS [Total Amount], 
	P.NONTAXABLE [Non Taxable Amount],
	CASE WHEN ISNULL(VMODE,1) <=1 THEN  P.TAXABLE else null end as[Purchase Amount] , 
	CASE WHEN ISNULL(VMODE,0)<=1 THEN  P.VAT ELSE NULL END AS [Tax Amount],
	NULL as[Import Purchase Amount] , 
	NULL AS [Tax Amount1],
	NULL as[Capitalized Purchase Amount] , 
	NULL AS [Tax Amount2],
	VNUM
	FROM RMD_TRNMAIN A JOIN RMD_TRNPROD P ON A.VCHRNO = P.VCHRNO
	LEFT JOIN RMD_ACLIST B ON ISNULL(NULLIF(A.PARAC,'') , A.TRNAC) = B.ACID 
	LEFT JOIN RMD_ACLIST C ON A.PARAC= C.ACID WHERE @CHK_ShowTradingPurchase = 1 AND A.VoucherType IN ('PI') and isnull(a.status,0) = 0
	and A.PhiscalID = @FYID  and A.DIVISION like @DIVISION and trndate between @DATE1 and @DATE2 AND ISNULL(VMODE,0)<=1

	--IMPORT
	UNION ALL
	SELECT TRNDATE, RIGHT(A.BSDATE,4) + '.' + SUBSTRING(A.BSDATE,4,2) +'.'+LEFT(A.BSDATE,2), A.VCHRNO, A.CHALANNO, X.PPNO,
	ISNULL(C.ACNAME,BILLTO) [Supplier Name],ISNULL(C.VATNO,BILLTOTEL) [Supplier PAN],
		X.ITEMNAME, X.QUANTITY, X.UNIT,
		X.TAXABLEVALUE + X.NTAXABLEVALUE [Total Amount],
		X.NTAXABLEVALUE NONTAXABLE,	
		NULL [Purchase Amount], 
		NULL [Tax Amount],		
		X.TAXABLEVALUE [Import Purchase Amount],X.VATVALUE [Tax Amount1],
		NULL [Capitalized Purchase Amount], 
		NULL [Capitalized Purchase Amount],
		VNUM
		FROM PURMAIN A LEFT JOIN RMD_ACLIST C ON ISNULL(NULLIF(A.PARAC , ''),A.TRNAC) = C.ACID 
		LEFT JOIN PURMAIN_IMPORTDETAIL X ON A.VCHRNO = X.VCHRNO AND A.DIVISION = X.DIVISION 
		WHERE  @CHK_ShowTradingPurchase = 1 AND ISNULL(VMODE,0) = 2
		AND (TRNDATE > = @DATE1 AND TRNDATE < = @DATE2) AND A.DIVISION LIKE @DIVISION	AND A.PhiscalID = @FYID

	--Capital Purchase Voucher
	UNION ALL
	SELECT TRNDATE, RIGHT(A.BSDATE,4) + '.' + SUBSTRING(A.BSDATE,4,2) +'.'+LEFT(A.BSDATE,2), A.VCHRNO, A.CHALANNO, NULL,
	ISNULL(C.ACNAME,BILLTO) [Supplier Name],ISNULL(C.VATNO,BILLTOTEL) [Supplier PAN],
		X.ACNAME ITEMNAME,NULL QTY, NULL UNIT,
		A.TAXABLE + A.NONTAXABLE [Total Amount],
		A.NONTAXABLE NONTAXABLE,	
		IIF(ISNULL(A.VMODE, 4) = 4, A.TAXABLE, 0) [Purchase Amount], 
		IIF(ISNULL(A.VMODE, 4) = 4, A.VATAMNT, 0) [Tax Amount],		
		0 [Import Purchase Amount],0 [Tax Amount1],
		IIF(A.VMODE = 3, A.TAXABLE, 0) [Capitalized Purchase Amount], 
		IIF(A.VMODE = 3, A.VATAMNT, 0) [Capitalized Purchase Amount],
		VNUM
		FROM RMD_TRNMAIN A LEFT JOIN RMD_ACLIST C ON ISNULL(NULLIF(A.PARAC , ''),A.TRNAC) = C.ACID 
		LEFT JOIN #RMD_CAPTIALIZEPURCHASEPROD X ON A.VCHRNO = X.VCHRNO AND A.DIVISION = X.DIVISION 
		WHERE @CHK_ShowNonTradingPurchase = 1 AND LEFT(A.VCHRNO,2) = 'CP'
		AND (TRNDATE > = @DATE1 AND TRNDATE < = @DATE2) AND A.DIVISION LIKE @DIVISION	AND A.PhiscalID = @FYID

	UNION ALL
	SELECT TRNDATE [Date],RIGHT(BSDATE,4) + '.' + SUBSTRING(BSDATE,4,2) +'.'+LEFT(BSDATE,2) [Miti],A.VCHRNO,A.CHALANNO [Bill No], NULL PragyapanPatraNo,	
	CASE WHEN ISNULL(A.BILLTO,'') = '' THEN B.ACNAME ELSE A.BILLTO END [Supplier Name],
	CASE WHEN ISNULL(A.BILLTOTEL,'') = '' THEN B.VATNO ELSE A.BILLTOTEL END [Supplier PAN]
	,P.ITEMDESC ItemName, p.ALTQTY_IN Quantity, p.ALTUNIT Unit,
	P.TAXABLE + P.NONTAXABLE [Total Amount], 
	P.NONTAXABLE [Non Taxable Amount],
	IIF(P.ITEMTYPE = '2', P.TAXABLE, NULL) as[Purchase Amount] , 
	IIF(P.ITEMTYPE = '2',P.VAT, NULL) [Tax Amount],
	NULL as[Import Purchase Amount] , 
	NULL AS [Tax Amount1],
	IIF(P.ITEMTYPE = '1', P.TAXABLE, NULL) AS [Capitalized Purchase Amount] , 
	IIF(P.ITEMTYPE = '1',P.VAT, NULL) AS [Tax Amount2],
	VNUM
	FROM RMD_TRNMAIN A JOIN TRNPROD_NONTRADING P ON A.VCHRNO = P.VCHRNO
	LEFT JOIN RMD_ACLIST B ON ISNULL(NULLIF(A.PARAC , '') , A.TRNAC) = B.ACID 
	LEFT JOIN RMD_ACLIST C ON A.PARAC= C.ACID where @CHK_ShowNonTradingPurchase = 1 AND A.VoucherType IN ('PI') and isnull(a.status,0) = 0
	and A.PhiscalID = @FYID  and A.DIVISION like @DIVISION and trndate between @DATE1 and @DATE2 AND ISNULL(VMODE,0)<=1
		
	--Debit Note
	UNION ALL
	SELECT TRNDATE [Date],RIGHT(BSDATE,4) + '.' + SUBSTRING(BSDATE,4,2) +'.'+LEFT(BSDATE,2) [Miti],A.VCHRNO,A.VCHRNO [Bill No],	NULL,
	CASE WHEN ISNULL(A.BILLTO,'') = '' THEN B.ACNAME ELSE A.BILLTO END [Supplier Name],
	CASE WHEN ISNULL(A.BILLTOTEL,'') = '' THEN B.VATNO ELSE A.BILLTOTEL END [Supplier PAN]
	,P.ITEMDESC ItemName, p.AltQty * -1 Quantity, P.ALTUNIT Unit,
	(P.TAXABLE + P.NONTAXABLE) * -1 AS [Total Amount], P.NONTAXABLE * -1 [Non Taxable Amount],
	CASE WHEN ISNULL(VMODE,1) <=1 THEN  P.TAXABLE * -1 else null end as[Purchase Amount] , 
	CASE WHEN ISNULL(VMODE,0)<=1 THEN  P.VAT * -1 ELSE NULL END AS [Tax Amount],
	CASE WHEN ISNULL(VMODE,1) =2 THEN  P.TAXABLE * -1 else null end as[Import Purchase Amount] ,
	CASE WHEN ISNULL(VMODE,1)=2 THEN  P.VAT * -1 ELSE NULL END AS [Tax Amount1],
	CASE WHEN ISNULL(VMODE,1) =3 THEN  P.TAXABLE * -1 else null end as[Capitalized Purchase Amount], 
	CASE WHEN ISNULL(VMODE,1)=3 THEN  P.VAT * -1 ELSE NULL END AS [Tax Amount2],
	VNUM
	FROM RMD_TRNMAIN A JOIN RMD_TRNPROD P ON A.VCHRNO = P.VCHRNO
	LEFT JOIN RMD_ACLIST B ON ISNULL(NULLIF(A.PARAC , '') , A.TRNAC) = B.ACID 
	LEFT JOIN RMD_ACLIST C ON A.PARAC= C.ACID where A.VoucherType IN (@CHK_INCLUDEDEBITNOTE) and isnull(a.status,0) = 0
	and A.PhiscalID = @FYID  and A.DIVISION like @DIVISION and trndate between @DATE1 and @DATE2
) A ORDER BY [Date],CAST(SUBSTRING(VNUM,3,LEN(VNUM)) AS NUMERIC)

IF @CHK_OLDFORMAT = 0
	SELECT * FROM #RESULT ORDER BY [DATE]
ELSE
	SELECT [Date], Miti, VCHRNO, [Bill No], PragyapanPatraNo, [Supplier Name], [Supplier PAN]
	, SUM([Total Amount]) [Total Amount]
	, SUM([Non Taxable Amount]) [Non Taxable Amount]
	, SUM([Purchase Amount]) [Purchase Amount] 
	, SUM([Tax Amount]) [Tax Amount]
	, SUM([Import Purchase Amount]) [Import Purchase Amount]
	, SUM([Tax Amount1]) [Tax Amount1]
	, SUM([Capitalized Purchase Amount]) [Capitalized Purchase Amount]
	, SUM([Tax Amount2]) [Tax Amount2],
	VNUM FROM #RESULT
	GROUP BY [Date], Miti, VCHRNO, [Bill No], PragyapanPatraNo, [Supplier Name], [Supplier PAN], VNUM
	
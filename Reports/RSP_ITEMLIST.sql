CREATE OR ALTER  PROCEDURE RSP_ITEMLIST
--DECLARE 
	@MENUCAT VARCHAR(100) ='%',
	@SUPPLIER_ACID VARCHAR(20)='%',
	@MGROUP VARCHAR(20) = '%',
	@PTYPE INT='100',
	@OPT_TREE tinyint = 0                                       --NonTree:0,Tree:1
AS
DECLARE @EnableServiceCharge TINYINT,
@EnablePanBill TINYINT,
@ItemWiseSchargeApply TINYINT,
@VATCONRATE DECIMAL(10,5),
@STAXRATE DECIMAL(10,5),
@Group VARCHAR(20) = 'MI',
@GroupName VARCHAR(500) = 'Product List'

SELECT @EnableServiceCharge = EnableServiceCharge, @EnablePanBill = EnablePanBill, @ItemWiseSchargeApply = ItemWiseSchargeApply, @VATCONRATE = VATCONRATE, @STAXRATE = 1.1 FROM SETTING

IF OBJECT_ID('TEMPDB..#RESULT') IS NOT NULL DROP TABLE #RESULT

SELECT IH.[Main Group], IH.[Main Category], IH.[Sub Category], IH.[Super Category], MI.MCODE, MI.[MENUCODE], MI.[DESCA], B.[BCODE], MI.[PATH], MI.[RATE_A], 
MI.[RATE_A] * MRP_FACTOR MRP, MI.[RATE_B], MI.[RATE_B] * MI.MRP_FACTOR W_MRP,  PRATE_A, MI.PRATE_A * MI.MRP_FACTOR [PRATE_INC_VAT], COALESCE(NULLIF(CRATE,0),NULLIF(PRATE_A,0),0) CRATE
, CASE WHEN MI.VAT = 1 THEN 'Yes' ELSE 'No' END VATABLE
, ISNULL(LabeledMRP, 0) LabeledMRP
, IIF(MI.IsReturnableItem = 1, 'Yes', 'No') IsReturnable, MI.SUPCODE INTO #RESULT FROM
(
	SELECT *,
	CASE WHEN (@EnablePanBill = 1 OR VAT = 0) AND (@EnableServiceCharge = 0 OR (@ItemWiseSchargeApply = 1 AND HASSERVICECHARGE = 0)) THEN  CONVERT(DECIMAL(20,2),1)
	WHEN (@EnablePanBill = 1 OR VAT = 0) AND @EnableServiceCharge = 1 AND (@ItemWiseSchargeApply = 0 OR HASSERVICECHARGE = 1) THEN CONVERT(DECIMAL(20,2), @STAXRATE)
	WHEN @EnablePanBill = 0 AND VAT = 1 AND (@EnableServiceCharge = 0 OR (@ItemWiseSchargeApply = 1 AND HASSERVICECHARGE = 0)) THEN CONVERT(DECIMAL(20,2), @VATCONRATE)
	ELSE CONVERT(DECIMAL(20,2), @STAXRATE * @VATCONRATE) END MRP_FACTOR
	FROM MenuItem
) MI 
JOIN vwItemHeirarchy IH ON MI.MCODE = IH.MCODE
	 LEFT JOIN BARCODE B ON MI.MCODE = B.MCODE AND ISNULL(MI.MENUCODE, '') <> ISNULL(B.BCODE, '')
	 WHERE ISNULL(MCAT,'') LIKE @MENUCAT AND ISNULL(MGROUP,'') LIKE @MGROUP AND ISNULL(MI.SUPCODE,'') LIKE @SUPPLIER_ACID
	 AND (@PTYPE=100  OR (@PTYPE <> 100 AND ISNULL(PTYPE,0) = @PTYPE))

IF @OPT_TREE = 0 
BEGIN
	SELECT A.*, (A.RATE_A - A.CRATE) MARGIN,
	IIF(A.CRATE = 0 OR (A.RATE_A - A.CRATE) < 0, 0,(A.RATE_A / A.CRATE)) [MARGIN(%)], B.ACCODE SuplierCode, B.ACNAME Supplier FROM #RESULT A LEFT JOIN RMD_ACLIST B ON A.SUPCODE = B.ACID 
END
ELSE 
BEGIN
	IF @MGROUP <> '%' SET @Group = @MGROUP
	IF @MGROUP <> '%'
	SELECT @GroupName=Desca FROM MENUITEM WHERE MCODE=@GROUP 
	IF OBJECT_ID('TEMPDB..#TREE') IS NOT NULL DROP TABLE #TREE
	SELECT A.ID, A.TYPE, A.DESCRIPTION, B.* , (B.RATE_A - B.CRATE) MARGIN,
	IIF(B.CRATE = 0 OR (B.RATE_A - B.CRATE) < 0, 0,(B.RATE_A / B.CRATE)) [MARGIN(%)], C.ACCODE SuplierCode, C.ACNAME Supplier INTO #TREE FROM TreeExpand_function (@Group ,@GroupName ,0) AS A
				LEFT JOIN #RESULT B ON A.MCODE = B.MCODE 
				LEFT JOIN RMD_ACLIST C ON B.SUPCODE = C.ACID
	SELECT * FROM #TREE ORDER BY ID
END

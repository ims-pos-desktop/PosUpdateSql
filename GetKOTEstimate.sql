
CREATE OR ALTER FUNCTION [dbo].[GetKotEstimate](@TABLENO VARCHAR(50))
RETURNS DECIMAL(18,2) AS
BEGIN
--DECLARE @TABLENO VARCHAR(50) = 'BAR 01'
DECLARE @TOTAL DECIMAL(18,2)
Declare @itmwisesericecharge tinyint, @ServiceChargeRate DECIMAL(5,2), @EnablePanBill tinyint
select @itmwisesericecharge = ItemWiseSchargeApply, @ServiceChargeRate = ServiceChargeRate, @EnablePanBill = COALESCE(EnablePanBill,0) from SETTING
SELECT @TOTAL = SUM(GROSS + STAX + VATAMNT) FROM
(
	SELECT *, CASE WHEN VAT = 1 AND @EnablePanBill = 0 THEN (GROSS + STAX)* 0.13 ELSE 0 END VATAMNT FROM
	(
		SELECT M.VAT, M.MCODE, M.MENUCODE, M.DESCA, P.Quantity, M.RATE_A* P.Quantity GROSS,
		IIF(@itmwisesericecharge = 0 OR M.HASSERVICECHARGE = 1, @ServiceChargeRate, 0) * M.RATE_A * P.Quantity STAX
		FROM RMD_KOTPROD P JOIN RMD_KOTMAIN_STATUS S ON P.KOTID = S.KOTID JOIN MENUITEM M ON P.MCODE = M.MCODE WHERE S.STATUS = 'ACTIVE' and S.TABLENO=@TABLENO
	) B
) A
--PRINT @TOTAL
RETURN @TOTAL
END

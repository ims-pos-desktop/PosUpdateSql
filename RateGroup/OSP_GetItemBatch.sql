CREATE OR ALTER PROC OSP_GetItemBatch    
--DECLARE    
@MCODE VARCHAR(50) ,    
@DIVISION VARCHAR(3),    
@WAREHOUSE VARCHAR(50),    
@PhiscalId VARCHAR(10),    
@BatchCode VARCHAR(50) = '%',    
@OnlyInStock TINYINT = 1,    
@RateGroupId INT,    
@RateGroupId_WSale INT = 0    
AS    
if @RateGroupId_WSale = 0    
 SET @RateGroupId_WSale = @RateGroupId    
--DECLARE @RateGroupId INT    
--SELECT @RateGroupId = RateGroupID FROM DIVISION WHERE INITIAL = @DIVISION    
    
SELECT B.STAMP, P.MCODE, B.BATCHCODE, B.MFGDATE, B.EXPDATE, COALESCE(C.RG_RATE, B.SELLRATEBEFORETAX) SELLRATEBEFORETAX, ISNULL(C.RG_MRP, B.MRP) MRP, LABELMRP, SUM(REALQTY_IN-REALQTY) STOCK,     
ISNULL(B.CostPrice,P.PRATE) PRATE, B.LandingCost, ISNULL(D.RG_MRP, B.W_MRP) W_MRP, COALESCE(D.RG_RATE, B.W_SELLRATEBEFORETAX) W_SELLRATEBEFORETAX,    
COALESCE(C.RG_DISCOUNT,0) RG_DISCOUNT,    
COALESCE(D.RG_DISCOUNT,0) RG_DISCOUNT_WSALE FROM RMD_TRNPROD P     
JOIN BATCHPRICE_MASTER B ON ISNULL(P.BATCH,'') = B.BATCHCODE AND P.MCODE = B.MCODE     
OUTER APPLY DBO.FNGETRATEGROUP(P.MCODE, B.SELLRATEBEFORETAX, @RateGroupId) C    
OUTER APPLY DBO.FNGETRATEGROUP(P.MCODE, B.W_SELLRATEBEFORETAX, @RateGroupId_WSale) D    
WHERE P.MCODE = @MCODE AND P.DIVISION = @division and P.WAREHOUSE = @warehouse AND P.PHISCALID = @PHISCALID AND B.BATCHCODE LIKE @BatchCode    
GROUP BY B.STAMP, P.MCODE, B.BATCHCODE, B.MFGDATE, B.EXPDATE, B.MRP,B.LABELMRP, B.SELLRATEBEFORETAX, ISNULL(B.CostPrice,P.PRATE), B.W_MRP, B.W_SELLRATEBEFORETAX, C.RG_RATE, C.RG_MRP, B.LandingCost, D.RG_RATE, D.RG_MRP, C.RG_DISCOUNT, D.RG_DISCOUNT    
HAVING @OnlyInStock = 0 OR SUM(REALQTY_IN - REALQTY) > 0    
ORDER BY B.EXPDATE
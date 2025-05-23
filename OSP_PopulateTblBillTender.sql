CREATE OR ALTER PROC OSP_PopulateTblBillTender
AS

EXEC OSP_UpdateBillTenderTable

IF OBJECT_ID('TEMPDB..#TRNMODE') is not null drop table #TRNMODE
IF OBJECT_ID('TEMPDB..#TRNMODE') is not null drop table #BILLTENDER
select distinct IIF(ISNULL(T.TRNMODE,'')='','Others',T.TRNMODE) trnmode into #TRNMODE from SALES_TRNMAIN M JOIN RMD_BILLTENDER T ON M.VCHRNO = T.VCHRNO 

SELECT M.VCHRNO, M.DIVISION, M.PhiscalId, M.COMPANYID, T.TRNMODE, SUM((T.AMOUNT - T.CHANGE) * IIF(M.VoucherType IN ('RE','CN'), -1, 1)) NETAMNT 
INTO #BILLTENDER
FROM SALES_TRNMAIN M 
JOIN RMD_BILLTENDER T ON M.VCHRNO = T.VCHRNO AND M.DIVISION = T.DIVISION AND M.PhiscalID = T.PHISCALID
LEFT JOIN tblBillTender BT ON M.VCHRNO = BT.VCHRNO AND M.DIVISION = BT.DIVISION AND M.PhiscalID = BT.PHISCALID
WHERE BT.VCHRNO IS NULL
GROUP BY M.VCHRNO, M.DIVISION, M.PhiscalId, M.COMPANYID, T.TRNMODE

DECLARE @TRNMODE_CURSOR CURSOR

--SELECT * FROM #TRNMODE
--select * from trnmain
DECLARE @cols AS NVARCHAR(MAX),
    @query  AS NVARCHAR(MAX);

SET @cols = STUFF((SELECT distinct ',' + QUOTENAME(TRNMODE) FROM #TRNMODE FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')

PRINT @cols

set @query = 'INSERT INTO tblBillTender(VCHRNO, DIVISION, PhiscalId, COMPANYID, ' + @cols + ') 
            SELECT VCHRNO, DIVISION, PhiscalId, COMPANYID, ' + @cols + ' from 
            (
                SELECT * FROM #BILLTENDER 
            ) x
            pivot 
            (
                 max(NETAMNT) for TRNMODE in (' + @cols + ')
            ) p'

execute(@query)
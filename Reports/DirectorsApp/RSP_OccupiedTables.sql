CREATE OR ALTER PROCEDURE [dbo].[RSP_OccupiedTables]
--DECLARE
@DIV varchar(25)='%'
as
set nocount on;
SELECT a.TABLENO table_no, a.PAX covers_occupied, b.current_orders_value_estimate, b.last_order
FROM
(
    select rkm.TABLENO  ,rkm.Pax
	from rmd_kotmain rkm inner join RMD_KOTMAIN_STATUS rks on rkm.KOTID=rks.KOTID  WHERE rks.STATUS = 'ACTIVE' and rkm.DIVISION like @DIV
)a LEFT JOIN
(	
	SELECT P.TableNo, CONVERT(DECIMAL(18,2),sum(M.RATE_A* P.Quantity)) current_orders_value_estimate, MAX(CONVERT(DATETIME,P.KOTTIME)) last_order
    FROM RMD_KOTPROD P JOIN RMD_KOTMAIN_STATUS S ON P.KOTID = S.KOTID JOIN MENUITEM M ON P.MCODE = M.MCODE WHERE S.STATUS = 'ACTIVE' and P.DIVISION like @DIV
	GROUP BY P.TABLENO
)b ON A.TABLENO = B.TABLENO
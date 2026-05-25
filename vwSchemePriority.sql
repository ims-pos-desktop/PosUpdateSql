CREATE OR ALTER VIEW vwSchemePriority
AS
SELECT SchemeType, SchemeId, SchemeOrder, CanStackOnManualDiscount, CanStackOnPrevScheme, CanStackNextScheme FROM SchemePriority
UNION
SELECT R.SchemeType, DisID, ISNULL(P.SchemeOrder,ISNULL(R.[PRIORITY],99)+9999), 0,0,0 FROM Discount_Rate R LEFT JOIN SchemePriority P ON R.DISID = P.SCHEMEID AND R.SchemeType = P.SchemeType
UNION 
SELECT 'MarginScheme' SchemeType, MSchemId, ISNULL(P.SchemeOrder,9999), 0,0,0 FROM MarginScheme R LEFT JOIN SchemePriority P ON R.MSchemId = P.SCHEMEID AND 'MarginScheme' = P.SchemeType

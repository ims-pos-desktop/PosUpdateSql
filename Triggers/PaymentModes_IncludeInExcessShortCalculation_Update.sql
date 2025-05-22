CREATE OR ALTER TRIGGER PaymentModes_IncludeInExcessShortCalculation_Update
ON PaymentModes  -- Replace with your actual table name
AFTER INSERT,UPDATE
AS
BEGIN
    SET NOCOUNT ON;

	WITH ChangedRows AS (
        SELECT 
            i.PAYMENTMODENAME,
            i.IncludeInExcessShortCalculation,
            d.IncludeInExcessShortCalculation AS OldIncludeInExcessShortCalculation
        FROM inserted i
        JOIN deleted d ON i.SNO = d.SNO
        WHERE i.IncludeInExcessShortCalculation <> d.IncludeInExcessShortCalculation
    )

    MERGE tblDenoMaster AS target
    USING ChangedRows AS source
    ON target.DENO_NAME = source.PAYMENTMODENAME

    WHEN MATCHED AND source.IncludeInExcessShortCalculation = 0 THEN
        DELETE

    WHEN NOT MATCHED BY TARGET AND source.IncludeInExcessShortCalculation = 1 THEN
        INSERT (DENO_ID,DENO_NAME, CURRENCY, CURRENCYCHAR, BASEVALUE)
        VALUES ((SELECT MAX(DENO_ID) FROM tblDenoMaster) + 1, SOURCE.PAYMENTMODENAME, 'NRs','Rs',1);
END;
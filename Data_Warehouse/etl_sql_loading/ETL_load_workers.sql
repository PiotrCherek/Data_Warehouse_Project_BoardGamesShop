USE warehouse
GO

IF OBJECT_ID('v_ETL_workers') IS NOT NULL
    DROP VIEW v_ETL_workers;
GO
CREATE VIEW v_ETL_workers
AS
SELECT DISTINCT
    CAST([Worker_Name] + ' ' + [Surname] AS NVARCHAR(100)) AS name_and_surname,
    [pesel] AS pesel
FROM Shop.dbo.Workers;
GO

MERGE INTO Worker AS W
USING v_ETL_workers AS v_ETL
    ON W.name_and_surname = v_ETL.name_and_surname 
	AND W.pesel = v_ETL.pesel
WHEN NOT MATCHED
  THEN
        INSERT (name_and_surname,pesel)
        VALUES (v_ETL.name_and_surname,v_ETL.pesel);
GO

SELECT * FROM Worker;

--DROP VIEW v_ETL_workers;
--GO
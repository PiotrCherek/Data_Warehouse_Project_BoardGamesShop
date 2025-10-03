USE warehouse;
GO

IF (object_id('dbo.AdditionalInfoTemp') is not null) DROP TABLE dbo.AdditionalInfoTemp;
CREATE TABLE dbo.AdditionalInfoTemp(
	tournament_id SMALLINT, 
	games_rents_during_tournament VARCHAR(100),
	meeting_time VARCHAR(100),
	bringing_children VARCHAR(100),
	snacks_and_drinks VARCHAR(100));
GO

BULK INSERT dbo.AdditionalInfoTemp
    FROM 'C:\Users\Piotrek\Documents\GitHub\Data_Warehouses\existing_tournaments_T2.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
    )

IF OBJECT_ID('v_ETL_tournament_organization') IS NOT NULL
    DROP VIEW v_ETL_tournament_organization;
GO
CREATE VIEW v_ETL_tournament_organization
AS
SELECT
    T.tournament_id,
    D.date_ID,
    T.Tournament_Date
FROM Shop.dbo.Tournaments AS T
JOIN dbo.Date AS D ON CAST(T.Tournament_Date AS DATE) = D.[date];
GO

SELECT * FROM Shop.dbo.Tournaments;
SELECT * FROM Date;

SELECT * FROM v_ETL_tournament_organization
ORDER BY Tournament_ID;
/*
SELECT CAST(T.Tournament_Date AS DATE) AS CleanedDate
FROM Shop.dbo.Tournaments AS T


SELECT DISTINCT
	D.date_ID AS id,
    CAST(T.Tournament_Date AS DATE) AS CleanedDate,
    D.date AS DateDimension,
    CASE 
        WHEN CAST(T.Tournament_Date AS DATE) = D.date THEN 'Match'
        ELSE 'No Match'
    END AS MatchStatus
FROM Shop.dbo.Tournaments T
LEFT JOIN dbo.Date D ON CAST(T.Tournament_Date AS DATE) = D.date;

SELECT * FROM Date;

*/
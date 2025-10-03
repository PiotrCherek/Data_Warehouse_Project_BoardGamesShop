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
    FROM 'C:\Users\Piotrek\Documents\GitHub\Data_Warehouses\existing_tournaments.csv'
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
SELECT DISTINCT
    tournament_id,
    worker_ID,
	board_game_ID,
	date_ID,
	information_ID,
	junk_ID
FROM 
	(SELECT
		tournament_ID = T.tournament_ID,
		worker_ID = W.worker_ID,
		board_game_ID = G.game_ID,
		date_ID = D.date_ID,
		information_ID = I.information_ID,
		junk_ID = J.junk_ID
	FROM Shop.dbo.Tournaments AS T
	JOIN dbo.Worker AS W ON T.Responsible_Worker = W.pesel
	JOIN Shop.dbo.OwnedBoardGames AS GS ON GS.Game_ID = T.Game_ID
	JOIN dbo.Board_game AS G ON GS.Game_Name= G.game_name
	AND GS.Category = G.game_category
	AND G.is_current = 1
	JOIN dbo.Date AS D ON T.Tournament_Date = D.date
	JOIN dbo.AdditionalInfoTemp AS temp ON T.Tournament_ID = temp.tournament_id
	JOIN dbo.Additional_info AS I 
	ON temp.bringing_children = I.bringing_children
	AND temp.games_rents_during_tournament = I.games_rents_during_tournament
	AND temp.meeting_time = I.meeting_time
	AND temp.snacks_and_drinks = I.snack_and_drinks
	JOIN dbo.Junk AS J 
	ON J.number_of_winning_places = 
		CASE
			WHEN T.Number_of_winners <= 2 THEN 'between 0-2'
			WHEN (T.Number_of_winners <= 4 AND T.Number_of_winners >= 3) THEN 'from 3-4'
			WHEN (T.Number_of_winners <= 6 AND T.Number_of_winners >= 5) THEN 'from 5-6'
			WHEN T.Number_of_winners IS NULL THEN 'unknown'
		END
	AND J.entry_fee = 
		CASE
			WHEN T.Entry_Price <= 30 THEN '10-30'
			WHEN (T.Entry_Price <= 60 AND T.Entry_Price >= 40) THEN '40-60'
			WHEN (T.Entry_Price <= 100 AND T.Entry_Price >= 70) THEN '70-100'
			WHEN T.Entry_Price IS NULL THEN 'unknown'
		END
	AND J.prize_pool = 
		CASE
			WHEN T.Price_Pool <= 1000 THEN 'between 0-1000'
			WHEN (T.Price_Pool <= 2000 AND T.Price_Pool >= 1001) THEN 'between 1001-2000'
			WHEN (T.Price_Pool <= 3000 AND T.Price_Pool >= 2001) THEN 'between 2001-3000'
			WHEN (T.Price_Pool <= 4000 AND T.Price_Pool >= 3001) THEN 'between 3001-4000'
			WHEN (T.Price_Pool <= 5000 AND T.Price_Pool >= 4001) THEN 'between 4001-5000'
			WHEN T.Price_Pool IS NULL THEN 'unknown'
		END
	) AS x
GO

WITH OrderedView AS (
	SELECT TOP 100 PERCENT *
	FROM v_ETL_tournament_organization
	ORDER BY tournament_id
)

MERGE INTO Tournament_organization AS Torg
	USING OrderedView AS vTorg
		ON Torg.worker_ID = vTorg.worker_ID
		AND Torg.board_game_ID = vTorg.board_game_ID
		AND Torg.date_ID = vTorg.date_ID
		AND Torg.information_ID = vTorg.information_ID
		AND Torg.junk_ID = vTorg.junk_ID
WHEN NOT MATCHED THEN
	INSERT (
		worker_ID,
		board_game_ID,
		date_ID,
		information_ID,
		junk_ID
	)
	VALUES (
		vTorg.worker_ID,
		vTorg.board_game_ID,
		vTorg.date_ID,
		vTorg.information_ID,
		vTorg.junk_ID
	);

SELECT * FROM Tournament_organization
ORDER BY Tournament_ID;
SELECT * FROM Shop.dbo.Tournaments;
SELECT * FROM Date;
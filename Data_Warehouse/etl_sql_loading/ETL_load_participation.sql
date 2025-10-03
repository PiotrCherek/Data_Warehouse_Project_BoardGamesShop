USE warehouse
GO

IF OBJECT_ID('v_ETL_participation') IS NOT NULL
    DROP VIEW v_ETL_participation;
GO
CREATE VIEW v_ETL_participation
AS
SELECT DISTINCT
	customer_id,
	tournament_id,
	winning_prize
FROM
	(SELECT
		customer_id = C.customer_ID,
		tournament_id = T.tournament_ID,
		winning_prize = P.Price_Won
	FROM Shop.dbo.TournamentParticipants AS P
	JOIN Customer AS C ON P.Customer_ID = C.customer_code
	JOIN Shop.dbo.Tournaments AS T ON P.Tournament_ID = T.tournament_ID
	) AS x
GO

MERGE INTO Participation AS P
	USING v_ETL_participation AS vP
		ON P.tournament_ID = vP.tournament_ID
		AND P.customer_id = vP.customer_id
		AND P.winning_prize = vP.winning_prize
WHEN NOT MATCHED THEN
	INSERT (
		tournament_ID,
		customer_id,
		winning_prize
	)
	VALUES (
		vP.tournament_ID,
		vP.customer_id,
		vP.winning_prize
	);
SELECT * FROM Participation;
USE warehouse
GO

IF OBJECT_ID('v_ETL_board_games') IS NOT NULL
    DROP VIEW v_ETL_board_games;
GO
CREATE VIEW v_ETL_board_games
AS
SELECT DISTINCT
    [game_ID] AS game_ID,
    [Game_Name] AS game_name,
    [Category] AS game_category,
    [Number_Of_Copies] AS copies,
    CASE
        WHEN Number_Of_Copies BETWEEN 0 AND 3 THEN 'Between 0 and 3'
        WHEN Number_Of_Copies BETWEEN 4 AND 5 THEN 'From 4 to 5'
        ELSE 'More than 5'
    END AS number_of_copies
FROM Shop.dbo.OwnedBoardGames
GO

MERGE INTO Board_game AS BG
USING v_ETL_board_games AS v_ETL
    ON BG.game_name = v_ETL.game_name
    AND BG.game_category = v_ETL.game_category
WHEN NOT MATCHED THEN
    INSERT (game_name, game_category, number_of_copies, is_current)
    VALUES (v_ETL.game_name, v_ETL.game_category, v_ETL.number_of_copies, 1)
WHEN MATCHED
    AND (BG.number_of_copies <> v_ETL.number_of_copies) THEN
    UPDATE
    SET is_current = 0
WHEN NOT MATCHED BY SOURCE THEN
    UPDATE
    SET BG.is_current = 0;
GO
SELECT * FROM Board_game;
GO
INSERT INTO Board_game(game_name, game_category, number_of_copies, is_current)
SELECT game_name, game_category, number_of_copies, 1
FROM v_ETL_board_games
EXCEPT
SELECT game_name, game_category, number_of_copies, 1
FROM Board_game;
SELECT * FROM Board_game;
GO
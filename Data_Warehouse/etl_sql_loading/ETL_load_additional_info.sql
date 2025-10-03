USE warehouse
GO

IF OBJECT_ID('v_ETL_additional_info') IS NOT NULL
    DROP VIEW v_ETL_additional_info;
GO
CREATE VIEW v_ETL_additional_info
AS
SELECT grdt, mt, bg, sd
FROM 
	  (
		VALUES
			('rents disabled during tournaments'),
			('rents allowed during tournament')
	  ) 
	AS games_rents_during_tournaments(grdt),
	 (
		VALUES 
			('morning'),
			('evening')
	  ) 
	AS meeting_time(mt),
	 (
		VALUES 
			('do not bring children'),
			('children allowed')
	  ) 
	AS bringing_children(bg),
	 (
		VALUES 
			('free snacks and drinks'),
			('no snacks and drinks provided')
	  ) 
	AS snacks_and_drinks(sd);
GO

MERGE INTO Additional_info AS A
USING v_ETL_additional_info AS v_ETL
    ON A.games_rents_during_tournament = v_ETL.grdt 
	AND A.meeting_time = v_ETL.mt
	AND A.bringing_children = v_ETL.bg
	AND A.snack_and_drinks = v_ETL.sd
WHEN NOT MATCHED
  THEN
        INSERT (games_rents_during_tournament, meeting_time, bringing_children, snack_and_drinks)
        VALUES (v_ETL.grdt, v_ETL.mt, v_ETL.bg, v_ETL.sd)
WHEN NOT MATCHED BY SOURCE
    THEN
       DELETE;
GO

SELECT * FROM Additional_info;
/*
INSERT INTO [dbo].[Additional_info] 
SELECT grdt, mt, bg, sd
FROM 
	  (
		VALUES
			('rents disabled during tournaments'),
			('rents allowed during tournament')
	  ) 
	AS games_rents_during_tournaments(grdt),
	 (
		VALUES 
			('morning'),
			('evening')
	  ) 
	AS meeting_time(mt),
	 (
		VALUES 
			('do not bring children'),
			('children allowed')
	  ) 
	AS bringing_children(bg),
	 (
		VALUES 
			('free snacks and drinks'),
			('no snacks and drinks provided')
	  ) 
	AS snacks_and_drinks(sd);

SELECT * FROM Additional_info;
*/
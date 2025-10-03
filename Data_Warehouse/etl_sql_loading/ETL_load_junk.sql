USE warehouse
GO
INSERT INTO [dbo].[Junk] 
SELECT nwp, p, ef 
FROM 
	  (
		VALUES
			('between 0-2'),
			('from 3-4'),
			('from 5-6')
	  ) 
	AS num_of_winning_places(nwp),
	 (
		VALUES 
			('between 0-1000'),
			('between 1001-2000'),
			('between 2001-3000'),
			('between 3001-4000'),
			('between 4001-5000')
	  ) 
	AS price_pool(p),
	 (
		VALUES 
			('10-30'),
			('40-60'),
			('70-100')
	  ) 
	AS entry_fee(ef);

SELECT * FROM Junk;
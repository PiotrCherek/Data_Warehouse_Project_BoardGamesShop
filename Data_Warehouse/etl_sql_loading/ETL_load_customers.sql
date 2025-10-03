USE warehouse
GO

IF OBJECT_ID('v_ETL_customers') IS NOT NULL
    DROP VIEW v_ETL_customers;
GO
CREATE VIEW v_ETL_customers
AS
SELECT DISTINCT
    CAST([Customer_Name] + ' ' + [Surname] AS NVARCHAR(100)) AS name_and_surname,
    [customer_code] AS customer_code,
	[DateOfBirth] AS date_of_birth, 
    DATEDIFF(year, [DateOfBirth], GETDATE()) AS age, 
    CASE
        WHEN DATEDIFF(year, [DateOfBirth], GETDATE()) BETWEEN 18 AND 21 THEN 'Between 18 and 21'
        WHEN DATEDIFF(year, [DateOfBirth], GETDATE()) BETWEEN 22 AND 25 THEN 'Between 22 and 25'
		WHEN DATEDIFF(year, [DateOfBirth], GETDATE()) BETWEEN 26 AND 30 THEN 'Between 26 and 30'
		WHEN DATEDIFF(year, [DateOfBirth], GETDATE()) BETWEEN 31 AND 50 THEN 'Between 31 and 50'
        ELSE 'More than 50'
    END AS age_group
FROM Shop.dbo.CustomerAccountInfo;
GO

MERGE INTO Customer AS C
USING v_ETL_customers AS v_ETL
    ON C.customer_code = v_ETL.customer_code
WHEN NOT MATCHED
    THEN
        INSERT (name_and_surname, customer_code, age_group)
        VALUES (v_ETL.name_and_surname, v_ETL.customer_code, v_ETL.age_group);
GO

SELECT * FROM Customer;


USE dndtech;
SELECT * FROM Customers;
INSERT INTO Customers VALUES(45,'Manchester','Male','Nur','Alam');



--Delete any dulicate row from a table using CTE

WITH CustomerCTE AS
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY FirstName ORDER BY FirstName) AS RowNumber FROM Customers
)
DELETE FROM CustomerCTE WHERE RowNumber > 1;

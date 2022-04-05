USE dndtech;
SELECT * FROM Customers;


--Find the Oldest customer by City
SELECT CustomerCity, MAX(CustomerAge) AS OldestPerson FROM Customers
GROUP BY CustomerCity;

--Select 2nd Highest Age from the customer by using Sub Query
SELECT MAX(CustomerAge) FROM Customers
WHERE CustomerAge < (SELECT MAX(CustomerAge) FROM Customers);

--OR

SELECT MAX(CustomerAge) FROM Customers
WHERE CustomerAge NOT IN (SELECT MAX(CustomerAge) FROM Customers);

--Select 2nd Highest Age from the customer by using TOP Function and sub query
SELECT TOP 1 CustomerAge FROM
(SELECT TOP 2 CustomerAge FROM Customers
ORDER BY CustomerAge DESC) Result
ORDER BY CustomerAge ASC;


--Select 2nd Highest Age from the customer by using CTE and DENSE_RANK()
WITH Result AS
(
SELECT CustomerAge, DENSE_RANK() OVER (ORDER BY CustomerAge DESC) AS Age_Rank
FROM Customers
)
SELECT TOP 1 CustomerAge FROM Result
WHERE Age_Rank=2;

-------------------ROW_NUMBER(),NTILE(),RANK(),DENSE_RANK() Functions-------------------

SELECT LastName, Gender, CustomerAge,
ROW_NUMBER() OVER (ORDER BY CustomerAge DESC) AS [ROWNUMBER],
NTILE(4) OVER (ORDER BY CustomerAge DESC) AS [NTILE],--NTILE DIVIDES ROWS IN 4 TILE 
RANK() OVER (ORDER BY CustomerAge DESC) AS [RANK],
DENSE_RANK() OVER (ORDER BY CustomerAge DESC) AS [DENSE_RANK]
FROM Customers;

---------------------BY USING CTE-------------------------
WITH Result AS
(
SELECT LastName, Gender, CustomerAge, 
RANK() OVER (ORDER BY CustomerAge DESC) AS [AGE_RANK],
DENSE_RANK() OVER (ORDER BY CustomerAge DESC) AS [DENSERANK]
FROM Customers
)
SELECT * FROM Result WHERE DENSERANK =2;

----------------------USING PARTITION
SELECT LastName, Gender, CustomerAge, 
RANK() OVER (PARTITION BY Gender ORDER BY CustomerAge DESC) AS [RANK],
DENSE_RANK() OVER (PARTITION BY Gender ORDER BY CustomerAge DESC) AS [DENSE_RANK]
FROM Customers;
------------------------------------------CTE
WITH Result AS
(
SELECT LastName, Gender,  CustomerAge, 
LAG(CustomerAge) OVER (PARTITION BY Gender ORDER BY CustomerAge DESC) AS [LAG],
LEAD(CustomerAge) OVER (PARTITION BY Gender ORDER BY CustomerAge DESC) AS [LEAD],
RANK() OVER (PARTITION BY Gender ORDER BY CustomerAge DESC) AS [SALARY_RANK],
DENSE_RANK() OVER (PARTITION BY Gender ORDER BY CustomerAge DESC) AS [SALARY_DENSE_RANK],
FIRST_VALUE(CustomerAge) OVER (PARTITION BY Gender ORDER BY CustomerAge DESC 
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [FIRST_VALUE],
LAST_VALUE(CustomerAge) OVER (PARTITION BY Gender ORDER BY CustomerAge DESC 
ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS [LAST_VALUE]
FROM Customers
WHERE Gender='Male'
)
SELECT * FROM Result WHERE SALARY_RANK =2;

WITH rankOverAge AS
(
SELECT LastName, Gender, CustomerAge,
DENSE_RANK() OVER(ORDER BY CustomerAge) AS [RANK_BY_AGE]
FROM Customers
)
SELECT * FROM rankOverAge WHERE CustomerAge Between 20 and 50;
----------------------------------------------------------------------------------
---------------------------LIKE/CHARINDEX/LEFT System Functions-------------------
Select * From Products
Where UnitPrice Between 10 and 40
AND SupplierNo Not In (2)
AND ProductName Like('S%');

SELECT ProductName FROM Products
WHERE UnitPrice>10
--AND SupplierNo NOT IN (1)
AND ProductName LIKE ('H%');

SELECT ProductName FROM Products
WHERE UnitPrice>10
--AND SupplierNo NOT IN (1)
--AND CHARINDEX('H', ProductName)=1;
AND LEFT(ProductName,1)='H';


EXEC SYS.sp_help N'dbo.Customers';
EXEC SYS.sp_databases;
EXEC SYS.sp_tables;
USE dndtech
SET STATISTICS IO ON
----------------------------EXAMPLE OF SOME SYSTEM FUNCTIONS----------------------------
----------------------------------------------------------------------------------------
DECLARE @ToDay DATETIME
DECLARE @Today1 DATE
DECLARE @TODAY2 TIME
SELECT @ToDay=GETDATE()
SELECT @ToDay1=CURRENT_TIMESTAMP
SELECT @ToDay2 = SYSDATETIME()
PRINT @ToDay
PRINT @ToDay1
PRINT @ToDay2;

SELECT UPPER(LastName) AS LastName, CustomerNo FROM Customers;

SELECT CONCAT(FirstName+' ',LastName) AS FullName, 
LEFT(CustomerCity,3) AS CITY FROM Customers;

SELECT UPPER(CONCAT(FirstName+' ',LastName)) AS FULLNAME, 
UPPER(LEFT(CustomerCity,3)) AS CITY FROM Customers;

-------------------------------Logical Functions-------------------------------------------
-------------------------------------------------------------------------------------------
SELECT LastName, CustomerCity FROM Customers
WHERE ISNUMERIC(CustomerNo)=1;

SELECT LastName, CustomerCity, 
IIF(ISNUMERIC(LastName)=1,'Numaric','NonNumeric') AS CustomerStatus 
FROM Customers;

SELECT LastName, CustomerCity, 
IIF(CustomerNo IN (3,4,5),'Loyal','Ordinary') CustomerType
FROM Customers; 
--------------------------------Window Functions--------------------------------------------
--------------------------------------------------------------------------------------------
SELECT FirstName, LastName, CustomerCity, 
--RANK()OVER(ORDER BY CustomerAge ASC) AS Ranking
DENSE_RANK()OVER(ORDER BY CustomerAge ASC) AS Ranking  
FROM Customers
ORDER BY Ranking DESC;
SELECT * FROM Customers;

SELECT FirstName, LastName, CustomerCity, CustomerAge,
DENSE_RANK() OVER(PARTITION BY Gender ORDER BY CustomerAge DESC) AS Ranking 
FROM Customers
ORDER BY Ranking DESC;

-----------------------------------------------------------------------------
-----------------TEMPORARY/TEMP TABLES------RUN IN THE SESSION---------------
CREATE TABLE #CustomerTemp
( CustName VARCHAR(30)
);
INSERT INTO #CustomerTemp
SELECT DISTINCT FirstName FROM Customers;

SELECT * FROM #CustomerTemp;
--DROP TABLE #CustomerTemp;
----------------------------------------------------------------------
--------------------TABLE VARIABLE--MUST RUN IN SAME BATCH------------

DECLARE @customer AS TABLE
( CustName VARCHAR(30)
);

INSERT INTO @customer
SELECT DISTINCT LastName FROM Customers
SELECT * FROM @customer;
----------------------------------------------------------------------
---------------------------TABLE VALUED FUNCTION-----------------------
DROP FUNCTION IF EXISTS dbo.tvfShowCustDetail
GO
CREATE FUNCTION dbo.tvfShowCustDetail(@cid AS int)
RETURNS TABLE
AS
RETURN
(SELECT LastName, CustomerCity FROM Customers
WHERE CustomerNo=@cid
);

SELECT * FROM dbo.tvfShowCustDetail(2);

-------------------------------------------------------------------------------------
------------------------Creating a VIEW to get Toatal Sale by date-------------------
-------------------------------------------------------------------------------------
CREATE VIEW SaleByDate
AS
SELECT Orders.OrderDate, (Orders.Unit* Products.UnitPrice) AS TotalPrice 
FROM Orders JOIN Products ON (Orders.ProductNo=Products.ProductNo);

SELECT * FROM SaleByDate

----Crate a FUNCTION to get Total Sale, it returns total sale as MONEY data type----------
-----------------------------Scalered-Valued-Function-------------------------------------
CREATE FUNCTION Fn_Total_sale()
RETURNS MONEY
AS
BEGIN
DECLARE @totsale MONEY
SELECT @totsale=SUM(TotalPrice) FROM SaleByDate---Selecting from View
RETURN @totsale
END

---Call the Function

SELECT dbo.Fn_Total_sale() AS Total_Sale

DECLARE @ShowTotal MONEY 
SELECT @ShowTotal = dbo.Fn_Total_Sale()
PRINT @ShowTotal 

SELECT DATEDIFF(DD,OrderDate, GETDATE()) AS [Number of days ago], ProductNo
FROM Orders
ORDER BY ProductNo;

-------------------------Parameter (Date) Passed by Function------------------------
----------------------------To get Total Sale of a Date-----------------------------
CREATE FUNCTION Fn_Tol_Sale_By_Date( @Odate date)
RETURNS MONEY
AS
BEGIN
DECLARE @tdSale MONEY
SELECT @tdSale = SUM(TotalPrice) FROM SaleByDate
WHERE OrderDate = @Odate
RETURN @tdSale
END
-------Calling the function by both ways
DECLARE @TotByDate MONEY
SELECT @TotByDate = dbo.Fn_Tol_Sale_By_Date('2018-02-23')
PRINT @TotByDate

SELECT dbo.Fn_Tol_Sale_By_Date('2018-02-23') AS TotalSale


-------------------------------Table Valued Function------------------------
--------------------------Passing Parameter as Supplier No------------------

CREATE FUNCTION ProductBySupplier(@sid INT)
RETURNS TABLE
AS RETURN
SELECT * FROM Products
WHERE SupplierNo = @sid

SELECT ProductName,UnitPrice FROM dbo.ProductBySupplier(4)

SELECT  ProductNo, CustomerNo, COUNT(*) AS TotOrders FROM Orders
GROUP BY ProductNo, CustomerNo
ORDER BY ProductNo; 
--------------Table Valued Function
CREATE FUNCTION Fn_Total_Sale_by_Date(@SaleDay DATE)
RETURNS TABLE
AS RETURN
SELECT OrderDate, SUM(TotalPrice) AS [Total Day Sale] FROM SaleByDate---Selecting from View
WHERE OrderDate=@SaleDay
GROUP BY OrderDate

SELECT * FROM Fn_Total_Sale_by_Date('2018-02-23');

SELECT * FROM SaleByDate;
SELECT * FROM Orders;
----------------------Table valued function can treat as a Table & can perform query
CREATE FUNCTION dailySale()
RETURNS TABLE
RETURN
SELECT OrderDate, SUM(TotalPrice) AS [Total Sale] FROM SaleByDate
GROUP BY OrderDate

SELECT SUM([Total Sale]) AS [Grand Total]FROM dailySale()

SELECT * FROM Suppliers;
SELECT * FROM Orders;
SELECT * FROM Products;

----Creating a view
DROP VIEW saleReport 
CREATE VIEW saleReport
AS
SELECT C.LastName, O.OrderDate, P.UnitPrice*O.Unit AS [Total Price] 
FROM Customers AS C
JOIN Orders AS O
ON C.CustomerNo=O.CustomerNo
JOIN Products AS P
ON O.ProductNo=P.ProductNo

-----Creating a function by using the view
DROP FUNCTION tvfSale
CREATE FUNCTION tvfSale()
RETURNS TABLE
RETURN
SELECT LastName, CAST(SUM([Total Price]) AS MONEY) AS [Invoice Total] FROM saleReport
GROUP BY LastName;


SELECT * FROM tvfSale()

SELECT CAST(SUM([Invoice Total]) AS decimal) AS [Grand Total] FROM tvfSale()
SELECT CONVERT(decimal, SUM([Invoice Total])) AS [Grand Total] FROM tvfSale()


SELECT * FROM saleReport;
-------------------------------------STORE PROCEDURE----------------------------
--------------------------------------------------------------------------------
--DROP PROC spSales
CREATE PROC spSales
AS
BEGIN
SELECT OrderDate, CONVERT(MONEY, SUM([Total Price])) AS [Daily Sale] 
FROM saleReport
GROUP BY OrderDate
END

EXEC spSales
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM Products;

INSERT INTO Orders VALUES('4','4', '2018-02-28','2')
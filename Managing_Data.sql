USE dndtech
SET STATISTICS IO ON
SET STATISTICS TIME ON
--SET STATISTICS TIME OFF
---Ttying SELECT Statements
SELECT * FROM Customers;
SELECT DISTINCT Gender FROM Customers;
SELECT Customers.CustomerNo, Customers.LastName FROM Customers;
SELECT Customers.CustomerNo, Customers.LastName, Customers.CustomerCity FROM Customers
ORDER BY Customers.CustomerCity;
SELECT Customers.LastName+' lives in '+Customers.CustomerCity AS CustomerCity FROM Customers;

--Select customers with at least 1 order
SELECT Customers.LastName, COUNT(Orders.OrderNo) AS TotalOrders
FROM Customers LEFT OUTER JOIN Orders 
ON (Customers.CustomerNo = Orders.CustomerNo)
GROUP BY Customers.LastName
HAVING COUNT(Orders.OrderNo)>=1
ORDER BY TotalOrders DESC;

---Find London Suppliers
SELECT S.SupplierName,COUNT(P.ProductNo) AS Total_Pro_Deliver FROM 
Suppliers AS S LEFT JOIN Products AS P
ON (S.SupplierNo=P.SupplierNo)
WHERE S.SupplierCity='London'
GROUP BY S.SupplierName
HAVING COUNT(P.ProductNo)>=1
ORDER BY Total_Pro_Deliver DESC;

----Grouping Set
SELECT S.SupplierName,P.ProductName,COUNT(P.ProductNo) AS Total_Pro_Del 
FROM Suppliers AS S  RIGHT JOIN Products AS P
ON (S.SupplierNo=P.SupplierNo)
--WHERE S.SupplierCity='Blackpool'
GROUP BY
GROUPING SETS(( S.SupplierName, P.ProductName),())
HAVING COUNT(P.ProductNo)>=1
ORDER BY Total_Pro_Del DESC;

SELECT S.SupplierName,P.ProductName,COUNT(P.ProductNo) AS Total_Pro_Del 
FROM Suppliers AS S JOIN Products AS P
ON (S.SupplierNo=P.SupplierNo)
--WHERE S.SupplierCity='Blackpool'
GROUP BY
GROUPING SETS(( S.SupplierName, P.ProductName),
				(S.SupplierName),
				(P.ProductName), ())
HAVING COUNT(P.ProductNo)>=1
ORDER BY Total_Pro_Del DESC;

SELECT * FROM Products;

SELECT S.SupplierName, COUNT(P.ProductNo) AS TotalProductsSupply 
FROM Suppliers AS S JOIN Products AS P
ON S.SupplierNo=P.SupplierNo
GROUP BY S.SupplierName
--GROUPING SETS(S.SupplierName, ()) 
ORDER BY TotalProductsSupply DESC;


SELECT S.SupplierName, P.ProductName FROM 
Suppliers AS S FULL OUTER JOIN Products AS P
ON (S.SupplierNo=P.SupplierNo);

SELECT S.SupplierName, P.ProductName FROM 
Suppliers AS S LEFT OUTER JOIN Products AS P
ON (S.SupplierNo=P.SupplierNo);


SELECT S.SupplierName, P.ProductName FROM 
Suppliers AS S RIGHT OUTER JOIN Products AS P
ON (S.SupplierNo=P.SupplierNo);


SELECT * FROM Suppliers;
SELECT * FROM Products;
SELECT * FROM Customers;
INSERT INTO Suppliers VALUES('Silver Tech', 'Blackpool');

UPDATE Customers
SET FirstName='Ilias',LastName= 'Kobra', CustomerAge=39, CustomerCity='Forest Gate', Gender='Male'
WHERE CustomerNo=1177;

INSERT INTO Customers
VALUES (45,'London','Male','Jhon','Walker');

SELECT * FROM Customers
WHERE FirstName LIKE('s%') AND CustomerCity <> 'London';

SELECT * FROM Customers
WHERE LastName NOT LIKE('[ja]%') AND CustomerCity <> 'London';

SELECT AVG(Customers.CustomerAge) AS AverageAge FROM Customers
WHERE Customers.CustomerCity <> 'London';

SELECT Orders.CustomerNo, CAST(Orders.OrderDate AS smalldatetime) AS Order_Date 
FROM Orders;

SELECT Orders.CustomerNo, CAST(Orders.OrderDate AS datetimeoffset) AS Order_Date 
FROM Orders;

SELECT Orders.CustomerNo, CONVERT(datetimeoffset(0), Orders.OrderDate) AS Order_Date 
FROM Orders;

SELECT Orders.CustomerNo, MONTH(Orders.OrderDate) AS Order_Month 
FROM Orders;

SELECT TOP (3) OrderNo, OrderDate FROM Orders
ORDER BY OrderDate DESC;

SELECT TOP (3) WITH TIES OrderNo, OrderDate FROM Orders
ORDER BY OrderDate DESC;

SELECT TOP (50) PERCENT OrderNo, OrderDate FROM Orders
ORDER BY OrderDate DESC;

SELECT * FROM Orders
ORDER BY OrderNo
OFFSET 5 ROWS FETCH FIRST 5 ROWS ONLY;

SELECT * FROM Orders
ORDER BY OrderNo
OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;


---CALLING TABLE VALUED FUNCTION
SELECT ProductName,UnitPrice FROM dbo.ProductBySupplier(3);
---CALLING SCALAR VALUED FUNCTION
SELECT dbo.Fn_Total_sale() AS TotalSale;
-----SELECT FROM VIEW
SELECT CAST(SUM(TotalPrice) AS money) AS TotalSale FROM SaleByDate;


SELECT Orders.CustomerNo, 
CAST((Orders.Unit* Products.UnitPrice) AS decimal(10,2)) 
AS TotalOrderPrice 
FROM Orders JOIN Products 
ON (Orders.ProductNo=Products.ProductNo)

------------EXAMPLE OF CTE, TO FIND GRAND TOTAL------------- 

WITH TotOrder
AS
(
SELECT O.CustomerNo AS CustNo, 
CAST((O.Unit*P.UnitPrice) AS decimal(10,2)) AS TotalOrderPrice 
FROM Orders AS O JOIN Products AS P 
ON (O.ProductNo=P.ProductNo)
)
SELECT CustNo AS CustomerNo, SUM(TotalOrderPrice) AS GrandTotal 
FROM TotOrder--Calling CTE
GROUP BY CustNo
ORDER BY GrandTotal DESC;

-------------------------DRIVED TABLE
SELECT CustNo AS CustomerNo, SUM(TotalOrderPrice) AS GrandTotal
FROM
(
SELECT O.CustomerNo AS CustNo, 
CAST((O.Unit*P.UnitPrice) AS decimal(10,2)) AS TotalOrderPrice 
FROM Orders AS O JOIN Products AS P 
ON (O.ProductNo=P.ProductNo)
)
AS drTable
GROUP BY CustNo
ORDER BY GrandTotal DESC;
-------------------------- TABLE VARIABLE
DECLARE @tbvar AS TABLE
(Cno INT, Total DECIMAL(10,2))
INSERT INTO @tbvar
SELECT O.CustomerNo, 
CAST((O.Unit*P.UnitPrice) AS decimal(10,2)) 
FROM Orders AS O JOIN Products AS P 
ON (O.ProductNo=P.ProductNo)
SELECT Cno AS CustomerNo, SUM(Total) AS GrandTotal FROM @tbvar
GROUP BY Cno
ORDER BY GrandTotal DESC;





--------------------------TEMPORARY TBLE---------------------
SELECT Orders.CustomerNo AS CustNo, 
SUM(CAST((Orders.Unit* Products.UnitPrice) AS decimal(10,2))) AS TotalOrderPrice 
INTO #TempTotOrdPrice
FROM Orders JOIN Products ON (Orders.ProductNo=Products.ProductNo)
GROUP BY Orders.CustomerNo
ORDER BY TotalOrderPrice DESC;
--SELECT * FROM #TempTotOrdPrice;
SELECT CustNo,TotalOrderPrice FROM #TempTotOrdPrice
ORDER BY TotalOrderPrice DESC;


---------Create a new table from Customer's information------------
DROP TABLE IF EXISTS dbo.CustmerLocation
SELECT CustomerCity, Gender, COUNT(*) TotalCustomer
INTO dbo.CustmerLocation
FROM Customers
GROUP BY CustomerCity, Gender;


/*
SELECT * FROM dbo.CustmerLocation;

CREATE UNIQUE CLUSTERED INDEX uni_CustLoc
ON CustmerLocation(CustomerCity, Gender);
DROP INDEX CustmerLocation.uni_CustLoc;


ALTER TABLE dbo.CustmerLocation ADD CONSTRAINT uni_CustLocation
UNIQUE CLUSTERED (CustomerCity, Gender);

SELECT CustomerCity,SUM(TotalCustomer) AS [Total Customer] FROM dbo.CustmerLocation
GROUP BY CustomerCity
ORDER BY [Total Customer] DESC;

SELECT C.LastName, cl.CustomerCity FROM Customers AS C
INNER JOIN CustmerLocation AS cl
ON (C.CustomerCity=cl.CustomerCity)
OR (C.CustomerCity IS NULL OR cl.CustomerCity IS NULL)
--AND ISNULL(C.CustomerCity)=ISNULL(cl.CustomerCity)
ORDER BY C.LastName;

DROP Table CustmerLocation;
*/
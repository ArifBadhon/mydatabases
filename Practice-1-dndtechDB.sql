USE dndtech;
SELECT * FROM Suppliers;
SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM Products;

SET SHOWPLAN_ALL ON;
SET SHOWPLAN_ALL OFF;


SELECT CustomerCity FROM Customers
EXCEPT
SELECT SupplierCity FROM Suppliers;

--Find Common cities from customers and suppliers

SELECT CustomerCity FROM Customers
UNION
SELECT SupplierCity FROM Suppliers;

SELECT CustomerCity FROM Customers
UNION ALL
SELECT SupplierCity FROM Suppliers;


SELECT Gender, AVG(CustomerAge) AverageAge FROM Customers
GROUP BY Gender;

SELECT * FROM Customers
WHERE CustomerCity='London' AND CustomerAge>50;

--Find the customer who has placed an order
SELECT DISTINCT C.CustomerName FROM Customers AS C
JOIN Orders AS O ON C.CustomerNo=O.CustomerNo;

--The Customers who have not placed any order
SELECT CustomerNo, CustomerName FROM Customers
WHERE CustomerNo NOT IN (SELECT CustomerNo FROM Orders);

SELECT C.CustomerName, P.ProductName FROM Customers AS C
INNER JOIN Orders AS O ON C.CustomerNo = O.CustomerNo
INNER JOIN Products AS P ON O.ProductNo = P.ProductNo
--WHERE O.OrderDate BETWEEN '2018-01-01' AND  '2018-12-31';
WHERE O.OrderDate <'2018-06-30';

SELECT O.OrderNo, P.UnitPrice*O.Unit AS TotalPrice FROM Products AS P
INNER JOIN Orders AS O ON P.ProductNo=O.ProductNo;

Execute dbo.sp_GetCust;
Execute dndtech.sys.sp_helpindex customers;
Execute sp_helpindex Orders;
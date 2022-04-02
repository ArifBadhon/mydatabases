USE dndtech;

---To find most expensive prosuct and Supplier------
SELECT P.ProductName, S.SupplierName FROM Products AS P
INNER JOIN Suppliers AS S
ON P.SupplierNo=S.SupplierNo
WHERE UnitPrice =
(SELECT MAX(UnitPrice) FROM Products);

SELECT P.ProductName, S.SupplierName FROM Products AS P
INNER JOIN Suppliers AS S
ON (P.SupplierNo=S.SupplierNo)
WHERE P.ProductNo =
(SELECT ProductNo 
FROM Products
WHERE ProductName LIKE('h%') );

-----Find Cheapest product
SELECT ProductName, UnitPrice FROM Products
WHERE UnitPrice = (SELECT MIN(UnitPrice) FROM Products);

---Find products where product price is <=20
SELECT ProductName, UnitPrice FROM Products 
WHERE UnitPrice NOT IN (SELECT UnitPrice FROM Products WHERE UnitPrice>=20);

SELECT ProductName, UnitPrice FROM Products 
WHERE UnitPrice <= ALL (SELECT UnitPrice FROM Products WHERE UnitPrice>=20);

SELECT C.LastName, C.CustomerCity FROM Customers AS C
WHERE C.CustomerNo IN
(SELECT O.CustomerNo FROM Orders AS O
WHERE C.CustomerNo=O.CustomerNo
 AND O.OrderDate>='2018-02-01'
);

SELECT C.LastName, C.CustomerCity FROM Customers AS C
LEFT OUTER JOIN Orders AS O
ON C.CustomerNo=O.CustomerNo
WHERE O.OrderDate>='2018-02-01'
ORDER BY C.LastName;
--------------------------------------------------------------------
--------------------------------------------------------------------
------Find the customers who has not placed any order
SELECT C.CustomerNo, C.LastName, C.CustomerCity FROM Customers AS C
WHERE C.CustomerNo NOT IN 
(SELECT O.CustomerNo FROM Orders AS O);

SELECT CustomerNo, LastName, CustomerCity FROM Customers
WHERE CustomerNo IN
(SELECT CustomerNo FROM Customers
EXCEPT
SELECT CustomerNo FROM Orders);
---------------------------------------------------------------------
SELECT C.LastName, C.CustomerCity, 
ROW_NUMBER() OVER(PARTITION BY C.LastName ORDER BY C.CustomerCity) AS RowNo
FROM Customers AS C
CROSS APPLY (SELECT O.CustomerNo FROM Orders AS O
WHERE C.CustomerNo=O.CustomerNo) AS E

------------------------------------CTE---------------------

WITH arif AS
(
SELECT C.LastName, C.CustomerCity, 
ROW_NUMBER() OVER(PARTITION BY C.LastName ORDER BY C.CustomerCity) AS RowNo
FROM Customers AS C
CROSS APPLY (SELECT O.CustomerNo FROM Orders AS O
WHERE C.CustomerNo=O.CustomerNo) AS E
)
SELECT LastName, RowNo FROM arif
WHERE RowNo=1;


WITH TotalSale AS
(
SELECT O.OrderNo, (O.Unit*P.UnitPrice) AS InvoiceTotal  FROM Orders AS O
JOIN Products AS P
ON O.ProductNo=P.ProductNo
)
SELECT CONVERT(decimal(10,2),SUM(InvoiceTotal)) AS Total_Sale FROM TotalSale;
-------------------------------------------------------------------------------------------
-----------------INLINE TABLE-VALUED FUNCTION
-------------------------------------------------------------------------------------------

CREATE FUNCTION GetTotalSaleByCustomer(@Cid INT)
RETURNS TABLE
AS
RETURN
WITH TotalSale AS
(
SELECT O.CustomerNo, O.OrderNo, (O.Unit*P.UnitPrice) AS InvoiceTotal  FROM Orders AS O
JOIN Products AS P
ON O.ProductNo=P.ProductNo
WHERE O.CustomerNo=@Cid
)
SELECT CONVERT(decimal(10,2),SUM(InvoiceTotal)) AS Total_Sale FROM TotalSale;
GO

SELECT * FROM dbo.GetTotalSaleByCustomer(2);

CREATE FUNCTION InvoiceValue(@Cid INT)
RETURNS TABLE
AS
RETURN
(
SELECT O.CustomerNo, O.OrderNo, O.OrderDate, (O.Unit*P.UnitPrice) AS InvoiceTotal  FROM Orders AS O
JOIN Products AS P
ON O.ProductNo=P.ProductNo
WHERE O.CustomerNo=@Cid
);
GO
SELECT * FROM dbo.InvoiceValue(2);
SELECT * FROM dbo.ProductBySupplier(1);
SELECT * FROM dbo.tvf_ShowCust(1);
---------------------------------------------------------------------
---------------------------------------------------------------------
SELECT C.CustomerNo, C.CustomerName, C.CustomerCity FROM Customers AS C
WHERE EXISTS
(SELECT * FROM Orders AS O
WHERE C.CustomerNo=O.CustomerNo
 AND O.OrderDate>='2018-02-01'
);

SELECT LastName, Gender FROM Customers AS C1
WHERE  NOT EXISTS
(SELECT CustomerCity FROM Customers AS C2
WHERE C1.CustomerNo=C2.CustomerNo
AND CustomerCity LIKE('L%') );

----------------Table Variable----------------------
DECLARE @table AS TABLE (Name VARCHAR(30));
INSERT INTO @table
SELECT ProductName FROM Products;
SELECT * FROM @table;
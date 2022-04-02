USE dndtech
SELECT * FROM dbo.NoOfDayOrder;
SELECT * FROM dbo.SaleByDate;

DECLARE @totsale int
SELECT @totsale = SUM(TotalPrice) FROM dbo.NoOfDayOrder
PRINT @totsale;

DECLARE @dsale int --@sdate date;
SELECT @dsale = SUM(TotalPrice) FROM dbo.SaleByDate
--Group BY OrderDate
PRINT @dsale; 
--PRINT @sdate;

------------------------------------TABLE VARIABLE----------------------------------
-------------------------------MUST RUN THE CODE TOGETHER---------------------------
DECLARE @tempOrder AS TABLE (OrderDate DATE, TotalSale int)
INSERT INTO @tempOrder
SELECT Orders.OrderDate, SUM(Orders.Unit * Products.UnitPrice) AS TotalDailySale  From Orders
INNER JOIN Products ON (Orders.ProductNo=Products.ProductNo)
--Where Orders.OrderDate Between '2018-01-01' And GETDATE()
Group By Orders.OrderDate
Having SUM(Orders.Unit * Products.UnitPrice) >1

SELECT * FROM @tempOrder
WHERE TotalSale>1;
---------------------------------------DRIVED TABLE-------------------------------------
----------------------------------------------------------------------------------------
SELECT OrderDate, TotalDailySale
FROM
(
Select Orders.OrderDate, SUM(Orders.Unit * Products.UnitPrice) As TotalDailySale  From Orders
Join Products On (Orders.ProductNo=Products.ProductNo)
--Where Orders.OrderDate Between '2018-01-01' And GETDATE()
Group By Orders.OrderDate)
AS dt_Sale
WHERE TotalDailySale>100;

----------------------------CTE (Common Table Expression)----------------------------------
-------------------------------------------------------------------------------------------
WITH cte_TotalSale (OrderDate, TotalDailySale)
AS
(
Select Orders.OrderDate, CAST(SUM(Orders.Unit * Products.UnitPrice) AS money) As TotalDailySale  From Orders
Join Products On (Orders.ProductNo=Products.ProductNo)
--Where Orders.OrderDate Between '2018-01-01' And GETDATE()
Group By Orders.OrderDate)
SELECT * FROM cte_TotalSale
WHERE TotalDailySale>100;

------------------------------EXAMPLE OF IF ELSE--------------------------------
UPDATE Orders
SET OrderDate=GETDATE()
WHERE OrderNo=15;
IF @@ROWCOUNT <1
	BEGIN
		PRINT 'PRODUCT NOT FOUND'
	END
ELSE
	BEGIN
		PRINT 'PRODUCT UPDATED'
	END

/*	

CREATE TABLE SupplierCallLog
(
CallNo INT IDENTITY PRIMARY KEY NOT NULL,
CallTime DATETIMEOFFSET NOT NULL DEFAULT GETDATE(),
SalesPerson NVARCHAR(60) NOT NULL,
ProductId INT NOT NULL REFERENCES Product(ProductId),
PhoneNo NVARCHAR(25) NOT NULL,
Note NVARCHAR(50)
);
GO
INSERT INTO SupplierCallLog
VALUES(DEFAULT,'K Karim',1,'01144457499','Product ordered');

INSERT INTO SupplierCallLog(SalesPerson,ProductId,PhoneNo,Note)
VALUES('K Karim',3,'01144457411','Product ordered'),
('K Karim',4,'01144457433','Product ordered');

SELECT * FROM SupplierCallLog;
SELECT SCOPE_IDENTITY();
SELECT @@IDENTITY;
SELECT GETDATE();
DELETE FROM SupplierCallLog
WHERE CallNo=8;
SELECT @@rowcount;

DROP TABLE SupplierCallLog;
*/
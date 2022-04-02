use dndtech
Select * From Products;
Select * From Suppliers;
Select * From Orders;

--Create an Index to see Product Price on Assending order
Create Index ShowProduct
On Products (UnitPrice ASC); 

--Create an Index to see Recent Orders
Create Index RecentOrders
On Orders (OrderDate DESC);

--To see existance of a Table Index 
sp_Helpindex Orders;


--Create an Index to see resent orders
CREATE INDEX ShowCustomer
ON Orders (OrderDate DESC);
-- Drop An Index
Drop Index Orders.ShowCustomer;

--Using Index to get date / WITH
Select * From Products With(Index(ShowProduct));

Select * From Orders With(Index(RecentOrders));

Select * From Orders With(Index(ShowCustomer)); 


---------------------------------------------------------------------------------

--Create a View
Create View ShowProduct_1 As
Select UnitPrice From Products
Where UnitPrice >10;

--Create a View for Daily Sale
Create View DailySales As
Select Orders.OrderDate, SUM(Orders.Unit * Products.UnitPrice) As TotalDailySale  From Orders
Join Products On (Orders.ProductNo=Products.ProductNo)
--Where Orders.OrderDate Between '2018-01-01' And GETDATE()
Group By Orders.OrderDate
Having SUM(Orders.Unit * Products.UnitPrice) >1;


Select * From DailySales;

Select Orders.OrderDate, Products.ProductName, SUM(Orders.Unit * Products.UnitPrice) As TotalDailySale  From Orders
Join Products On (Orders.ProductNo=Products.ProductNo)
--Where Orders.OrderDate Between '2018-01-01' And GETDATE()
Group By Orders.OrderDate, Products.ProductName
Having SUM(Orders.Unit * Products.UnitPrice) >1;

--Create a Temporary Table #SalesByDate

Select Orders.OrderDate AS dateOfOrder, CAST(SUM(Orders.Unit * Products.UnitPrice) AS money) As TotalDailySale 
Into #SalesByDate 
From Orders Join Products On (Orders.ProductNo=Products.ProductNo)
--Where Orders.OrderDate Between '2018-01-01' And GETDATE()
Group By Orders.OrderDate
Having SUM(Orders.Unit * Products.UnitPrice) >1;

--Use  #SalesByDate to Calculate Toatal Sale

Select dateOfOrder, Sum(TotalDailySale) As TotalSaleByDate From #SalesByDate
--Where #Sales.OrderDate Between '2018-01-01' And GETDATE()
Group By dateOfOrder
Having Sum(TotalDailySale) >1;

Select Sum(TotalDailySale) As TotalSale From #SalesByDate;

Select * From #SalesByDate
DROP TABLE #SalesByDate



-- Select Date From View
Select * From ShowProduct_1

Select * From Products
Select * From Suppliers
Select * From Orders

Select Suppliers.SupplierName, Products.ProductName From Products
Join Suppliers On (Products.SupplierNo=Suppliers.SupplierNo)

--Using Having and Where, Gets same result

Select SupplierNo,  Count(ProductName) As TotalProductsSupplied From Products
Group By SupplierNo
Having Count(ProductName) >= 1;

Select SupplierNo,  Count(ProductName) As TotalProductsSupplied From Products
Where SupplierNo Between 1 And 5
Group By SupplierNo;


	

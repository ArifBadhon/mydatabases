USE dndtech;
SELECT * FROM Products;
SELECT * FROM Orders;

Select DATEDIFF(Month, OrderDate, GETDATE()) AS OrderPlaceMonthAgo from Orders;
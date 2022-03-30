USE dndtech;
SELECT * FROM Orders;

--Find number of orders placed by a customer using partition function

SELECT DISTINCT C.CustomerName, COUNT(O.CustomerNo) OVER (PARTITION BY O.CustomerNo) AS NumberOfOrders FROM Customers AS C
JOIN Orders AS O ON C.CustomerNo=O.CustomerNo;
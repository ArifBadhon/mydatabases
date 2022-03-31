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

--Select 2nd Highest Age from the customer by using TOP Function
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
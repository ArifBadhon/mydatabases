Use dndtech

Select * From Customers 

Create Table CustomerAudit
( CustAuditNo int Primary Key identity(1,1), 
AuditDetail varchar(70))

Create Table ProductAudit
( ProAuditNo int Primary Key identity(1,1), 
AuditDetail varchar(70))

---DROP Trigger tr_ProductAudit;

CREATE Trigger tr_ProductAuditForInsert
On Products
For Insert
As
Begin
declare @id int
Select @id = ProductNo  from  inserted
Insert Into ProductAudit Values 
( 'P No' + Cast(@id as nvarchar(5)) + ' is added at' +Cast(Getdate() as nvarchar(20)))
End

Select * from Products

Update Products
Set ProductName='USB Cable'
Where ProductNo=21;

Insert into Products values('Disk2', '15.50', '3')


Select * From ProductAudit

---Creating a Trigger to Audit Customer Table and Kept the information in the 
---CustomerAudit Table
--INSERT TRIGGER

Create Trigger tr_Cust_Insert
On Customers
For Insert
As
Begin
--Select * From inserted
declare @id int
Select @id = CustomerNo  from  inserted
Insert Into CustomerAudit Values 
( 'C No' + Cast(@id as nvarchar(5)) + ' is added at' +Cast(Getdate() as nvarchar(20)))
End

SELECT * FROM CustomerAudit;

DELETE FROM CustomerAudit
WHERE AuditDetail IS NULL;
---Delete 91 t0 100 Rec from the CustomerAudit table by a Procedure---
ALTER PROC spDelCustRec @cano int
AS
WHILE @cano > 90
BEGIN
DElETE FROM CustomerAudit
WHERE CustAuditNo=@cano
SET @cano=@cano+1
IF @cano>100
BEGIN
BREAK
END
END

EXEC spDelCustRec 91;

CREATE FUNCTION displayCustAudit(@dno int) 
RETURNS TABLE
AS RETURN
SELECT * FROM CustomerAudit
WHERE CustAuditNo=@dno

SELECT * FROM displayCustAudit(1)

/*Create a scaler value function, returns avg age of customers
----------*/

SELECT AVG(CustomerAge) AS AverageCustomerAge FROM Customers;

CREATE FUNCTION avgCustAge()
RETURNS int
AS
BEGIN
DECLARE @age int
SELECT @age=AVG(CustomerAge) FROM Customers
RETURN @age
END

SELECT dbo.avgCustAge() AS AverageCustomerAge;
-----Getting Avg Age of all customers by single/scaler valued Function
CREATE FUNCTION avgCustAgeRange()
RETURNS int
AS
BEGIN
DECLARE @age int
SELECT @age=AVG(CustomerAge) FROM Customers
RETURN @age
END

SELECT dbo.avgCustAgeRange() AS [Customer Average Age];
--DROP FUNCTION dbo.avgCustAgeRange

DElETE FROM CustomerAudit
WHERE CustAuditNo=380;

--DELETE TRIGGER
CREATE TRIGGER tr_Cust_Delete
ON Customers
FOR DELETE
AS
BEGIN
declare @cno int
SELECT @cno = CustomerNo FROM deleted
INSERT INTO CustomerAudit Values 
('Customer No '+ CAST(@cno AS nvarchar(5)) +'is deleted at '+ CAST(GETDATE() AS nvarchar(20)))
END



Insert Into Customers
Values('Bashir Khan', '67','Seven Kings','Male')

Delete From Customers
Where CustomerNo= 8

Select * From Customers
Select * From CustomerAudit

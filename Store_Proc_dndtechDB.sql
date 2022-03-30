USE dndtech
SELECT * FROM Customers
SELECT @@VERSION
SET STATISTICS IO ON
------------Create a Store Procedure with Parameter--------
---------------------------------------------------------------------

CREATE PROC ShowCustByGender @gender varchar(6)
AS
SET NOCOUNT ON
BEGIN
SELECT * FROM Customers
WHERE Customers.Gender = @gender
END

---DROP PROC ShowCustByGender
EXEC ShowCustByGender 'Male'

EXEC ShowCustByGender 'Female'
EXEC ShowCustByGender

------------------------------------------STORED PROCEDURE FOR INSERTING ROWS--------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

CREATE PROC sp_InsertCust @cid int =1
AS
WHILE @cid <=5
BEGIN
INSERT INTO Customer
VALUES ('xxx','42','YYY','ZZZ')
--SELECT * FROM Customers
--WHERE Customers.CustomerNo = @cid
SET @cid +=1
END

EXEC sp_InsertCust

SELECT @@IDENTITY
SELECT SCOPE_IDENTITY()
SELECT IDENT_CURRENT('Products')
SELECT IDENT_CURRENT('')
SELECT IDENT_CURRENT('Customers')

SELECT * FROM Products;
-----------------CREATE A STOTE PROCEDURE FOR DELETING FEW ROWS FROM PRODUCT TABLE-----------------
ALTER PROC sp_DelProd @pid int
AS
WHILE @pid<=17
BEGIN
DELETE FROM Products
WHERE ProductNo=@pid
SET @pid=@pid+1
END

EXEC sp_DelProd 17   --CALL A PROCEDURE BY ECEC------------------
DROP PROC sp_DelProd--TO DELETE A PROCEDURE WE USE DROP------------

SELECT * FROM Customers;


CREATE PROC sp_InsertCustHd 
AS
BEGIN
DECLARE @cid int =1
WHILE @cid <=100
BEGIN TRANSACTION
INSERT INTO Customers
VALUES ('xxx','23','YYY','ZZZ')
--SELECT * FROM Customers
--WHERE Customers.CustomerNo = @cid
SET @cid +=1
COMMIT TRANSACTION
END

SELECT * FROM Customers
INSERT INTO Customers
VALUES ('xxx','33','YYY','ZZZ')
INSERT INTO Products
VALUES ('zzz',33.55,2)


-----STORED PROCEDURE FOR DELETING ROWS------------------


ALTER PROC sp_DeleteCust
AS
DECLARE @did int =1170
WHILE @did <=1170
BEGIN
   BEGIN TRY
        BEGIN TRANSACTION
--DECLARE @did int =73
--WHILE @did <=146
        DELETE FROM Customers
        WHERE Customers.CustomerNo=@did
        SET @did +=1
        COMMIT TRANSACTION
    END TRY
 BEGIN CATCH
   ROLLBACK TRANSACTION
 END CATCH
END

EXEC sp_DeleteCust

CREATE PROC sp_ShowCutomer
@sh_cust int
AS
BEGIN 
SELECT * FROM Customers
WHERE Customers.CustomerNo = @sh_cust
END

EXEC sp_ShowCutomer 3

------WE CAN USE TRANSACTION COMMAND TO DO SAME THING-----

BEGIN TRY
	BEGIN TRAN 
	DECLARE @id int =11
	WHILE @id =<10
		BEGIN
		INSERT INTO Suppliers
		VALUES (@id,'HillTec','London')
		SET @id +=1
		END
	COMMIT TRAN
END TRY
BEGIN CATCH
	--SELECT ERROR_MESSAGE();
	RAISERROR('INVALID SUPPLIER NO',16,1);
	THROW 50000,'INVALID SUPPLIER NO',1;
	ROLLBACK TRAN
END CATCH

SELECT * FROM Suppliers;
EXEC sp_GetCustomer '1'
DROP PROC sp_GetCustomer
-----------------------------------------
------------12/12/2018
------------------------------------------
SELECT * FROM Products;

UPDATE Products
SET UnitPrice=100
WHERE ProductNo=2;

SET XACT_ABORT ON;
BEGIN TRY
	BEGIN TRAN
		--DELETE FROM Products
		--WHERE ProductNo=100
		/*UPDATE Products
		SET ProductName='Dust Clening Brush'
		WHERE ProductNo=100 */
		UPDATE Products
		SET UnitPrice= UnitPrice-(100*0.25)
		WHERE ProductName='RAM';
	COMMIT TRAN
END TRY
BEGIN CATCH
	--IF @@ROWCOUNT =0
	--RAISERROR('PRODUCT NOT FOUND',16,1);
	--THROW 50000,'PRODUCT NOT FOUND',1;
	--THROW;
	SELECT ERROR_MESSAGE();
	ROLLBACK TRAN
END CATCH

SELECT * FROM ProductAudit;
SELECT * FROM CustomerAudit;

SET XACT_ABORT ON;
BEGIN TRY
	BEGIN TRAN
		DELETE Products
		WHERE ProductNo=11;
		IF @@ROWCOUNT <1
			BEGIN
			--PRINT'PRODUCT NOT FOUND';
			RAISERROR('PRODUCT NOT FOUND',16,1);
			END
		ELSE
			BEGIN
			PRINT 'PRODUCT FOUND';
			END
	COMMIT TRAN
END TRY
BEGIN CATCH
PRINT 'INVALID'
--RAISERROR('PRODUCT NOT FOUND',16,1);
--THROW;
END CATCH


		UPDATE Products
		SET ProductName='Dust Clening Brush'
		WHERE ProductNo=100;
		IF @@ROWCOUNT <1
		RAISERROR('PRODUCT NOT FOUND',16,1);
		THROW 50000,'PRODUCT NOT FOUND',1;


SELECT * FROM Products;
----------------------------15/12/18-------------------------
CREATE PROC sp_DelCus (@Cid int)
AS
BEGIN
   BEGIN TRY
        BEGIN TRANSACTION
			
			IF @Cid=10
			RAISERROR('CAN NOT DELETE CUSTOMER NO 10',16,1)
			DELETE FROM Customers
			WHERE Customers.CustomerNo=@Cid
        COMMIT TRANSACTION
    END TRY
 BEGIN CATCH
	IF XACT_STATE()!=0
   ROLLBACK TRANSACTION
 END CATCH
END
----------------------------------------------------------------
BEGIN TRY
        BEGIN TRANSACTION
			
			--THROW;
			--PRINT 'CUSTOMER DELETED'
			UPDATE Customers
			SET CustomerName='Alex'
			WHERE CustomerNo=151
			--INSERT INTO Customers
			--VALUES('YYYYY',99,'ZZZZ','TRANS')

			--RAISERROR('CAN NOT DELETE CUSTOMER NO 10',16,1)
--NO Transaction will be commited if you put RAISERROR in the TRY block
		COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF XACT_STATE()!=0
   ROLLBACK TRANSACTION
END CATCH

SELECT * FROM Customers
WHERE CustomerNo=151;


EXECUTE sp_DelCus'11'

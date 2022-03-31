USE dndtech;
/*
CREATE CLUSTERED INDEX idx_CustomerFristName
ON Customers (FirstName);

DROP INDEX idx_CustomerFristName
ON Customers;
*/
----------------------Can not create more than one clastered index in one table-------
-------------------------------   PK is clastered Index--------------------------------

CREATE NONCLUSTERED INDEX idx_CustName
ON Customers(LastName);

CREATE NONCLUSTERED COLUMNSTORE INDEX idx_SuppNmCity
ON Suppliers(SupplierName, SupplierCity);

Execute dndtech.sys.sp_helpindex customers;
Execute sp_helpindex Suppliers;
create database bike_store
go
use bike_store

--CREATING SCHEMAS
CREATE SCHEMA Sales;
go

CREATE SCHEMA Prod;
go

-- CONTINUING SALES SCHEMAS;

DROP TABLE IF EXISTS Sales.Customers;
go
CREATE TABLE Sales.Customers
(
   customer_id int primary key
  ,first_name varchar(50)
  ,last_name varchar(50)
  ,phone varchar(50)
  ,email varchar(100)
  ,street varchar(100)
  ,city varchar(100)
  ,state varchar(50)
  ,zip_code int
);
go


DROP TABLE IF EXISTS Sales.Orders;
go
CREATE TABLE Sales.Orders
(
   order_id int primary key
  ,customer_id int 
  ,order_status int
  ,order_date datetime
  ,required_date datetime
  ,shipped_date datetime
  ,store_id int
  ,staff_id int
);
go

DROP TABLE IF EXISTS Sales.Staffs;
go
CREATE TABLE Sales.Staffs
(
   staff_id int primary key
  ,first_name varchar(50)
  ,last_name varchar(50)
  ,email varchar(100)
  ,phone varchar(50)
  ,active bit
  ,store_id int
  ,manager_id int
);
go



DROP TABLE IF EXISTS Sales.Stores
CREATE TABLE Sales.Stores
(
   store_id int primary key
  ,store_name varchar(100)
  ,phone varchar(50)
  ,email varchar(100)
  ,street varchar(100)
  ,city varchar(100)
  ,state varchar(50)
  ,zip_code int
);
go



DROP TABLE IF EXISTS Sales.Order_items;
go
CREATE TABLE Sales.Order_items
(
   order_id int 
  ,item_id int
  ,product_id int
  ,quantity int
  ,list_price decimal(10,2)
  ,discount decimal(4,2)
  ,primary key (order_id, item_id)
);
go



-- CONTINUING Prod (Production) SCHEMAS;

DROP TABLE IF EXISTS Prod.Categories;
go
CREATE TABLE Prod.Categories
(
	category_id int primary key,
	category_name varchar(100)
);
go


DROP TABLE IF EXISTS Prod.Brands;
go
CREATE TABLE Prod.Brands
(
	 brand_id int primary key
	,brand_name varchar(100)
);
go

DROP TABLE IF EXISTS Prod.Products;
go
CREATE TABLE Prod.Products
(
	 product_id int primary key
	,product_name varchar(100)
	,brand_id int
	,category_id int
	,model_year int
	,list_price decimal(10,2)
);
go

DROP TABLE IF EXISTS Prod.Stocks;
go
CREATE TABLE Prod.Stocks
(
	 store_id int
	,product_id int
	,quantity int
	,primary key (store_id, product_id)
);

go

-- FOREIGN KEYS (ALTER TABLE)

ALTER TABLE Sales.Orders
ADD FOREIGN KEY (customer_id) REFERENCES Sales.Customers(customer_id),
	FOREIGN KEY (store_id) REFERENCES Sales.Stores(store_id),
	FOREIGN KEY (staff_id) REFERENCES Sales.Staffs(staff_id)

go

ALTER TABLE Sales.Staffs
ADD FOREIGN KEY (store_id) REFERENCES Sales.Stores(store_id),
	FOREIGN KEY (manager_id) REFERENCES Sales.Staffs(staff_id);
go

ALTER TABLE Sales.Order_items
ADD FOREIGN KEY (order_id) REFERENCES Sales.Orders(order_id),
	FOREIGN KEY (product_id) REFERENCES Prod.Products(product_id);
go

ALTER TABLE Prod.Products
ADD FOREIGN KEY (brand_id) REFERENCES Prod.Brands(brand_id),
	FOREIGN KEY (category_id) REFERENCES Prod.Categories(category_id);
go

ALTER TABLE Prod.Stocks
ADD FOREIGN KEY (store_id) REFERENCES Sales.Stores(store_id),
	FOREIGN KEY (product_id) REFERENCES Prod.Products(product_id);
go
	

CREATE OR ALTER PROC sp_ImportingData
AS
BEGIN

/*
===============================================
TITLE		: Importing CSV data into Database
PURPOSE		: Bridge External CSV files int SQL Server using temp tables
DEVELOPER	: Ramazanova Sevinch
DATE		: 31.01.2026
===============================================
*/


	DECLARE @ExecTimeBegin datetime = getdate()
	DECLARE @ExecTimeEnd datetime
	

	-- SALES SCHEMA STAGING TABLES

	CREATE TABLE #_staging_Customers
	(
		 customer_id int,
		 first_name nvarchar(255),
		 last_name nvarchar(255),
		 phone nvarchar(255),
		 email nvarchar(255),
		 street nvarchar(255),
		 city nvarchar(255),
		 state nvarchar(255),
		 zip_code int
	);

	CREATE TABLE #_staging_Orders
	(
		 order_id int,
		 customer_id int,
		 order_status int,
		 order_date nvarchar(255),
		 required_date nvarchar(255),
		 shipped_date nvarchar(255),
		 store_id int,
		 staff_id int
	);

	CREATE TABLE #_staging_Staffs
	(
		 staff_id int,
		 first_name nvarchar(255),
		 last_name nvarchar(255),
		 email nvarchar(255),
		 phone nvarchar(255),
		 active int,
		 store_id int,
		 manager_id nvarchar(255)
	);

	CREATE TABLE #_staging_Stores
	(
		 store_id int,
		 store_name nvarchar(255),
		 phone nvarchar(255),
		 email nvarchar(255),
		 street nvarchar(255),
		 city nvarchar(255),
		 state nvarchar(255),
		 zip_code int
	);

	CREATE TABLE #_staging_Order_items
	(
		 order_id int,
		 item_id int,
		 product_id int,
		 quantity int,
		 list_price nvarchar(255),
		 discount nvarchar(255)
	);

	-- PROD SCHEMA STAGING TABLES

	CREATE TABLE #_staging_Categories
	(
		 category_id int,
		 category_name nvarchar(255)
	);

	CREATE TABLE #_staging_Brands
	(
		 brand_id int,
		 brand_name nvarchar(255)
	);

	CREATE TABLE #_staging_Products
	(
		 product_id int,
		 product_name nvarchar(255),
		 brand_id int,
		 category_id int,
		 model_year int,
		 list_price nvarchar(255)
	);

	CREATE TABLE #_staging_Stocks
	(
		 store_id int,
		 product_id int,
		 quantity int
	);


--===================================================================================================================================
--bulk indert data
--=================================================================================================================================

BULK INSERT #_Staging_customers
FROM 'C:\SQLData\source\customers.csv' 
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
	tablock
);

BULK INSERT #_Staging_orders
FROM 'C:\SQLData\source\orders.csv' 
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
	tablock
);

BULK INSERT #_Staging_staffs
FROM 'C:\SQLData\source\staffs.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
	tablock
);

BULK INSERT #_Staging_stores
FROM 'C:\SQLData\source\stores.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
	tablock
);

BULK INSERT #_Staging_order_items
FROM 'C:\SQLData\source\order_items.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
	tablock
);

BULK INSERT #_Staging_categories
FROM 'C:\SQLData\source\categories.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
	tablock
);

BULK INSERT #_Staging_products
FROM 'C:\SQLData\source\products.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
	tablock
);

BULK INSERT #_Staging_stocks
FROM 'C:\SQLData\source\stocks.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
	tablock
);

BULK INSERT #_Staging_brands
FROM 'C:\SQLData\source\brands.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
	tablock
);


--=========================================================================
--update null values
--===============================================================================

update #_Staging_Customers
set phone = null
where phone = 'null'

update #_Staging_Orders
set shipped_date= null
where shipped_date='null'

update #_Staging_Staffs
set manager_id=null
where manager_id='null'




MERGE Sales.Stores AS target
USING #_staging_Stores AS source
ON target.store_id = source.store_id
WHEN MATCHED THEN
	UPDATE SET
		store_name = source.store_name,
		phone = source.phone,
		email = source.email,
		street = source.street,
		city = source.city,
		state = source.state,
		zip_code = source.zip_code
WHEN NOT MATCHED THEN
	INSERT (store_id, store_name, phone, email, street, city, state, zip_code)
	VALUES (source.store_id, source.store_name, source.phone, source.email, source.street, source.city, source.state, source.zip_code);


-- 2. CATEGORIES
MERGE Prod.Categories AS target
USING #_staging_Categories AS source
ON target.category_id = source.category_id
WHEN MATCHED THEN
	UPDATE SET category_name = source.category_name
WHEN NOT MATCHED THEN
	INSERT (category_id, category_name)
	VALUES (source.category_id, source.category_name);


-- 3. BRANDS
MERGE Prod.Brands AS target
USING #_staging_Brands AS source
ON target.brand_id = source.brand_id
WHEN MATCHED THEN
	UPDATE SET brand_name = source.brand_name
WHEN NOT MATCHED THEN
	INSERT (brand_id, brand_name)
	VALUES (source.brand_id, source.brand_name);


-- 4. PRODUCTS
MERGE Prod.Products AS target
USING (
	SELECT product_id, product_name, brand_id, category_id, model_year,
		CAST(list_price AS DECIMAL(10,2)) AS list_price
	FROM #_staging_Products
) AS source
ON target.product_id = source.product_id
WHEN MATCHED THEN
	UPDATE SET
		product_name = source.product_name,
		brand_id = source.brand_id,
		category_id = source.category_id,
		model_year = source.model_year,
		list_price = source.list_price
WHEN NOT MATCHED THEN
	INSERT (product_id, product_name, brand_id, category_id, model_year, list_price)
	VALUES (source.product_id, source.product_name, source.brand_id, source.category_id, source.model_year, source.list_price);


-- 5. CUSTOMERS
MERGE Sales.Customers AS target
USING #_staging_Customers AS source
ON target.customer_id = source.customer_id
WHEN MATCHED THEN
	UPDATE SET
		first_name = source.first_name,
		last_name = source.last_name,
		phone = source.phone,
		email = source.email,
		street = source.street,
		city = source.city,
		state = source.state,
		zip_code = source.zip_code
WHEN NOT MATCHED THEN
	INSERT (customer_id, first_name, last_name, phone, email, street, city, state, zip_code)
	VALUES (source.customer_id, source.first_name, source.last_name, source.phone, source.email, source.street, source.city, source.state, source.zip_code);


-- 6. STAFFS
MERGE Sales.Staffs AS target
USING (
	SELECT staff_id, first_name, last_name, email, phone, active, store_id,
		CAST(CASE WHEN manager_id = 'NULL' then NULL else manager_id end AS INT) AS manager_id
	FROM #_staging_Staffs
) AS source
ON target.staff_id = source.staff_id
WHEN MATCHED THEN
	UPDATE SET
		first_name = source.first_name,
		last_name = source.last_name,
		email = source.email,
		phone = source.phone,
		active = source.active,
		store_id = source.store_id,
		manager_id = source.manager_id
WHEN NOT MATCHED THEN
	INSERT (staff_id, first_name, last_name, email, phone, active, store_id, manager_id)
	VALUES (source.staff_id, source.first_name, source.last_name, source.email, source.phone, source.active, source.store_id, source.manager_id);


-- 7. ORDERS
-- 7. ORDERS


MERGE Sales.Orders AS target
USING (
	SELECT
		order_id,
		MAX(customer_id) AS customer_id,
		MAX(order_status) AS order_status,
		MAX(CAST(NULLIF(order_date, 'NULL') AS DATETIME)) AS order_date,
		MAX(CAST(NULLIF(required_date, 'NULL') AS DATETIME)) AS required_date,
		MAX(CAST(NULLIF(shipped_date, 'NULL') AS DATETIME)) AS shipped_date,
		MAX(store_id) AS store_id,
		MAX(staff_id) AS staff_id
	FROM #_staging_Orders
	GROUP BY order_id
) AS source
ON target.order_id = source.order_id
WHEN MATCHED THEN
	UPDATE SET
		customer_id = source.customer_id,
		order_status = source.order_status,
		order_date = source.order_date,
		required_date = source.required_date,
		shipped_date = source.shipped_date,
		store_id = source.store_id,
		staff_id = source.staff_id
WHEN NOT MATCHED THEN
	INSERT (order_id, customer_id, order_status, order_date, required_date, shipped_date, store_id, staff_id)
	VALUES (source.order_id, source.customer_id, source.order_status, source.order_date, source.required_date, source.shipped_date, source.store_id, source.staff_id);



-- 8. ORDER ITEMS
MERGE Sales.Order_items AS target
USING (
	SELECT
		oi.order_id,
		oi.item_id,
		oi.product_id,
		oi.quantity,
		CAST(oi.list_price AS DECIMAL(10,2)) AS list_price,
		CAST(oi.discount AS DECIMAL(4,2)) AS discount
	FROM #_staging_Order_items oi
	INNER JOIN Sales.Orders o
		ON oi.order_id = o.order_id
) AS source
ON target.order_id = source.order_id
AND target.item_id = source.item_id
WHEN MATCHED THEN
	UPDATE SET
		product_id = source.product_id,
		quantity = source.quantity,
		list_price = source.list_price,
		discount = source.discount
WHEN NOT MATCHED THEN
	INSERT (order_id, item_id, product_id, quantity, list_price, discount)
	VALUES (source.order_id, source.item_id, source.product_id, source.quantity, source.list_price, source.discount);


-- 9. STOCKS
MERGE Prod.Stocks AS target
USING #_staging_Stocks AS source
ON target.store_id = source.store_id AND target.product_id = source.product_id
WHEN MATCHED THEN
	UPDATE SET quantity = source.quantity
WHEN NOT MATCHED THEN
	INSERT (store_id, product_id, quantity)
	VALUES (source.store_id, source.product_id, source.quantity);

		-- Execution time log
	SET @ExecTimeEnd = getdate()
	PRINT ' '
	PRINT '==============================================='
	PRINT 'Execution Time (Millisecond):' + CAST(DATEDIFF(millisecond,@ExecTimeBegin ,@ExecTimeEnd) as varchar(10));

END


exec sp_ImportingData

	--Creating views

CREATE VIEW vw_store_sales_summary AS
SELECT
	s.store_id,
	s.store_name,
	COUNT(DISTINCT o.order_id) AS total_orders,
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales
FROM Sales.Orders o
JOIN Sales.Order_items oi ON o.order_id = oi.order_id
JOIN Sales.Stores s ON o.store_id = s.store_id
GROUP BY
	s.store_id,
	s.store_name;

SELECT * FROM vw_store_sales_summary WHERE store_id = 1;



CREATE VIEW vw_top_selling_products AS
SELECT
	p.product_id,
	p.product_name,
	SUM(oi.quantity) AS total_quantity_sold,
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales
FROM Sales.Order_items oi
JOIN Prod.Products p ON oi.product_id = p.product_id
GROUP BY
	p.product_id,
	p.product_name;

	SELECT * FROM vw_top_selling_products
ORDER BY total_sales DESC;


CREATE VIEW vw_inventory_status AS
SELECT
	s.store_name,
	p.product_name,
	st.quantity,
	CASE
		WHEN st.quantity = 0 THEN 'Out of Stock'
		WHEN st.quantity < 5 THEN 'Low Stock'
		ELSE 'In Stock'
	END AS stock_status
FROM Prod.Stocks st
JOIN Prod.Products p ON st.product_id = p.product_id
JOIN Sales.Stores s ON st.store_id = s.store_id;

SELECT * FROM vw_inventory_status WHERE stock_status = 'Low Stock';


CREATE VIEW vw_staff_performance AS
SELECT
	st.staff_id,
	st.first_name + ' ' + st.last_name AS staff_name,
	COUNT(DISTINCT o.order_id) AS total_orders,
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales
FROM Sales.Orders o
JOIN Sales.Order_items oi ON o.order_id = oi.order_id
JOIN Sales.Staffs st ON o.staff_id = st.staff_id
GROUP BY
	st.staff_id,
	st.first_name,
	st.last_name;

SELECT * FROM vw_staff_performance ORDER BY total_sales DESC;



CREATE VIEW vw_regional_trends AS
SELECT
	c.state,
	c.city,
	COUNT(DISTINCT o.order_id) AS total_orders,
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales
FROM Sales.Customers c
JOIN Sales.Orders o ON c.customer_id = o.customer_id
JOIN Sales.Order_items oi ON o.order_id = oi.order_id
GROUP BY
	c.state,
	c.city;

SELECT * FROM vw_regional_trends WHERE state = 'CA';


CREATE VIEW vw_sales_by_category AS
SELECT
	c.category_name,
	SUM(oi.quantity) AS total_quantity_sold,
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales
FROM Sales.Order_items oi
JOIN Prod.Products p ON oi.product_id = p.product_id
JOIN Prod.Categories c ON p.category_id = c.category_id
GROUP BY
	c.category_name;

SELECT * FROM vw_sales_by_category ORDER BY total_sales DESC;


--Stored procedure

CREATE PROCEDURE sp_store_kpi
    @StoreID INT,
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT
        s.store_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales,
        AVG(oi.quantity * oi.list_price * (1 - oi.discount)) AS avg_order_value,
        SUM(oi.quantity) AS total_items_sold
    FROM Sales.Orders o
    JOIN Sales.Order_items oi ON o.order_id = oi.order_id
    JOIN Sales.Stores s ON o.store_id = s.store_id
    WHERE o.store_id = @StoreID
      AND o.order_date BETWEEN @StartDate AND @EndDate
    GROUP BY s.store_name;
END;

EXEC sp_store_kpi 1, '2023-01-01', '2023-12-31';


CREATE PROCEDURE sp_restock_list
    @StoreID INT,
    @MinQuantity INT
AS
BEGIN
    SELECT
        s.store_name,
        p.product_name,
        st.quantity AS current_quantity,
        CASE 
            WHEN st.quantity = 0 THEN 'Out of Stock'
            WHEN st.quantity <= @MinQuantity THEN 'Low Stock'
            ELSE 'In Stock'
        END AS restock_status
    FROM Prod.Stocks st
    JOIN Prod.Products p ON st.product_id = p.product_id
    JOIN Sales.Stores s ON st.store_id = s.store_id
    WHERE st.store_id = @StoreID
      AND st.quantity <= @MinQuantity
    ORDER BY st.quantity ASC;
END;

EXEC sp_restock_list 1, 5;


CREATE PROCEDURE sp_year_comparison
    @Year1 INT,
    @Year2 INT
AS
BEGIN
    SELECT
        YEAR(o.order_date) AS year,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales
    FROM Sales.Orders o
    JOIN Sales.Order_items oi ON o.order_id = oi.order_id
    WHERE YEAR(o.order_date) IN (@Year1, @Year2)
    GROUP BY YEAR(o.order_date)
    ORDER BY year;
END;

EXEC sp_year_comparison 2022, 2023;

CREATE PROCEDURE sp_customer_profile
    @CustomerID INT
AS
BEGIN
    SELECT
        c.first_name + ' ' + c.last_name AS customer_name,
        c.city,
        c.state,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent,
        MAX(o.order_date) AS last_order_date
    FROM Sales.Customers c
    LEFT JOIN Sales.Orders o ON c.customer_id = o.customer_id
    LEFT JOIN Sales.Order_items oi ON o.order_id = oi.order_id
    WHERE c.customer_id = @CustomerID
    GROUP BY c.first_name, c.last_name, c.city, c.state;
END;

EXEC sp_customer_profile 259;

select * from Sales.Customers

---Total Revenue
--Orders and Order items
SELECT SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM Sales.Orders o
JOIN Sales.Order_items oi ON o.order_id = oi.order_id;

--AOV (Average Order Value)
-- Orders, Order_items
SELECT
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) / COUNT(DISTINCT o.order_id) AS AOV
FROM Sales.Orders o
JOIN Sales.Order_items oi ON o.order_id = oi.order_id;

--Inventory turnover
-- Tables: Stocks, Order_items
-- Formula: Inventory Turnover = Total Sold / Average Inventory

-- Tables: Stocks, Order_items
-- Formula: Inventory Turnover = Total Sold / Average Inventory

SELECT
    SUM(oi.quantity) / NULLIF(AVG(s.quantity),0) AS inventory_turnover
FROM Prod.Stocks s
JOIN Sales.Order_items oi ON s.product_id = oi.product_id
WHERE s.store_id = 1; 

----Revenue by Store
-- Tables: Orders, Order_items, Stores
SELECT
    st.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
FROM Sales.Orders o
JOIN Sales.Order_items oi ON o.order_id = oi.order_id
JOIN Sales.Stores st ON o.store_id = st.store_id
GROUP BY st.store_name
ORDER BY revenue DESC;

---Profit by category
-- Tables: Products, Categories, Order_items
-- Formula: Profit = SUM(quantity * (list_price))
select a.category_name,
SUM(oi.quantity * oi.list_price * (1-oi.discount))
as profit_category from Sales.Order_items oi join
Prod.Products p on oi.product_id=p.product_id
join Prod.Categories as a on p.category_id=a.category_id
group by a.category_name
order by profit_category


----Sales by brand
-- Tables: Products, Order_items

select p.brand_id,
SUM(quantity* oi.list_price *(1-discount)) as sales
from Prod.Products as p 
join Sales.Order_items as oi
on p.product_id=oi.product_id
group by p.brand_id
order by sales desc


---Staff contribution

-- Tables: Orders, Order_items, Staffs

select 
CONCAT(first_name, ' ', last_name) AS full_name,
SUM(quantity*list_price*(1-discount)) as sales
from Sales.Orders as o join Sales.Order_items as oi
on o.order_id = oi.order_id join Sales.Staffs as s
on s.staff_id = o.staff_id
group by s.first_name, s.last_name
order by sales

select * from Sales.KPI_Results
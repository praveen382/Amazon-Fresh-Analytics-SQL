CREATE DATABASE AmazonFresh;
USE AmazonFresh;
SELECT * FROM AmazonFresh.customers limit 10;
SELECT * FROM products LIMIT 10;
ALTER TABLE customers
CHANGE COLUMN `ï»¿CustomerID` CustomerID VARCHAR(50) NOT NULL;
ALTER TABLE customers
ADD PRIMARY KEY (CustomerID);
SHOW KEYS FROM customers;

ALTER TABLE orders
CHANGE COLUMN `ï»¿OrderID` OrderID VARCHAR(50) NOT NULL;

ALTER TABLE orders
CHANGE COLUMN CustomerID CustomerID VARCHAR(50) NOT NULL;

ALTER TABLE orders
ADD PRIMARY KEY (OrderID);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (CustomerID)
REFERENCES customers(CustomerID);

ALTER TABLE products
CHANGE COLUMN `ï»¿ProductID` ProductID VARCHAR(50) NOT NULL;

ALTER TABLE products
ADD PRIMARY KEY (ProductID);

ALTER TABLE suppliers
CHANGE COLUMN `ï»¿SupplierID` SupplierID VARCHAR(50) NOT NULL;

ALTER TABLE suppliers
ADD PRIMARY KEY (SupplierID);

ALTER TABLE reviews
CHANGE COLUMN `ï»¿ReviewID` ReviewID VARCHAR(50) NOT NULL;

ALTER TABLE reviews
ADD PRIMARY KEY (ReviewID);

ALTER TABLE order_details
CHANGE COLUMN `ï»¿OrderID` OrderID VARCHAR(50) NOT NULL;

ALTER TABLE products
ADD CONSTRAINT fk_products_suppliers
FOREIGN KEY (SupplierID)
REFERENCES suppliers(SupplierID);
ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_customers
FOREIGN KEY (CustomerID)
REFERENCES customers(CustomerID);
ALTER TABLE products
MODIFY SupplierID VARCHAR(50) NOT NULL;

ALTER TABLE products
MODIFY ProductID VARCHAR(50) NOT NULL;

ALTER TABLE suppliers
MODIFY SupplierID VARCHAR(50) NOT NULL;

ALTER TABLE reviews
MODIFY CustomerID VARCHAR(50) NOT NULL;

ALTER TABLE reviews
MODIFY ProductID VARCHAR(50) NOT NULL;

ALTER TABLE reviews
MODIFY ReviewID VARCHAR(50) NOT NULL;

ALTER TABLE order_details
MODIFY OrderID VARCHAR(50) NOT NULL;

ALTER TABLE order_details
MODIFY ProductID VARCHAR(50) NOT NULL;

SHOW COLUMNS FROM products;
SHOW COLUMNS FROM suppliers;
SHOW COLUMNS FROM reviews;
SHOW COLUMNS FROM order_details;

SHOW COLUMNS FROM products;
SHOW COLUMNS FROM suppliers;

ALTER TABLE products
MODIFY SupplierID VARCHAR(50) NOT NULL;
SHOW COLUMNS FROM products;
ALTER TABLE products
ADD CONSTRAINT fk_products_suppliers
FOREIGN KEY (SupplierID)
REFERENCES suppliers(SupplierID);

SELECT DISTINCT p.SupplierID
FROM products p
LEFT JOIN suppliers s
ON p.SupplierID = s.SupplierID
WHERE s.SupplierID IS NULL;
UPDATE products
SET SupplierID = (
    SELECT SupplierID
    FROM suppliers
    LIMIT 1
)
WHERE SupplierID NOT IN (
    SELECT SupplierID
    FROM suppliers
);


SET SQL_SAFE_UPDATES = 0;

UPDATE products
SET SupplierID = (SELECT SupplierID FROM suppliers LIMIT 1)
WHERE SupplierID NOT IN (SELECT SupplierID FROM suppliers);

ALTER TABLE products
ADD CONSTRAINT fk_products_suppliers
FOREIGN KEY (SupplierID)
REFERENCES suppliers(SupplierID);

ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_customers
FOREIGN KEY (CustomerID)
REFERENCES customers(CustomerID);

ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_products
FOREIGN KEY (ProductID)
REFERENCES products(ProductID);

ALTER TABLE order_details
ADD CONSTRAINT fk_orderdetails_orders
FOREIGN KEY (OrderID)
REFERENCES orders(OrderID);

ALTER TABLE order_details
ADD CONSTRAINT fk_orderdetails_products
FOREIGN KEY (ProductID)
REFERENCES products(ProductID);

SELECT 
TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'amazonfresh'
AND REFERENCED_TABLE_NAME IS NOT NULL;

SELECT *
FROM customers
WHERE City = 'Patelberg';

SELECT *
FROM products
WHERE Category = 'Fruits';

CREATE TABLE Customers_New (
    CustomerID VARCHAR(50) PRIMARY KEY,
    Name VARCHAR(100) UNIQUE,
    Age INT NOT NULL,
    Gender VARCHAR(20),
    City VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50),
    SignupDate DATE,
    PrimeMember VARCHAR(10) DEFAULT 'No',
    CHECK (Age > 18)
);

DESCRIBE Customers_New;

SELECT SupplierID
FROM suppliers
LIMIT 5;

INSERT INTO products
(ProductID, ProductName, Category, SubCategory, PricePerUnit, StockQuantity, SupplierID)
VALUES
('P1001','Apple','Fruits','Fresh Fruits',120,100,'SUPPLIER_ID_HERE'),
('P1002','Banana','Fruits','Fresh Fruits',60,150,'SUPPLIER_ID_HERE'),
('P1003','Orange','Fruits','Fresh Fruits',90,120,'SUPPLIER_ID_HERE');

SELECT SupplierID
FROM suppliers
LIMIT 5;

INSERT INTO products
(ProductID, ProductName, Category, SubCategory, PricePerUnit, StockQuantity, SupplierID)
VALUES
('P1001','Apple','Fruits','Fresh Fruits',120,100,'0d3f07e6-1f78-42a5-bd75-222b54081020'),
('P1002','Banana','Fruits','Fresh Fruits',60,150,'0d3f07e6-1f78-42a5-bd75-222b54081020'),
('P1003','Orange','Fruits','Fresh Fruits',90,120,'0d3f07e6-1f78-42a5-bd75-222b54081020');

SELECT *
FROM products
WHERE ProductID IN ('P1001','P1002','P1003');

UPDATE products
SET StockQuantity = 200
WHERE ProductID = 'P1001';

SELECT ProductID, ProductName, StockQuantity
FROM products
WHERE ProductID = 'P1001';

SELECT DISTINCT City
FROM suppliers;

SELECT *
FROM suppliers
WHERE City = 'Mumbai';

SELECT City, COUNT(*) AS TotalSuppliers
FROM suppliers
GROUP BY City
LIMIT 10;

SELECT *
FROM suppliers
WHERE City = 'South Ana';

DELETE FROM suppliers
WHERE City = 'South Ana';

DELETE FROM suppliers
WHERE City = 'South Ana';

ALTER TABLE reviews
ADD CONSTRAINT chk_rating
CHECK (Rating BETWEEN 1 AND 5);

ALTER TABLE customers
MODIFY PrimeMember VARCHAR(10) DEFAULT 'No';

SHOW CREATE TABLE customers;

SELECT *
FROM orders
WHERE OrderDate > '2024-01-01';

SELECT 
    p.ProductID,
    p.ProductName,
    AVG(r.Rating) AS AverageRating
FROM products p
JOIN reviews r
ON p.ProductID = r.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING AVG(r.Rating) > 4;

SELECT 
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS TotalQuantitySold,
    SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM products p
JOIN order_details od
ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalSales DESC;

SELECT 
    c.CustomerID,
    c.Name,
    c.City,
    SUM(o.OrderAmount) AS TotalSpending
FROM customers c
JOIN orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name, c.City
HAVING SUM(o.OrderAmount) > 5000
ORDER BY TotalSpending DESC;

SELECT
    c.CustomerID,
    c.Name,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(o.OrderAmount) AS TotalSpent
FROM customers c
INNER JOIN orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name
ORDER BY TotalSpent DESC;

SELECT
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS TotalQuantitySold,
    SUM(od.Quantity * od.UnitPrice) AS Revenue
FROM products p
INNER JOIN order_details od
ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY Revenue DESC;

SELECT
    s.SupplierID,
    s.SupplierName,
    COUNT(p.ProductID) AS TotalProducts
FROM suppliers s
INNER JOIN products p
ON s.SupplierID = p.SupplierID
GROUP BY s.SupplierID, s.SupplierName
ORDER BY TotalProducts DESC;

CREATE TABLE product_categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    Category VARCHAR(100),
    SubCategory VARCHAR(100),
    UNIQUE (Category, SubCategory)
);
INSERT INTO product_categories (Category, SubCategory)
SELECT DISTINCT Category, SubCategory
FROM products;
ALTER TABLE products
ADD COLUMN CategoryID INT;

UPDATE products p
JOIN product_categories pc
ON p.Category = pc.Category
AND p.SubCategory = pc.SubCategory
SET p.CategoryID = pc.CategoryID;

SELECT 
    ProductID,
    ProductName,
    TotalRevenue
FROM (
    SELECT
        p.ProductID,
        p.ProductName,
        SUM(od.Quantity * od.UnitPrice) AS TotalRevenue
    FROM products p
    JOIN order_details od
    ON p.ProductID = od.ProductID
    GROUP BY p.ProductID, p.ProductName
) AS product_sales
ORDER BY TotalRevenue DESC
LIMIT 3;
SELECT
    CustomerID,
    Name,
    City
FROM customers
WHERE CustomerID NOT IN (
    SELECT CustomerID
    FROM orders
);
SELECT
    City,
    COUNT(*) AS PrimeMemberCount
FROM customers
WHERE PrimeMember = 'Yes'
GROUP BY City
ORDER BY PrimeMemberCount DESC;

SELECT
    p.Category,
    SUM(od.Quantity) AS TotalOrdered
FROM products p
JOIN order_details od
ON p.ProductID = od.ProductID
GROUP BY p.Category
ORDER BY TotalOrdered DESC
LIMIT 3;
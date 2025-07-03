CREATE DATABASE StoreDB;
USE StoreDB;

-- Categories table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100)
);

-- Suppliers table
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100),
    ContactEmail VARCHAR(100)
);

-- Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2),
    CategoryID INT,
    SupplierID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Categories
INSERT INTO Categories VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Home Appliances');

-- Suppliers
INSERT INTO Suppliers VALUES
(1, 'TechSource', 'contact@techsource.com'),
(2, 'BookWorld', 'support@bookworld.com'),
(3, 'HomeEssentials', 'info@homeessentials.com');

-- Products
INSERT INTO Products VALUES
(101, 'Smartphone X', 699.99, 1, 1),
(102, 'Laptop Pro', 1199.50, 1, 1),
(103, 'Blender 3000', 89.99, 3, 3),
(104, 'Air Fryer Max', 129.99, 3, 3),
(105, 'Mystery Novel', 15.99, 2, 2),
(106, 'Science Textbook', 45.00, 2, 2),
(107, 'Wireless Earbuds', 149.99, 1, 1),
(108, 'E-reader', 99.99, 2, 2);

SELECT P.ProductName, P.Price
FROM Products P
JOIN Categories C ON P.CategoryID = C.CategoryID
WHERE C.CategoryName = 'Electronics';

SELECT ProductName, Price
FROM Products
WHERE Price BETWEEN 50 AND 150;

SELECT P.ProductName, P.Price
FROM Products P
JOIN Suppliers S ON P.SupplierID = S.SupplierID
WHERE S.SupplierName = 'BookWorld';

SELECT ProductName, Price
FROM Products
ORDER BY Price DESC
LIMIT 5;
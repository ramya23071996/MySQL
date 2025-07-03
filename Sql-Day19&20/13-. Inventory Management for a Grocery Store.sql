-- Create the database
CREATE DATABASE IF NOT EXISTS GroceryDB;
USE GroceryDB;

-- Drop tables if they already exist
DROP TABLE IF EXISTS Stock;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Suppliers;

-- Create Suppliers table
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100),
    ContactEmail VARCHAR(100)
);

-- Create Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    SupplierID INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Create Stock table
CREATE TABLE Stock (
    StockID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT,
    Quantity INT,
    ReorderThreshold INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert sample suppliers
INSERT INTO Suppliers VALUES
(1, 'FreshFarms', 'contact@freshfarms.com'),
(2, 'DailyGrocers', 'support@dailygrocers.com'),
(3, 'GreenHarvest', 'info@greenharvest.com');

-- Insert sample products
INSERT INTO Products VALUES
(101, 'Apples', 'Fruits', 1),
(102, 'Bananas', 'Fruits', 1),
(103, 'Milk', 'Dairy', 2),
(104, 'Bread', 'Bakery', 2),
(105, 'Eggs', 'Dairy', 2),
(106, 'Tomatoes', 'Vegetables', 3),
(107, 'Potatoes', 'Vegetables', 3),
(108, 'Onions', 'Vegetables', 3),
(109, 'Carrots', 'Vegetables', 3),
(110, 'Spinach', 'Vegetables', 3);

-- Insert stock levels
INSERT INTO Stock (ProductID, Quantity, ReorderThreshold) VALUES
(101, 20, 10),
(102, 5, 10),
(103, 15, 10),
(104, 2, 5),
(105, 30, 20),
(106, 8, 10),
(107, 50, 25),
(108, 3, 10),
(109, 12, 10),
(110, 6, 10);

-- Query 1: Low-stock products (below threshold)
SELECT P.ProductName, S.Quantity, S.ReorderThreshold
FROM Stock S
JOIN Products P ON S.ProductID = P.ProductID
WHERE S.Quantity < S.ReorderThreshold;

-- Query 2: Suppliers providing more than 5 products
SELECT Sup.SupplierName, COUNT(*) AS ProductCount
FROM Products P
JOIN Suppliers Sup ON P.SupplierID = Sup.SupplierID
GROUP BY Sup.SupplierID
HAVING ProductCount > 5;
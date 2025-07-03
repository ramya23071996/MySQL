-- Create the database
CREATE DATABASE IF NOT EXISTS ECommerceDB;
USE ECommerceDB;

-- Drop tables if they already exist (for reusability)
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100)
);

-- Create Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2)
);

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate DATE,
    Status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled'),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Create OrderItems table
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert sample customers
INSERT INTO Customers VALUES
(1, 'Aarav Mehta', 'aarav@example.com'),
(2, 'Diya Sharma', 'diya@example.com');

-- Insert sample products
INSERT INTO Products VALUES
(101, 'Wireless Mouse', 25.00),
(102, 'Keyboard', 45.00),
(103, 'USB-C Cable', 10.00),
(104, 'Laptop Stand', 35.00);

-- Insert sample orders
INSERT INTO Orders (CustomerID, OrderDate, Status) VALUES
(1, '2025-07-01', 'Pending'),
(1, '2025-06-15', 'Delivered'),
(2, '2025-07-02', 'Shipped');

-- Insert sample order items
INSERT INTO OrderItems (OrderID, ProductID, Quantity) VALUES
(1, 101, 2),
(1, 103, 1),
(2, 102, 1),
(2, 103, 10),
(3, 104, 1),
(3, 103, 5);

-- Query 1: Pending orders
SELECT O.OrderID, C.Name, O.OrderDate
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
WHERE O.Status = 'Pending';

-- Query 2: Order history for a customer (e.g., Aarav Mehta)
SELECT O.OrderID, O.OrderDate, O.Status, P.ProductName, OI.Quantity
FROM Orders O
JOIN OrderItems OI ON O.OrderID = OI.OrderID
JOIN Products P ON OI.ProductID = P.ProductID
JOIN Customers C ON O.CustomerID = C.CustomerID
WHERE C.Name = 'Aarav Mehta'
ORDER BY O.OrderDate DESC;

-- Query 3: Products ordered more than 10 times
SELECT P.ProductName, SUM(OI.Quantity) AS TotalOrdered
FROM OrderItems OI
JOIN Products P ON OI.ProductID = P.ProductID
GROUP BY OI.ProductID
HAVING TotalOrdered > 10;
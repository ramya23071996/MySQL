-- 🛒 Create Database and Tables
CREATE DATABASE IF NOT EXISTS RetailDB;
USE RetailDB;

-- Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL
);

-- Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

-- Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- OrderItems table
CREATE TABLE OrderItems (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 📝 Insert Sample Data
INSERT INTO Customers VALUES 
(1, 'Ramya'), (2, 'Arun'), (3, 'Priya');

INSERT INTO Products VALUES 
(101, 'Laptop', 75000.00),
(102, 'Mouse', 500.00),
(103, 'Keyboard', 1500.00),
(104, 'Monitor', 12000.00);

INSERT INTO Orders VALUES 
(1001, 1, '2025-07-06'),
(1002, 2, '2025-07-06'),
(1003, 1, '2025-07-07'),
(1004, 3, '2025-07-07');

INSERT INTO OrderItems VALUES 
(1, 1001, 101, 1),
(2, 1001, 102, 2),
(3, 1002, 103, 1),
(4, 1003, 104, 1),
(5, 1003, 102, 1),
(6, 1004, 101, 1),
(7, 1004, 103, 2);

-- 📦 JOIN: Complete Order Summaries
SELECT o.order_id, o.order_date, c.customer_name, p.product_name, oi.quantity, (p.price * oi.quantity) AS total_price
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
ORDER BY o.order_date, c.customer_name;

-- 💰 Total Sales Per Day
SELECT o.order_date, 
       COUNT(DISTINCT o.order_id) AS total_orders,
       SUM(p.price * oi.quantity) AS total_sales
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
GROUP BY o.order_date;

-- 🏆 Best-Selling Products (by quantity)
SELECT product_name, total_qty
FROM (
    SELECT p.product_name, SUM(oi.quantity) AS total_qty
    FROM OrderItems oi
    JOIN Products p ON oi.product_id = p.product_id
    GROUP BY p.product_name
) AS product_sales
WHERE total_qty = (
    SELECT MAX(total_qty)
    FROM (
        SELECT SUM(quantity) AS total_qty
        FROM OrderItems
        GROUP BY product_id
    ) AS totals
);

-- 🔍 DISTINCT Customers and Order Dates
SELECT DISTINCT c.customer_name, o.order_date
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_name, o.order_date;
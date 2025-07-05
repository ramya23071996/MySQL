--  Drop existing tables if they exist
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

--  Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

--  Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    stock INT NOT NULL CHECK (stock >= 0)
);

--  Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

--  Create OrderItems table
CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

--  Insert sample customers
INSERT INTO Customers (name, email) VALUES
('Aanya Kapoor', 'aanya@example.com'),
('Rohit Singh', 'rohit@example.com');

-- Insert sample products
INSERT INTO Products (product_name, price, stock) VALUES
('Bluetooth Speaker', 1500.00, 20),
('Smart Watch', 3500.00, 15),
('USB Cable', 200.00, 50);

--  Insert sample orders
INSERT INTO Orders (customer_id, order_date) VALUES
(1, '2025-07-10'),
(2, '2025-07-11'),
(1, '2025-07-12');

--  Insert sample order items
INSERT INTO OrderItems (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 1);

--  JOIN: Get customer order details
SELECT c.name AS customer_name, o.order_id, p.product_name, oi.quantity
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id;

--  SUM(): Calculate total amount per order
SELECT o.order_id, SUM(p.price * oi.quantity) AS total_amount
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
GROUP BY o.order_id;

-- 🔍 Filter products by price range and availability
SELECT * FROM Products
WHERE price BETWEEN 500 AND 4000 AND stock IS NOT NULL;

--  FULL OUTER JOIN simulation: Orders with and without items
SELECT o.order_id, oi.order_item_id, oi.product_id
FROM Orders o
LEFT JOIN OrderItems oi ON o.order_id = oi.order_id
UNION
SELECT o.order_id, oi.order_item_id, oi.product_id
FROM Orders o
RIGHT JOIN OrderItems oi ON o.order_id = oi.order_id;

--  Subquery: Top-selling products by quantity
SELECT product_id, product_name
FROM Products
WHERE product_id IN (
    SELECT product_id
    FROM OrderItems
    GROUP BY product_id
    ORDER BY SUM(quantity) DESC
    LIMIT 1
);
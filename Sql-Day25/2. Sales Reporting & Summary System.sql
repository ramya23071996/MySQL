-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS RetailDB;
USE RetailDB;

-- Step 2: Create tables
CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS Sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    product_id INT,
    quantity INT,
    sale_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE IF NOT EXISTS SalesLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_id INT,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action VARCHAR(50)
);

-- Step 3: Insert sample customers
INSERT INTO Customers (customer_name) VALUES
('Aarav'), ('Diya'), ('Rohan'), ('Meera'), ('Karan'),
('Sneha'), ('Vikram'), ('Anjali'), ('Rahul'), ('Priya'),
('Neha'), ('Arjun'), ('Ishita'), ('Manav'), ('Tanya'),
('Yash'), ('Pooja'), ('Nikhil'), ('Ritika'), ('Sahil'),
('Divya'), ('Amit'), ('Kavya'), ('Harsh'), ('Simran'),
('Ravi'), ('Bhavna'), ('Deepak'), ('Ayesha'), ('Gaurav'),
('Naina'), ('Suresh'), ('Lavanya'), ('Tarun'), ('Ira'),
('Mohit'), ('Rekha'), ('Ajay'), ('Pallavi'), ('Kriti'),
('Dev'), ('Shreya'), ('Ramesh'), ('Anita'), ('Vikas'),
('Maya'), ('Nitin'), ('Preeti'), ('Raj'), ('Swati');

-- Step 4: Insert sample products
INSERT INTO Products (product_name, price) VALUES
('Laptop', 55000), ('Smartphone', 25000), ('Tablet', 18000),
('Headphones', 3000), ('Monitor', 12000);

-- Step 5: Insert 50 sales records
INSERT INTO Sales (customer_id, product_id, quantity, sale_date) VALUES
(1, 1, 1, '2024-01-10'), (2, 2, 2, '2024-01-15'), (3, 3, 1, '2024-01-20'),
(4, 4, 3, '2024-01-25'), (5, 5, 1, '2024-02-01'), (6, 1, 1, '2024-02-05'),
(7, 2, 2, '2024-02-10'), (8, 3, 1, '2024-02-15'), (9, 4, 2, '2024-02-20'),
(10, 5, 1, '2024-02-25'), (11, 1, 1, '2024-03-01'), (12, 2, 2, '2024-03-05'),
(13, 3, 1, '2024-03-10'), (14, 4, 3, '2024-03-15'), (15, 5, 1, '2024-03-20'),
(16, 1, 1, '2024-03-25'), (17, 2, 2, '2024-04-01'), (18, 3, 1, '2024-04-05'),
(19, 4, 2, '2024-04-10'), (20, 5, 1, '2024-04-15'), (21, 1, 1, '2024-04-20'),
(22, 2, 2, '2024-04-25'), (23, 3, 1, '2024-05-01'), (24, 4, 3, '2024-05-05'),
(25, 5, 1, '2024-05-10'), (26, 1, 1, '2024-05-15'), (27, 2, 2, '2024-05-20'),
(28, 3, 1, '2024-05-25'), (29, 4, 2, '2024-06-01'), (30, 5, 1, '2024-06-05'),
(31, 1, 1, '2024-06-10'), (32, 2, 2, '2024-06-15'), (33, 3, 1, '2024-06-20'),
(34, 4, 3, '2024-06-25'), (35, 5, 1, '2024-07-01'), (36, 1, 1, '2024-07-05'),
(37, 2, 2, '2024-07-10'), (38, 3, 1, '2024-07-15'), (39, 4, 2, '2024-07-20'),
(40, 5, 1, '2024-07-25'), (41, 1, 1, '2024-08-01'), (42, 2, 2, '2024-08-05'),
(43, 3, 1, '2024-08-10'), (44, 4, 3, '2024-08-15'), (45, 5, 1, '2024-08-20'),
(46, 1, 1, '2024-08-25'), (47, 2, 2, '2024-09-01'), (48, 3, 1, '2024-09-05'),
(49, 4, 2, '2024-09-10'), (50, 5, 1, '2024-09-15');

-- Step 6: Create Monthly Sales Summary View
CREATE OR REPLACE VIEW MonthlySalesSummary AS
SELECT 
    DATE_FORMAT(sale_date, '%Y-%m') AS sale_month,
    SUM(p.price * s.quantity) AS total_sales
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY sale_month
ORDER BY sale_month;

-- Step 7: Create Function to get total sales for a product
DELIMITER //
CREATE FUNCTION TotalSalesByProduct(prod_id INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(p.price * s.quantity) INTO total
    FROM Sales s
    JOIN Products p ON s.product_id = p.product_id
    WHERE s.product_id = prod_id;
    RETURN IFNULL(total, 0);
END;
//
DELIMITER ;

-- Step 8: Create Procedure to show top 10 customers by order value
DELIMITER //
CREATE PROCEDURE Top10CustomersBySales()
BEGIN
    SELECT 
        c.customer_id,
        c.customer_name,
        SUM(p.price * s.quantity) AS total_spent
    FROM Sales s
    JOIN Customers c ON s.customer_id = c.customer_id
    JOIN Products p ON s.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name
    ORDER BY total_spent DESC
    LIMIT 10;
END;
//
DELIMITER ;

-- Step 9: Create Trigger to log new sales
DELIMITER //
CREATE TRIGGER LogNewSale
AFTER INSERT ON Sales
FOR EACH ROW
BEGIN
    INSERT INTO SalesLog(sale_id, action)
    VALUES (NEW.sale_id, 'INSERT');
END;
//
DELIMITER ;

-- Step 10: Role-Based Views
-- Manager View: Full access
CREATE OR REPLACE VIEW ManagerSalesView AS
SELECT 
    s.sale_id, c.customer_name, p.product_name, s.quantity, p.price, 
    (p.price * s.quantity) AS total, s.sale_date
FROM Sales s
JOIN Customers c ON s.customer_id = c.customer_id
JOIN Products p ON s.product_id = p.product_id;

-- Clerk View: Limited access
CREATE OR REPLACE VIEW ClerkSalesView AS
SELECT 
    s.sale_id, c.customer_name, p.product_name, s.quantity, s.sale_date
FROM Sales s
JOIN Customers c ON s.customer_id = c.customer_id
JOIN Products p ON s.product_id = p.product_id;
-- 🛍️ Create Database and Tables
CREATE DATABASE IF NOT EXISTS LoyaltyDB;
USE LoyaltyDB;

-- Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL
);

-- Purchases table
CREATE TABLE Purchases (
    purchase_id INT PRIMARY KEY,
    customer_id INT,
    purchase_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Points table
CREATE TABLE Points (
    point_id INT PRIMARY KEY,
    customer_id INT,
    earned_points INT NOT NULL CHECK (earned_points >= 0),
    transaction_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- 📝 Insert Sample Data
INSERT INTO Customers VALUES 
(1, 'Ramya'), (2, 'Arun'), (3, 'Priya');

INSERT INTO Purchases VALUES 
(101, 1, '2025-07-01', 5000.00),
(102, 2, '2025-07-02', 3000.00),
(103, 1, '2025-07-05', 7000.00),
(104, 3, '2025-07-06', 9000.00),
(105, 2, '2025-07-07', 2000.00);

-- 💰 Total Spending and Loyalty Level
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(p.amount) AS total_spent,
    CASE 
        WHEN SUM(p.amount) >= 10000 THEN 'Gold'
        WHEN SUM(p.amount) >= 5000 THEN 'Silver'
        ELSE 'Bronze'
    END AS loyalty_level
FROM Customers c
JOIN Purchases p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.customer_name;

-- 🏆 Top Spender of the Month (July 2025)
SELECT customer_id, customer_name, total_spent
FROM (
    SELECT 
        c.customer_id,
        c.customer_name,
        SUM(p.amount) AS total_spent
    FROM Customers c
    JOIN Purchases p ON c.customer_id = p.customer_id
    WHERE MONTH(p.purchase_date) = 7 AND YEAR(p.purchase_date) = 2025
    GROUP BY c.customer_id, c.customer_name
) AS monthly_totals
WHERE total_spent = (
    SELECT MAX(total_spent)
    FROM (
        SELECT SUM(amount) AS total_spent
        FROM Purchases
        WHERE MONTH(purchase_date) = 7 AND YEAR(purchase_date) = 2025
        GROUP BY customer_id
    ) AS max_spenders
);

-- 🎯 Insert Points Earned with Transaction
-- Example: Ramya earns 120 points

START TRANSACTION;

-- Insert points
INSERT INTO Points (point_id, customer_id, earned_points, transaction_date)
VALUES (201, 1, 120, CURDATE());

-- Optional: simulate error
-- UPDATE Points SET earned_points = 'invalid' WHERE point_id = 201;

-- If all good
COMMIT;

-- If error occurs
-- ROLLBACK;
--  Drop existing tables if they exist
DROP TABLE IF EXISTS Rewards;
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Customers;

-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

--  Create Transactions table
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    transaction_date DATE DEFAULT CURRENT_DATE,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

--  Create Rewards table
CREATE TABLE Rewards (
    reward_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    total_points INT DEFAULT 0,
    last_updated DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    UNIQUE (customer_id)
);

--  Insert sample customers
INSERT INTO Customers (name, email) VALUES
('Aarav Mehta', 'aarav@example.com'),
('Neha Sharma', 'neha@example.com');

--  Insert transactions
INSERT INTO Transactions (customer_id, transaction_date, amount) VALUES
(1, '2025-08-01', 1500.00),
(1, '2025-08-05', 2000.00),
(2, '2025-08-03', 800.00);

-- Insert initial reward records
INSERT INTO Rewards (customer_id, total_points) VALUES
(1, 0),
(2, 0);

-- Update reward points on repeat purchase (e.g., 1 point per ₹10 spent)
UPDATE Rewards r
JOIN (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM Transactions
    GROUP BY customer_id
) t ON r.customer_id = t.customer_id
SET r.total_points = FLOOR(t.total_spent / 10),
    r.last_updated = CURDATE();

-- Total spend per customer
SELECT c.name, SUM(t.amount) AS total_spent
FROM Customers c
JOIN Transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id;

-- Assign loyalty tier using CASE
SELECT 
    c.name,
    r.total_points,
    CASE 
        WHEN r.total_points >= 1000 THEN 'Platinum'
        WHEN r.total_points >= 500 THEN 'Gold'
        WHEN r.total_points >= 200 THEN 'Silver'
        ELSE 'Bronze'
    END AS loyalty_tier
FROM Customers c
JOIN Rewards r ON c.customer_id = r.customer_id;
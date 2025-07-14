-- 1. Create Database
CREATE DATABASE subscription_tracker;
USE subscription_tracker;

-- 2. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Subscriptions Table
CREATE TABLE subscriptions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    plan_name VARCHAR(100),
    start_date DATE,
    renewal_cycle ENUM('Monthly', 'Quarterly', 'Yearly'),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 4. Sample Users
INSERT INTO users (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 5. Sample Subscriptions
INSERT INTO subscriptions (user_id, plan_name, start_date, renewal_cycle) VALUES
(1, 'Pro Plan', '2025-06-15', 'Monthly'),
(2, 'Basic Plan', '2025-01-01', 'Yearly'),
(3, 'Premium Plan', '2025-07-01', 'Monthly'),
(4, 'Standard Plan', '2025-03-10', 'Quarterly'),
(5, 'Pro Plan', '2024-06-15', 'Yearly');

-- Auto-Renewal Date (Based on Cycle)
SELECT 
    u.name AS user,
    s.plan_name,
    s.start_date,
    s.renewal_cycle,
    CASE s.renewal_cycle
        WHEN 'Monthly' THEN DATE_ADD(s.start_date, INTERVAL 1 MONTH)
        WHEN 'Quarterly' THEN DATE_ADD(s.start_date, INTERVAL 3 MONTH)
        WHEN 'Yearly' THEN DATE_ADD(s.start_date, INTERVAL 1 YEAR)
    END AS next_renewal_date
FROM subscriptions s
JOIN users u ON s.user_id = u.id;

-- Expired Subscriptions (As of today)
SELECT 
    u.name,
    s.plan_name,
    s.start_date,
    s.renewal_cycle,
    CASE s.renewal_cycle
        WHEN 'Monthly' THEN DATE_ADD(s.start_date, INTERVAL 1 MONTH)
        WHEN 'Quarterly' THEN DATE_ADD(s.start_date, INTERVAL 3 MONTH)
        WHEN 'Yearly' THEN DATE_ADD(s.start_date, INTERVAL 1 YEAR)
    END AS expected_renewal,
    IF(
        CASE s.renewal_cycle
            WHEN 'Monthly' THEN DATE_ADD(s.start_date, INTERVAL 1 MONTH)
            WHEN 'Quarterly' THEN DATE_ADD(s.start_date, INTERVAL 3 MONTH)
            WHEN 'Yearly' THEN DATE_ADD(s.start_date, INTERVAL 1 YEAR)
        END < CURDATE(),
        'Expired',
        'Active'
    ) AS status
FROM subscriptions s
JOIN users u ON s.user_id = u.id
ORDER BY expected_renewal;


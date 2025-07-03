-- Drop tables if they already exist
DROP TABLE IF EXISTS purchases;
DROP TABLE IF EXISTS referrals;
DROP TABLE IF EXISTS users;

-- 1. Create Tables

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100)
);

CREATE TABLE referrals (
    user_id INT,              -- Referrer
    referred_user_id INT,     -- Referred friend
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (referred_user_id) REFERENCES users(user_id)
);

CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(10,2),
    purchase_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 2. Insert Sample Data

-- Users
INSERT INTO users (user_id, user_name) VALUES
(1, 'Aarav'),
(2, 'Bhavya'),
(3, 'Chirag'),
(4, 'Diya'),
(5, 'Esha'),
(6, 'Farhan');

-- Referrals (user_id refers referred_user_id)
INSERT INTO referrals (user_id, referred_user_id) VALUES
(1, 2),
(1, 3),
(2, 4),
(3, 5),
(3, 6);

-- Purchases
INSERT INTO purchases (purchase_id, user_id, amount, purchase_date) VALUES
(1001, 2, 500.00, '2025-07-01'),
(1002, 3, 300.00, '2025-07-02'),
(1003, 5, 200.00, '2025-07-03'),
(1004, 6, 150.00, '2025-07-04');

-- 3. Count Number of Referrals per User
SELECT 
    u.user_name AS referrer,
    COUNT(r.referred_user_id) AS total_referrals
FROM users u
LEFT JOIN referrals r ON u.user_id = r.user_id
GROUP BY u.user_id, u.user_name;

-- 4. Users Who Referred Others but Made No Purchases
SELECT 
    u.user_name
FROM users u
JOIN referrals r ON u.user_id = r.user_id
LEFT JOIN purchases p ON u.user_id = p.user_id
WHERE p.purchase_id IS NULL
GROUP BY u.user_id, u.user_name;

-- 5. Users with the Most Referred Purchases
SELECT 
    u.user_name AS referrer,
    COUNT(p.purchase_id) AS referred_purchases
FROM referrals r
JOIN users u ON r.user_id = u.user_id
JOIN purchases p ON r.referred_user_id = p.user_id
GROUP BY u.user_id, u.user_name
ORDER BY referred_purchases DESC
LIMIT 1;
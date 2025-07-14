-- 1. Create Database
CREATE DATABASE bank_transactions;
USE bank_transactions;

-- 2. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Accounts Table
CREATE TABLE accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    balance DECIMAL(12,2) DEFAULT 0.00,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 4. Transactions Table
CREATE TABLE transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    type ENUM('Deposit', 'Withdrawal') NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);

-- 5. Sample Users
INSERT INTO users (name) VALUES
('Ramya'), ('Arjun'), ('Sneha');

-- 6. Sample Accounts
INSERT INTO accounts (user_id, balance) VALUES
(1, 10000.00), (2, 7500.00), (3, 5000.00);

-- 7. Sample Transactions
INSERT INTO transactions (account_id, type, amount, timestamp) VALUES
(1, 'Deposit', 2000.00, '2025-07-01 10:00:00'),
(1, 'Withdrawal', 1500.00, '2025-07-02 11:30:00'),
(1, 'Deposit', 1000.00, '2025-07-03 09:15:00'),
(2, 'Deposit', 3000.00, '2025-07-01 13:00:00'),
(2, 'Withdrawal', 1200.00, '2025-07-02 14:45:00'),
(3, 'Deposit', 2500.00, '2025-07-01 12:00:00'),
(3, 'Withdrawal', 1000.00, '2025-07-03 10:30:00'),
(2, 'Deposit', 500.00, '2025-07-04 11:00:00'),
(1, 'Withdrawal', 800.00, '2025-07-04 16:00:00'),
(3, 'Deposit', 1000.00, '2025-07-05 17:00:00');

-- 8. CTE: Dynamic Balance Calculation per Account
WITH txn_totals AS (
    SELECT 
        account_id,
        SUM(CASE WHEN type = 'Deposit' THEN amount ELSE -amount END) AS net_change
    FROM transactions
    GROUP BY account_id
)
SELECT 
    a.id AS account_id,
    u.name AS user,
    a.balance AS starting_balance,
    COALESCE(t.net_change, 0) AS transaction_adjustment,
    ROUND(a.balance + COALESCE(t.net_change, 0), 2) AS current_balance
FROM accounts a
JOIN users u ON a.user_id = u.id
LEFT JOIN txn_totals t ON a.id = t.account_id;

-- 9. Query: Full Transaction Log for Account 'Ramya'
SELECT 
    u.name AS user,
    t.type,
    t.amount,
    t.timestamp
FROM transactions t
JOIN accounts a ON t.account_id = a.id
JOIN users u ON a.user_id = u.id
WHERE u.name = 'Ramya'
ORDER BY t.timestamp;
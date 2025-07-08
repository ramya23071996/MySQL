-- 🏦 Create Database and Tables
CREATE DATABASE IF NOT EXISTS BankDB;
USE BankDB;

-- Accounts table
CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    account_holder VARCHAR(100) NOT NULL,
    balance DECIMAL(12,2) NOT NULL CHECK (balance >= 0)
);

-- Transactions table
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    transaction_type ENUM('credit', 'debit') NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    transaction_date DATE NOT NULL,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- 📝 Insert Sample Accounts
INSERT INTO Accounts VALUES 
(1, 'Ramya', 100000.00),
(2, 'Arun', 50000.00),
(3, 'Priya', 75000.00);

-- 💳 Insert Transactions
INSERT INTO Transactions VALUES 
(101, 1, 'debit', 5000.00, '2025-07-06'),
(102, 1, 'credit', 2000.00, '2025-07-07'),
(103, 2, 'debit', 3000.00, '2025-07-07'),
(104, 3, 'credit', 4000.00, '2025-07-08');

-- 📊 Total Debits and Credits per Account
SELECT 
    a.account_id,
    a.account_holder,
    SUM(CASE WHEN t.transaction_type = 'debit' THEN t.amount ELSE 0 END) AS total_debits,
    SUM(CASE WHEN t.transaction_type = 'credit' THEN t.amount ELSE 0 END) AS total_credits
FROM Accounts a
LEFT JOIN Transactions t ON a.account_id = t.account_id
GROUP BY a.account_id, a.account_holder;

-- 🔁 Simulate a Transfer with Transaction Control
-- Transfer ₹10,000 from Ramya (Account 1) to Priya (Account 3)

START TRANSACTION;

-- Savepoint before transfer
SAVEPOINT before_transfer;

-- Step 1: Debit from Ramya
UPDATE Accounts SET balance = balance - 10000 WHERE account_id = 1;
INSERT INTO Transactions VALUES (105, 1, 'debit', 10000.00, CURDATE());

-- Step 2: Credit to Priya
UPDATE Accounts SET balance = balance + 10000 WHERE account_id = 3;
INSERT INTO Transactions VALUES (106, 3, 'credit', 10000.00, CURDATE());

-- Optional: Simulate error (uncomment to test rollback)
-- UPDATE Accounts SET balance = 'error' WHERE account_id = 3;

-- If all good
COMMIT;

-- If error occurs
-- ROLLBACK TO before_transfer;
-- ROLLBACK;
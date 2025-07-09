-- ============================================
-- 0. CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS BankingMonitor;
USE BankingMonitor;

-- ============================================
-- 1. CREATE NORMALIZED TABLES (3NF)
-- ============================================

-- Customers table
CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100)
);

-- Accounts table
CREATE TABLE IF NOT EXISTS Accounts (
    account_id INT PRIMARY KEY,
    customer_id INT,
    account_type VARCHAR(50),
    balance DECIMAL(15,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Transactions table
CREATE TABLE IF NOT EXISTS Transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    transaction_date DATE,
    amount DECIMAL(15,2),
    transaction_type VARCHAR(20),
    description TEXT,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

-- Customers
INSERT INTO Customers VALUES
(1, 'Alice', 'alice@bank.com'),
(2, 'Bob', 'bob@bank.com'),
(3, 'Charlie', 'charlie@bank.com');

-- Accounts
INSERT INTO Accounts VALUES
(101, 1, 'Savings', 150000.00),
(102, 2, 'Checking', 80000.00),
(103, 3, 'Savings', 120000.00);

-- Transactions
INSERT INTO Transactions VALUES
(1, 101, '2024-07-01', 5000.00, 'Debit', 'ATM Withdrawal'),
(2, 101, '2024-07-02', 200000.00, 'Credit', 'Salary Deposit'),
(3, 102, '2024-07-03', 10000.00, 'Debit', 'Online Purchase'),
(4, 103, '2024-07-04', 250000.00, 'Debit', 'Wire Transfer'),
(5, 101, '2024-07-05', 1500.00, 'Debit', 'Grocery'),
(6, 102, '2024-07-06', 300000.00, 'Credit', 'Loan Disbursement'),
(7, 103, '2024-07-07', 500.00, 'Debit', 'Mobile Recharge');

-- ============================================
-- 3. CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX idx_account_id ON Transactions(account_id);
CREATE INDEX idx_transaction_date ON Transactions(transaction_date);
CREATE INDEX idx_amount ON Transactions(amount);

-- ============================================
-- 4. EXPLAIN: SUSPICIOUS HIGH-VALUE TRANSACTIONS
-- ============================================

EXPLAIN
SELECT * FROM Transactions
WHERE amount > 100000 AND transaction_type = 'Debit';

-- ============================================
-- 5. DENORMALIZED VIEW FOR ACCOUNT STATEMENTS
-- ============================================

CREATE OR REPLACE VIEW AccountStatement AS
SELECT 
    t.transaction_id,
    c.customer_name,
    a.account_id,
    a.account_type,
    t.transaction_date,
    t.amount,
    t.transaction_type,
    t.description
FROM Transactions t
JOIN Accounts a ON t.account_id = a.account_id
JOIN Customers c ON a.customer_id = c.customer_id;

-- View usage example
SELECT * FROM AccountStatement WHERE customer_name = 'Alice';

-- ============================================
-- 6. LIMIT: RECENT TRANSACTIONS
-- ============================================

-- Latest 5 transactions for account 101
SELECT * FROM Transactions
WHERE account_id = 101
ORDER BY transaction_date DESC
LIMIT 5;
-- Drop tables if they already exist
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS branches;

-- 1. Create Tables

CREATE TABLE branches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(100)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    branch_id INT,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_id INT,
    balance DECIMAL(12,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    amount DECIMAL(10,2),
    transaction_date DATE,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

-- 2. Insert Sample Data

-- Branches
INSERT INTO branches (branch_id, branch_name) VALUES
(1, 'Downtown'),
(2, 'Uptown'),
(3, 'Suburban');

-- Customers
INSERT INTO customers (customer_id, customer_name, branch_id) VALUES
(101, 'Aarav', 1),
(102, 'Bhavya', 1),
(103, 'Chirag', 2),
(104, 'Diya', 3),
(105, 'Esha', 3);

-- Accounts
INSERT INTO accounts (account_id, customer_id, balance) VALUES
(1001, 101, 50000.00),
(1002, 102, 30000.00),
(1003, 103, 45000.00),
(1004, 104, 20000.00);

-- Transactions
INSERT INTO transactions (transaction_id, account_id, amount, transaction_date) VALUES
(2001, 1001, 5000.00, '2025-07-01'),
(2002, 1001, -2000.00, '2025-07-02'),
(2003, 1002, 10000.00, '2025-07-03'),
(2004, 1003, -5000.00, '2025-07-04');

-- 3. Count Accounts and Total Balance per Branch
SELECT 
    b.branch_name,
    COUNT(a.account_id) AS total_accounts,
    SUM(a.balance) AS total_balance
FROM branches b
JOIN customers c ON b.branch_id = c.branch_id
JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY b.branch_name;

-- 4. Customers with No Transactions
SELECT 
    cu.customer_name
FROM customers cu
JOIN accounts a ON cu.customer_id = a.customer_id
LEFT JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_id IS NULL;

-- 5. Branches with Highest and Lowest Number of Customers

-- Highest
SELECT 
    branch_name,
    COUNT(customer_id) AS customer_count
FROM branches b
JOIN customers c ON b.branch_id = c.branch_id
GROUP BY branch_name
ORDER BY customer_count DESC
LIMIT 1;

-- Lowest
SELECT 
    branch_name,
    COUNT(customer_id) AS customer_count
FROM branches b
JOIN customers c ON b.branch_id = c.branch_id
GROUP BY branch_name
ORDER BY customer_count ASC
LIMIT 1;
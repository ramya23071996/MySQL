--  Drop existing tables if they exist
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Customers;

--  Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

--  Create Accounts table
CREATE TABLE Accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    account_type VARCHAR(20) NOT NULL,
    balance DECIMAL(12,2) NOT NULL CHECK (balance >= 0),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

--  Create Transactions table
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    transaction_type VARCHAR(10) NOT NULL, -- 'Deposit' or 'Withdraw'
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

--  Insert sample customers
INSERT INTO Customers (name, email) VALUES
('Aarav Patel', 'aarav.patel@example.com'),
('Meera Iyer', 'meera.iyer@example.com');

--  Insert sample accounts
INSERT INTO Accounts (customer_id, account_type, balance) VALUES
(1, 'Savings', 50000.00),
(2, 'Checking', 30000.00);

--  Deposit into account
INSERT INTO Transactions (account_id, transaction_type, amount)
VALUES (1, 'Deposit', 10000.00);
UPDATE Accounts SET balance = balance + 10000 WHERE account_id = 1;

--  Withdraw from account
INSERT INTO Transactions (account_id, transaction_type, amount)
VALUES (2, 'Withdraw', 5000.00);
UPDATE Accounts SET balance = balance - 5000 WHERE account_id = 2;

--  Simulate fund transfer using transaction
START TRANSACTION;

-- Step 1: Withdraw from sender (account_id = 1)
UPDATE Accounts SET balance = balance - 7000 WHERE account_id = 1 AND balance >= 7000;

-- Step 2: Deposit to receiver (account_id = 2)
UPDATE Accounts SET balance = balance + 7000 WHERE account_id = 2;

-- Step 3: Record transactions
INSERT INTO Transactions (account_id, transaction_type, amount) VALUES (1, 'Withdraw', 7000);
INSERT INTO Transactions (account_id, transaction_type, amount) VALUES (2, 'Deposit', 7000);

--  Commit if all successful
COMMIT;

--  Subquery: Find customer(s) with highest balance
SELECT name, balance
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
WHERE balance = (
    SELECT MAX(balance) FROM Accounts
);
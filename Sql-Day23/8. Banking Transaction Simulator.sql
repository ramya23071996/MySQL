-- 🔁 Drop existing tables if they exist
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Customers;

-- 🏗️ Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15)
);

-- 🏗️ Create Accounts table
CREATE TABLE Accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    account_type VARCHAR(20) NOT NULL,
    balance DECIMAL(12,2) NOT NULL CHECK (balance >= 0),
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- 🏗️ Create Transactions table
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    from_account INT,
    to_account INT,
    amount DECIMAL(12,2) NOT NULL CHECK (amount > 0),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (from_account) REFERENCES Accounts(account_id),
    FOREIGN KEY (to_account) REFERENCES Accounts(account_id)
);

-- 👤 Insert sample customers
INSERT INTO Customers (name, email, phone) VALUES
('Ravi Kumar', 'ravi.kumar@example.com', '9876543210'),
('Anita Desai', 'anita.desai@example.com', '9123456789');

-- 💰 Insert sample accounts
INSERT INTO Accounts (customer_id, account_type, balance) VALUES
(1, 'Savings', 50000.00),
(2, 'Checking', 30000.00);

-- 🔄 Simulate a fund transfer using a transaction
START TRANSACTION;

-- Step 1: Debit from sender (account_id = 1)
UPDATE Accounts
SET balance = balance - 10000
WHERE account_id = 1 AND balance >= 10000;

-- Step 2: Credit to receiver (account_id = 2)
UPDATE Accounts
SET balance = balance + 10000
WHERE account_id = 2;

-- Step 3: Record the transaction
INSERT INTO Transactions (from_account, to_account, amount)
VALUES (1, 2, 10000);

-- Optional: Simulate failure (e.g., overdraft)
-- UPDATE Accounts SET balance = balance - 60000 WHERE account_id = 1; -- Will fail CHECK

-- ✅ Commit if all successful
COMMIT;

-- ❌ Rollback if any step fails
-- ROLLBACK;

-- ❌ Delete closed accounts
UPDATE Accounts SET is_active = FALSE WHERE account_id = 2;
DELETE FROM Accounts WHERE is_active = FALSE;
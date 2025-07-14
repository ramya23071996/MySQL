-- 1. Create Database
CREATE DATABASE loan_tracker;
USE loan_tracker;

-- 2. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Loans Table
CREATE TABLE loans (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    principal DECIMAL(12,2),
    interest_rate DECIMAL(5,2),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 4. Payments Table
CREATE TABLE payments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT,
    amount DECIMAL(12,2),
    paid_on DATE,
    FOREIGN KEY (loan_id) REFERENCES loans(id)
);

-- 5. Sample Users
INSERT INTO users (name) VALUES
('Ramya'), ('Arjun'), ('Sneha');

-- 6. Sample Loans
INSERT INTO loans (user_id, principal, interest_rate) VALUES
(1, 50000.00, 6.50),
(2, 75000.00, 7.25),
(3, 60000.00, 5.75);

-- 7. Sample Payments
INSERT INTO payments (loan_id, amount, paid_on) VALUES
(1, 5000.00, '2025-07-01'),
(1, 5000.00, '2025-07-15'),
(1, 5000.00, '2025-07-30'),
(2, 7500.00, '2025-07-05'),
(2, 7500.00, '2025-07-20'),
(3, 6000.00, '2025-07-10'),
(3, 6000.00, '2025-07-25'),
(2, 7500.00, '2025-08-05'),
(1, 5000.00, '2025-08-01'),
(3, 6000.00, '2025-08-10');

-- 8. Query: Loan Repayment Summary
SELECT 
    u.name AS user,
    l.id AS loan_id,
    l.principal,
    l.interest_rate,
    SUM(p.amount) AS total_paid,
    ROUND((l.principal + (l.principal * l.interest_rate / 100)) - SUM(p.amount), 2) AS remaining_balance
FROM loans l
JOIN users u ON l.user_id = u.id
LEFT JOIN payments p ON l.id = p.loan_id
GROUP BY l.id, u.name, l.principal, l.interest_rate;

-- 9. Query: Payment History for Ramya
SELECT 
    p.paid_on,
    p.amount
FROM payments p
JOIN loans l ON p.loan_id = l.id
JOIN users u ON l.user_id = u.id
WHERE u.name = 'Ramya'
ORDER BY p.paid_on;

-- 10. Query: Next Due Payment Estimation (Assuming fixed EMI every 15 days)
SELECT 
    l.id AS loan_id,
    MAX(p.paid_on) + INTERVAL 15 DAY AS next_due
FROM loans l
JOIN payments p ON l.id = p.loan_id
GROUP BY l.id;
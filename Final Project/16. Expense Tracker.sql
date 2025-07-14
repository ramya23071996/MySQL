-- 1. Create Database
CREATE DATABASE expense_tracker;
USE expense_tracker;

-- 2. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Categories Table
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 4. Expenses Table
CREATE TABLE expenses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    category_id INT,
    amount DECIMAL(10,2),
    date DATE,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- 5. Sample Users
INSERT INTO users (name) VALUES
('Ramya'), ('Arjun'), ('Sneha');

-- 6. Sample Categories
INSERT INTO categories (name) VALUES
('Groceries'), ('Utilities'), ('Transport'), ('Entertainment'), ('Dining');

-- 7. Sample Expenses
INSERT INTO expenses (user_id, category_id, amount, date) VALUES
(1, 1, 2500.00, '2025-07-01'),
(1, 2, 1200.00, '2025-07-03'),
(1, 5, 800.00, '2025-07-04'),
(2, 1, 1800.00, '2025-07-01'),
(2, 3, 500.00, '2025-07-05'),
(2, 4, 1000.00, '2025-07-06'),
(3, 2, 1300.00, '2025-07-02'),
(3, 4, 900.00, '2025-07-03'),
(1, 3, 400.00, '2025-07-07'),
(3, 5, 750.00, '2025-07-08');

-- 8. Query: Total Expense by Category for Ramya
SELECT 
    c.name AS category,
    SUM(e.amount) AS total_spent
FROM expenses e
JOIN categories c ON e.category_id = c.id
JOIN users u ON e.user_id = u.id
WHERE u.name = 'Ramya'
GROUP BY c.name;

-- 9. Query: Monthly Expense Summary per User
SELECT 
    u.name AS user,
    MONTH(e.date) AS month,
    SUM(e.amount) AS monthly_total
FROM expenses e
JOIN users u ON e.user_id = u.id
GROUP BY u.name, MONTH(e.date);

-- 10. Query: Expenses in a Specific Amount Range
SELECT 
    u.name AS user,
    c.name AS category,
    e.amount,
    e.date
FROM expenses e
JOIN users u ON e.user_id = u.id
JOIN categories c ON e.category_id = c.id
WHERE e.amount BETWEEN 700 AND 1300
ORDER BY e.amount DESC;

-- 11. Query: All Expenses for Ramya
SELECT 
    e.date,
    c.name AS category,
    e.amount
FROM expenses e
JOIN categories c ON e.category_id = c.id
JOIN users u ON e.user_id = u.id
WHERE u.name = 'Ramya'
ORDER BY e.date;
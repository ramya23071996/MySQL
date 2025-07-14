-- 1. Create Database
CREATE DATABASE salary_management;
USE salary_management;

-- 2. Employees Table
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Salaries Table
CREATE TABLE salaries (
    emp_id INT,
    month DATE, -- Suggest using the first day of month (e.g., '2025-07-01')
    base DECIMAL(10,2),
    bonus DECIMAL(10,2),
    PRIMARY KEY (emp_id, month),
    FOREIGN KEY (emp_id) REFERENCES employees(id)
);

-- 4. Deductions Table
CREATE TABLE deductions (
    emp_id INT,
    month DATE,
    reason VARCHAR(255),
    amount DECIMAL(10,2),
    FOREIGN KEY (emp_id) REFERENCES employees(id)
);

-- 5. Sample Employees
INSERT INTO employees (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 6. Sample Salaries
INSERT INTO salaries (emp_id, month, base, bonus) VALUES
(1, '2025-07-01', 50000, 2000),
(2, '2025-07-01', 45000, 2500),
(3, '2025-07-01', 40000, 1500),
(4, '2025-07-01', 55000, 3000),
(5, '2025-07-01', 48000, 2200),
(1, '2025-08-01', 50000, 5000),
(2, '2025-08-01', 45000, 0),
(3, '2025-08-01', 40000, 2000),
(4, '2025-08-01', 55000, 2500),
(5, '2025-08-01', 48000, 1800);

-- 7. Sample Deductions
INSERT INTO deductions (emp_id, month, reason, amount) VALUES
(1, '2025-07-01', 'Tax', 3000),
(1, '2025-07-01', 'Health Insurance', 1000),
(2, '2025-07-01', 'Tax', 2500),
(3, '2025-07-01', 'Leave Penalty', 2000),
(4, '2025-07-01', 'Tax', 3500),
(5, '2025-07-01', 'Late Arrival', 1000),
(1, '2025-08-01', 'Tax', 3200),
(2, '2025-08-01', 'Health Insurance', 900),
(3, '2025-08-01', 'Tax', 2800),
(5, '2025-08-01', 'Tax', 3000);

-- 8. Query: Monthly Salary Summary with Net Pay
SELECT 
    e.name AS employee,
    s.month,
    s.base,
    s.bonus,
    COALESCE(SUM(d.amount), 0) AS total_deductions,
    (s.base + s.bonus - COALESCE(SUM(d.amount), 0)) AS net_pay
FROM salaries s
JOIN employees e ON s.emp_id = e.id
LEFT JOIN deductions d ON s.emp_id = d.emp_id AND s.month = d.month
GROUP BY e.name, s.month, s.base, s.bonus;

-- 9. Query: Employees with Bonus Over ₹2000 in August
SELECT 
    e.name,
    s.bonus
FROM salaries s
JOIN employees e ON s.emp_id = e.id
WHERE s.month = '2025-08-01' AND s.bonus > 2000;

-- 10. Query: All Deductions for 'Ramya'
SELECT 
    d.month,
    d.reason,
    d.amount
FROM deductions d
JOIN employees e ON d.emp_id = e.id
WHERE e.name = 'Ramya'
ORDER BY d.month;
-- 🔁 Drop existing tables if they exist
DROP TABLE IF EXISTS Deductions;
DROP TABLE IF EXISTS Salaries;
DROP TABLE IF EXISTS Employees;

-- 👤 Create Employees table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    department VARCHAR(50)
);

-- 💵 Create Salaries table
CREATE TABLE Salaries (
    salary_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    salary_month DATE NOT NULL,
    base_salary DECIMAL(10,2) NOT NULL CHECK (base_salary >= 5000),
    bonus DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    UNIQUE (employee_id, salary_month)
);

-- 💸 Create Deductions table
CREATE TABLE Deductions (
    deduction_id INT PRIMARY KEY AUTO_INCREMENT,
    salary_id INT NOT NULL,
    deduction_type VARCHAR(100),
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    FOREIGN KEY (salary_id) REFERENCES Salaries(salary_id)
);

-- 👥 Insert sample employees
INSERT INTO Employees (name, email, department) VALUES
('Anjali Rao', 'anjali.rao@company.com', 'Finance'),
('Rohit Mehta', 'rohit.mehta@company.com', 'HR');

-- 🔄 Insert salary + deduction using a transaction
START TRANSACTION;

-- Step 1: Insert salary for Anjali
INSERT INTO Salaries (employee_id, salary_month, base_salary, bonus)
VALUES (1, '2025-07-01', 60000.00, 5000.00);

-- Step 2: Insert deduction for that salary
INSERT INTO Deductions (salary_id, deduction_type, amount)
VALUES (LAST_INSERT_ID(), 'Provident Fund', 3000.00);

-- ✅ Commit if all successful
COMMIT;

-- ✏️ Update bonus or deduction
UPDATE Salaries
SET bonus = 7000.00
WHERE employee_id = 1 AND salary_month = '2025-07-01';

UPDATE Deductions
SET amount = 3500.00
WHERE deduction_type = 'Provident Fund' AND salary_id = 1;

-- ❌ Delete salary records older than 2 years
DELETE FROM Deductions
WHERE salary_id IN (
    SELECT salary_id FROM Salaries
    WHERE salary_month < DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
);

DELETE FROM Salaries
WHERE salary_month < DATE_SUB(CURDATE(), INTERVAL 2 YEAR);
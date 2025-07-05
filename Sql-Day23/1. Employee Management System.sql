-- 🔁 Drop existing tables if they exist
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;

-- 🏗️ Create Departments table
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) UNIQUE NOT NULL
);

-- 🏗️ Create Employees table with constraints
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    department_id INT,
    salary DECIMAL(10,2) NOT NULL,
    hire_date DATE DEFAULT CURRENT_DATE,
    CHECK (salary > 3000),
    FOREIGN KEY (department_id) REFERENCES Departments(dept_id)
);

-- 🧾 Insert sample departments
INSERT INTO Departments (dept_name) VALUES
('HR'),
('IT'),
('Finance'),
('Marketing');

-- 🧾 Insert sample employees
INSERT INTO Employees (name, department_id, salary) VALUES
('Alice', 1, 50000),
('Bob', 2, 60000),
('Charlie', 3, 45000),
('Diana', 2, 55000),
('Eve', 1, 47000);

-- ✏️ Update department of an employee
UPDATE Employees
SET department_id = 3
WHERE emp_id = 2;

-- ✏️ Update salary of an employee
UPDATE Employees
SET salary = salary + 5000
WHERE emp_id = 4;

-- ❌ Delete an employee who resigned
DELETE FROM Employees
WHERE emp_id = 5;

-- 🔄 Transaction: Hiring multiple employees with SAVEPOINT and ROLLBACK
START TRANSACTION;

-- ✅ Insert first new hire
INSERT INTO Employees (name, department_id, salary) VALUES
('Frank', 4, 52000);
SAVEPOINT after_frank;

-- ✅ Insert second new hire
INSERT INTO Employees (name, department_id, salary) VALUES
('Grace', 2, 58000);
SAVEPOINT after_grace;

-- ❌ Simulate an error (uncomment to test rollback)
-- INSERT INTO Employees (name, department_id, salary) VALUES
-- ('Hank', 1, 2500); -- Will fail due to CHECK constraint

-- 🔁 Rollback to last successful point if needed
-- ROLLBACK TO after_grace;

-- ✅ Commit if all successful
COMMIT;
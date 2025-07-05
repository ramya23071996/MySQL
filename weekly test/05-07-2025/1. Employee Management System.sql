-- Drop existing tables if they exist
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;

-- Create Departments table
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL UNIQUE
);

-- Create Employees table
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    department_id INT NOT NULL,
    salary DECIMAL(10,2) NOT NULL CHECK (salary >= 5000),
    hire_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (department_id) REFERENCES Departments(dept_id)
);

--  Insert sample departments
INSERT INTO Departments (dept_name) VALUES
('HR'),
('IT'),
('Finance'),
('Marketing');

--  Insert sample employees
INSERT INTO Employees (name, email, department_id, salary) VALUES
('Aarav Mehta', 'aarav@company.com', 1, 55000),
('Neha Sharma', 'neha@company.com', 2, 60000),
('Ravi Kumar', 'ravi@company.com', 3, 52000),
('Tanya Desai', 'tanya@company.com', 2, 58000);

--  Update department and salary
UPDATE Employees
SET department_id = 3, salary = 56000
WHERE emp_id = 1;

-- Delete resigned employee
DELETE FROM Employees
WHERE emp_id = 4;

--  Join: Get employee with department name
SELECT e.emp_id, e.name, d.dept_name, e.salary
FROM Employees e
JOIN Departments d ON e.department_id = d.dept_id;

-- Group by: Department-wise average salary
SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM Employees e
JOIN Departments d ON e.department_id = d.dept_id
GROUP BY d.dept_name;

-- Batch salary update using transaction
START TRANSACTION;

-- Step 1: Increase salary for IT department
UPDATE Employees
SET salary = salary + 2000
WHERE department_id = 2;
SAVEPOINT after_it_raise;

-- Step 2: Increase salary for Finance department
UPDATE Employees
SET salary = salary + 1500
WHERE department_id = 3;
SAVEPOINT after_finance_raise;

-- Optional: Simulate failure
UPDATE Employees SET salary = -10000 WHERE emp_id = 2; -- Will fail CHECK

-- Commit if all successful
COMMIT;

--  Rollback to a savepoint if needed
 ROLLBACK TO after_it_raise;
 COMMIT;
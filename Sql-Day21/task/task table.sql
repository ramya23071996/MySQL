CREATE DATABASE company_db;
USE company_db;

CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100)
);
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_id INT,
    salary DECIMAL(10, 2),
    hire_date DATE,
    manager_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

CREATE TABLE salaries (
    salary_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    amount DECIMAL(10, 2),
    date_paid DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Departments
INSERT INTO departments (department_name) VALUES 
('IT'), ('HR'), ('Marketing'), ('Finance');

-- Employees
INSERT INTO employees (first_name, last_name, department_id, salary, hire_date, manager_id) VALUES
('Alice', 'Smith', 1, 70000, '2019-03-15', NULL),
('Bob', 'Johnson', 1, 65000, '2021-06-01', 1),
('Carol', 'White', 2, 60000, '2020-01-10', 1),
('David', 'Brown', 3, 55000, '2022-09-23', 2),
('Eve', 'Davis', NULL, 50000, '2023-02-11', NULL);

-- Salaries
INSERT INTO salaries (employee_id, amount, date_paid) VALUES
(1, 70000, '2024-12-31'),
(2, 65000, '2024-12-31'),
(3, 60000, '2024-12-31'),
(4, 55000, '2024-12-31');
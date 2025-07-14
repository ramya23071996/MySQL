-- 1. Create Database
CREATE DATABASE timesheet_tracker;
USE timesheet_tracker;

-- 2. Employees Table
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    dept VARCHAR(100)
);

-- 3. Projects Table
CREATE TABLE projects (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL
);

-- 4. Timesheets Table
CREATE TABLE timesheets (
    id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    project_id INT,
    hours DECIMAL(4,2),
    date DATE,
    FOREIGN KEY (emp_id) REFERENCES employees(id),
    FOREIGN KEY (project_id) REFERENCES projects(id)
);

-- 5. Insert Employees
INSERT INTO employees (name, dept) VALUES
('Ramya', 'Backend'),
('Arjun', 'Frontend'),
('Sneha', 'QA'),
('Kiran', 'DevOps'),
('Meera', 'Design');

-- 6. Insert Projects
INSERT INTO projects (name) VALUES
('Inventory System'),
('E-Commerce App'),
('Analytics Dashboard'),
('Website Redesign'),
('Payment Gateway');

-- 7. Insert Timesheets
INSERT INTO timesheets (emp_id, project_id, hours, date) VALUES
(1, 1, 6.0, '2025-07-01'),
(1, 2, 4.0, '2025-07-02'),
(2, 2, 5.0, '2025-07-01'),
(3, 3, 3.5, '2025-07-03'),
(4, 1, 7.0, '2025-07-01'),
(5, 4, 4.5, '2025-07-02'),
(1, 3, 2.0, '2025-07-04'),
(2, 5, 3.0, '2025-07-05'),
(3, 5, 2.5, '2025-07-04'),
(5, 2, 5.0, '2025-07-03');

-- 8. Query: Timesheet by Employee & Project
SELECT e.name AS employee, p.name AS project, SUM(t.hours) AS total_hours
FROM timesheets t
JOIN employees e ON t.emp_id = e.id
JOIN projects p ON t.project_id = p.id
GROUP BY e.name, p.name;

-- 9. Query: Weekly Hours for 'Ramya'
SELECT e.name AS employee, SUM(t.hours) AS weekly_hours
FROM timesheets t
JOIN employees e ON t.emp_id = e.id
WHERE e.name = 'Ramya' AND WEEK(t.date) = WEEK(CURDATE())
GROUP BY e.name;

-- 10. Query: Monthly Project Summary
SELECT p.name AS project, SUM(t.hours) AS total_hours
FROM timesheets t
JOIN projects p ON t.project_id = p.id
WHERE MONTH(t.date) = MONTH(CURDATE())
GROUP BY p.name;
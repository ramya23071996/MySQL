-- 1. Create Leave Management Database
CREATE DATABASE leave_management;
USE leave_management;

-- 2. Employees Table
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Leave Types Table
CREATE TABLE leave_types (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL
);

-- 4. Leave Requests Table with Overlap Check (Basic Constraint via Unique Index)
CREATE TABLE leave_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    leave_type_id INT,
    from_date DATE,
    to_date DATE,
    status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    FOREIGN KEY (emp_id) REFERENCES employees(id),
    FOREIGN KEY (leave_type_id) REFERENCES leave_types(id)
);

-- Optional (Advanced): Prevent overlapping leave requests via stored procedure or logic in application layer

-- 5. Insert Employees
INSERT INTO employees (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 6. Insert Leave Types
INSERT INTO leave_types (type_name) VALUES
('Sick Leave'), ('Casual Leave'), ('Earned Leave'), ('Maternity Leave');

-- 7. Insert Leave Requests
INSERT INTO leave_requests (emp_id, leave_type_id, from_date, to_date, status) VALUES
(1, 2, '2025-07-01', '2025-07-03', 'Approved'),
(1, 1, '2025-07-10', '2025-07-12', 'Pending'),
(2, 3, '2025-07-05', '2025-07-07', 'Approved'),
(3, 1, '2025-07-08', '2025-07-08', 'Approved'),
(3, 2, '2025-07-20', '2025-07-22', 'Pending'),
(4, 4, '2025-06-15', '2025-09-15', 'Approved'),
(5, 1, '2025-07-02', '2025-07-03', 'Rejected'),
(1, 3, '2025-07-20', '2025-07-21', 'Approved'),
(2, 2, '2025-07-10', '2025-07-11', 'Pending'),
(5, 2, '2025-07-15', '2025-07-16', 'Approved');

-- 8. Query: Total Approved Leave Days per Employee
SELECT e.name AS employee,
       SUM(DATEDIFF(lr.to_date, lr.from_date) + 1) AS total_days
FROM leave_requests lr
JOIN employees e ON lr.emp_id = e.id
WHERE lr.status = 'Approved'
GROUP BY e.name;

-- 9. Query: Current Pending Requests
SELECT e.name AS employee, lt.type_name, lr.from_date, lr.to_date, lr.status
FROM leave_requests lr
JOIN employees e ON lr.emp_id = e.id
JOIN leave_types lt ON lr.leave_type_id = lt.id
WHERE lr.status = 'Pending';

-- 10. Query: Leaves Taken by Ramya
SELECT lt.type_name, lr.from_date, lr.to_date, lr.status
FROM leave_requests lr
JOIN leave_types lt ON lr.leave_type_id = lt.id
WHERE lr.emp_id = 1
ORDER BY lr.from_date;
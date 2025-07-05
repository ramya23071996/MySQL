-- Drop existing tables if they exist
DROP TABLE IF EXISTS Attendance;
DROP TABLE IF EXISTS Employees;

--  Create Employees table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    department VARCHAR(50)
);

--  Create Attendance table
CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    check_in TIME NOT NULL,
    check_out TIME,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    UNIQUE (employee_id, attendance_date)
);

-- Insert sample employees
INSERT INTO Employees (name, email, department) VALUES
('Aarav Mehta', 'aarav@example.com', 'IT'),
('Neha Sharma', 'neha@example.com', 'HR'),
('Rohan Das', 'rohan@example.com', 'Finance');

-- Record daily attendance using transaction
START TRANSACTION;

INSERT INTO Attendance (employee_id, attendance_date, check_in, check_out) VALUES
(1, '2025-08-01', '08:55:00', '17:30:00'),
(2, '2025-08-01', '09:10:00', '17:00:00'),
(3, '2025-08-01', '09:05:00', '16:45:00');

COMMIT;

-- Use BETWEEN to find late check-ins (after 9:00 AM)
SELECT 
    e.name,
    a.attendance_date,
    a.check_in
FROM Attendance a
JOIN Employees e ON a.employee_id = e.employee_id
WHERE a.check_in BETWEEN '09:01:00' AND '12:00:00';

-- Subquery: Find most punctual employee (earliest average check-in)
SELECT name, avg_check_in
FROM (
    SELECT 
        e.name,
        SEC_TO_TIME(AVG(TIME_TO_SEC(a.check_in))) AS avg_check_in
    FROM Attendance a
    JOIN Employees e ON a.employee_id = e.employee_id
    GROUP BY e.employee_id
) AS punctuality
ORDER BY avg_check_in ASC
LIMIT 1;
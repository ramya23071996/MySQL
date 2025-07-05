-- 🔁 Drop existing tables if they exist
DROP TABLE IF EXISTS Attendance;
DROP TABLE IF EXISTS Employees;

-- 👤 Create Employees table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    department VARCHAR(50)
);

-- 🗓️ Create Attendance table
CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    check_in_time TIME NOT NULL,
    check_out_time TIME,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    CHECK (check_out_time IS NULL OR check_out_time >= check_in_time),
    UNIQUE (employee_id, attendance_date) -- Prevent duplicate entries per day
);

-- 👥 Insert sample employees
INSERT INTO Employees (name, email, department) VALUES
('Amit Sharma', 'amit.sharma@company.com', 'IT'),
('Priya Nair', 'priya.nair@company.com', 'HR'),
('Karan Mehta', 'karan.mehta@company.com', 'Finance');

-- 🔄 Insert multiple attendance records using a transaction
START TRANSACTION;

-- Step 1: Insert attendance for Amit
INSERT INTO Attendance (employee_id, attendance_date, check_in_time, check_out_time)
VALUES (1, '2025-07-15', '09:00:00', '17:30:00');

-- Step 2: Insert attendance for Priya
INSERT INTO Attendance (employee_id, attendance_date, check_in_time, check_out_time)
VALUES (2, '2025-07-15', '09:15:00', '17:00:00');

-- Step 3: Insert attendance for Karan
INSERT INTO Attendance (employee_id, attendance_date, check_in_time, check_out_time)
VALUES (3, '2025-07-15', '08:45:00', '16:45:00');

-- ✅ Commit if all successful
COMMIT;

-- ✏️ Update check-out time (e.g., corrected by employee)
UPDATE Attendance
SET check_out_time = '18:00:00'
WHERE employee_id = 1 AND attendance_date = '2025-07-15';

-- ❌ Delete invalid entries (e.g., check-out before check-in or null check-in)
DELETE FROM Attendance
WHERE check_out_time < check_in_time OR check_in_time IS NULL;
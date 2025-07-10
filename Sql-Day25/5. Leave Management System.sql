-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS LeaveDB;
USE LeaveDB;

-- Step 2: Create tables

-- Teams table
CREATE TABLE IF NOT EXISTS Teams (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(100),
    lead_id INT
);

-- Employees table
CREATE TABLE IF NOT EXISTS Employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(100),
    team_id INT,
    total_leaves INT DEFAULT 30,
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

-- LeaveBalance table
CREATE TABLE IF NOT EXISTS LeaveBalance (
    emp_id INT PRIMARY KEY,
    remaining_leaves INT,
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

-- LeaveRequests table
CREATE TABLE IF NOT EXISTS LeaveRequests (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    leave_days INT,
    status VARCHAR(20) DEFAULT 'Pending',
    request_date DATE DEFAULT CURDATE(),
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

-- Step 3: Insert teams and leads
INSERT INTO Teams (team_id, team_name, lead_id) VALUES
(1, 'Engineering', 1),
(2, 'Marketing', 2),
(3, 'Sales', 3),
(4, 'HR', 4),
(5, 'Support', 5);

-- Step 4: Insert 50 employees
INSERT INTO Employees (emp_name, team_id) VALUES
('Ramya', 1), ('Karthik', 2), ('Diya', 1), ('Rohan', 2), ('Meera', 3),
('Vikram', 3), ('Sneha', 4), ('Arjun', 4), ('Priya', 5), ('Yash', 5),
('Neha', 1), ('Manav', 2), ('Tanya', 3), ('Pooja', 4), ('Nikhil', 5),
('Ritika', 1), ('Sahil', 2), ('Divya', 3), ('Amit', 4), ('Kavya', 5),
('Harsh', 1), ('Simran', 2), ('Ravi', 3), ('Bhavna', 4), ('Deepak', 5),
('Ayesha', 1), ('Gaurav', 2), ('Naina', 3), ('Suresh', 4), ('Lavanya', 5),
('Tarun', 1), ('Ira', 2), ('Mohit', 3), ('Rekha', 4), ('Ajay', 5),
('Pallavi', 1), ('Dev', 2), ('Shreya', 3), ('Ramesh', 4), ('Anita', 5),
('Vikas', 1), ('Maya', 2), ('Nitin', 3), ('Preeti', 4), ('Raj', 5),
('Swati', 1), ('Kiran', 2), ('Tejas', 3), ('Anu', 4), ('Zara', 5);

-- Step 5: Initialize leave balances
INSERT INTO LeaveBalance (emp_id, remaining_leaves)
SELECT emp_id, 30 FROM Employees;

-- Step 6: Create trigger to auto-update LeaveBalance
DROP TRIGGER IF EXISTS UpdateLeaveBalance;

DELIMITER //
CREATE TRIGGER UpdateLeaveBalance
AFTER INSERT ON LeaveRequests
FOR EACH ROW
BEGIN
    UPDATE LeaveBalance
    SET remaining_leaves = remaining_leaves - NEW.leave_days
    WHERE emp_id = NEW.emp_id;
END;
//
DELIMITER ;

-- Step 7: Create view for team leads to see their team’s requests
CREATE OR REPLACE VIEW TeamLeaveRequests AS
SELECT 
    lr.request_id, e.emp_name, lr.leave_days, lr.status, t.team_name
FROM LeaveRequests lr
JOIN Employees e ON lr.emp_id = e.emp_id
JOIN Teams t ON e.team_id = t.team_id
WHERE t.lead_id = e.emp_id; -- Replace with session-based filtering in real apps

-- Step 8: Create stored procedure to approve/reject leave
DELIMITER //
CREATE PROCEDURE UpdateLeaveStatus(
    IN req_id INT,
    IN new_status VARCHAR(20)
)
BEGIN
    UPDATE LeaveRequests
    SET status = new_status
    WHERE request_id = req_id;
END;
//
DELIMITER ;

-- Step 9: Create function to check remaining leave
DELIMITER //
CREATE FUNCTION GetRemainingLeave(emp INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE rem INT;
    SELECT remaining_leaves INTO rem FROM LeaveBalance WHERE emp_id = emp;
    RETURN rem;
END;
//
DELIMITER ;

-- Step 10: Insert sample leave requests
INSERT INTO LeaveRequests (emp_id, leave_days) VALUES
(3, 2), (4, 1), (5, 3), (6, 2), (7, 1),
(8, 2), (9, 1), (10, 3), (11, 2), (12, 1),
(13, 2), (14, 1), (15, 3), (16, 2), (17, 1),
(18, 2), (19, 1), (20, 3), (21, 2), (22, 1);
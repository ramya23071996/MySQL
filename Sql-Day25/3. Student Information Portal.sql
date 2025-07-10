-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS EduPortal;
USE EduPortal;

-- Step 2: Create tables
CREATE TABLE IF NOT EXISTS Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(100),
    batch_year INT,
    cgpa DECIMAL(3,2),
    fees_paid DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS StudentLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    action VARCHAR(50),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 3: Insert 50 sample students
INSERT INTO Students (student_name, batch_year, cgpa, fees_paid) VALUES
('Aarav', 2021, 8.5, 50000), ('Diya', 2022, 9.1, 52000), ('Rohan', 2023, 7.8, 48000),
('Meera', 2021, 8.2, 51000), ('Karan', 2022, 9.0, 53000), ('Sneha', 2023, 7.5, 47000),
('Vikram', 2021, 8.7, 50000), ('Anjali', 2022, 9.3, 54000), ('Rahul', 2023, 7.6, 46000),
('Priya', 2021, 8.1, 49500), ('Neha', 2022, 9.2, 52500), ('Arjun', 2023, 7.9, 47500),
('Ishita', 2021, 8.4, 50500), ('Manav', 2022, 9.0, 51500), ('Tanya', 2023, 7.7, 46500),
('Yash', 2021, 8.6, 50000), ('Pooja', 2022, 9.1, 53000), ('Nikhil', 2023, 7.8, 47000),
('Ritika', 2021, 8.3, 51000), ('Sahil', 2022, 9.2, 52000), ('Divya', 2023, 7.6, 46000),
('Amit', 2021, 8.5, 49500), ('Kavya', 2022, 9.0, 52500), ('Harsh', 2023, 7.7, 47500),
('Simran', 2021, 8.2, 50500), ('Ravi', 2022, 9.3, 53500), ('Bhavna', 2023, 7.9, 46500),
('Deepak', 2021, 8.4, 50000), ('Ayesha', 2022, 9.1, 54000), ('Gaurav', 2023, 7.5, 45500),
('Naina', 2021, 8.6, 51000), ('Suresh', 2022, 9.2, 52000), ('Lavanya', 2023, 7.8, 47000),
('Tarun', 2021, 8.3, 49500), ('Ira', 2022, 9.0, 53000), ('Mohit', 2023, 7.6, 46000),
('Rekha', 2021, 8.1, 50500), ('Ajay', 2022, 9.1, 51500), ('Pallavi', 2023, 7.7, 47500),
('Kriti', 2021, 8.5, 50000), ('Dev', 2022, 9.0, 52500), ('Shreya', 2023, 7.9, 46500),
('Ramesh', 2021, 8.4, 51000), ('Anita', 2022, 9.2, 53500), ('Vikas', 2023, 7.8, 47000),
('Maya', 2021, 8.6, 49500), ('Nitin', 2022, 9.3, 54000), ('Preeti', 2023, 7.5, 45500),
('Raj', 2021, 8.2, 50500), ('Swati', 2022, 9.1, 52000);

-- Step 4: Create views for role-based access

-- View for students: see only grades
CREATE OR REPLACE VIEW StudentGradesView AS
SELECT student_id, student_name, cgpa FROM Students;

-- View for admins: see only fees
CREATE OR REPLACE VIEW AdminFeesView AS
SELECT student_id, student_name, fees_paid FROM Students;

-- Step 5: Stored procedure to fetch students by batch year
DELIMITER //
CREATE PROCEDURE GetStudentsByBatch(IN year INT)
BEGIN
    SELECT * FROM Students WHERE batch_year = year;
END;
//
DELIMITER ;

-- Step 6: Function to return CGPA for a student
DELIMITER //
CREATE FUNCTION GetCGPA(sid INT) RETURNS DECIMAL(3,2)
DETERMINISTIC
BEGIN
    DECLARE result DECIMAL(3,2);
    SELECT cgpa INTO result FROM Students WHERE student_id = sid;
    RETURN result;
END;
//
DELIMITER ;

-- Step 7: Trigger to log new student insertions
DELIMITER //
CREATE TRIGGER LogNewStudent
AFTER INSERT ON Students
FOR EACH ROW
BEGIN
    INSERT INTO StudentLog(student_id, action)
    VALUES (NEW.student_id, 'INSERT');
END;
//
DELIMITER ;

-- Step 8: Drop outdated views (e.g., after semester ends)
DROP VIEW IF EXISTS StudentGradesView;
DROP VIEW IF EXISTS AdminFeesView;

-- Recreate views after drop (optional)
CREATE OR REPLACE VIEW StudentGradesView AS
SELECT student_id, student_name, cgpa FROM Students;

CREATE OR REPLACE VIEW AdminFeesView AS
SELECT student_id, student_name, fees_paid FROM Students;
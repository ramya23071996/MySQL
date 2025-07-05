-- 🔁 Drop existing tables if they exist
DROP TABLE IF EXISTS Registrations;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Courses;

-- 🏗️ Create Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- 🏗️ Create Courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    max_capacity INT NOT NULL CHECK (max_capacity > 0),
    seats_remaining INT NOT NULL CHECK (seats_remaining >= 0)
);

-- 🏗️ Create Registrations table
CREATE TABLE Registrations (
    registration_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    registration_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    UNIQUE (student_id, course_id)
);

-- 👤 Insert sample students
INSERT INTO Students (name, email) VALUES
('Aarav Singh', 'aarav.singh@example.com'),
('Meera Iyer', 'meera.iyer@example.com'),
('Rohan Das', 'rohan.das@example.com');

-- 📘 Insert sample courses
INSERT INTO Courses (course_name, max_capacity, seats_remaining) VALUES
('Database Systems', 2, 2),
('Operating Systems', 3, 3);

-- 🔄 Register a student using transaction (with rollback if no seats)
START TRANSACTION;

-- Step 1: Check if seats are available
-- (This logic is simplified for SQL script; in production, use stored procedures or app logic)
UPDATE Courses
SET seats_remaining = seats_remaining - 1
WHERE course_id = 1 AND seats_remaining > 0;

-- Step 2: Check if update succeeded
-- If no rows were affected, rollback
-- (Simulated using row count check in application logic or stored procedure)

-- Step 3: Register student
INSERT INTO Registrations (student_id, course_id)
VALUES (1, 1);

-- ✅ Commit if all successful
COMMIT;

-- 🔄 Register another student
START TRANSACTION;
UPDATE Courses SET seats_remaining = seats_remaining - 1 WHERE course_id = 1 AND seats_remaining > 0;
INSERT INTO Registrations (student_id, course_id) VALUES (2, 1);
COMMIT;

-- ❌ Attempt to overbook (should fail due to no seats left)
-- START TRANSACTION;
-- UPDATE Courses SET seats_remaining = seats_remaining - 1 WHERE course_id = 1 AND seats_remaining > 0;
-- INSERT INTO Registrations (student_id, course_id) VALUES (3, 1); -- Will not insert if no seats
-- COMMIT;

-- ❌ Delete a dropped registration
DELETE FROM Registrations WHERE student_id = 2 AND course_id = 1;

-- ✅ Restore seat after drop
UPDATE Courses SET seats_remaining = seats_remaining + 1 WHERE course_id = 1;
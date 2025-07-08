-- 🎓 Create Database and Tables
CREATE DATABASE IF NOT EXISTS UniversityDB;
USE UniversityDB;

-- Courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    max_capacity INT NOT NULL CHECK (max_capacity > 0)
);

-- Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL
);

-- Enrollments table
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- 📝 Insert Sample Data
INSERT INTO Courses VALUES 
(101, 'Database Systems', 2),
(102, 'Operating Systems', 3),
(103, 'Computer Networks', 2);

INSERT INTO Students VALUES 
(1, 'Ramya'), (2, 'Arun'), (3, 'Priya'), (4, 'Kiran');

INSERT INTO Enrollments VALUES 
(1001, 1, 101),
(1002, 2, 101),
(1003, 3, 102);

-- 📊 Check Current Enrollment per Course
SELECT 
    c.course_id,
    c.course_name,
    c.max_capacity,
    COUNT(e.student_id) AS enrolled_students
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name, c.max_capacity;

-- 🚫 Subquery: Find Over-Capacity Courses
SELECT course_id, course_name
FROM Courses
WHERE course_id IN (
    SELECT e.course_id
    FROM Enrollments e
    GROUP BY e.course_id
    HAVING COUNT(*) >= (
        SELECT max_capacity FROM Courses WHERE course_id = e.course_id
    )
);

-- ✅ Controlled Insert with Validation Logic (Example: Enroll student 4 in course 102)
-- Step 1: Check if course has space
SELECT 
    c.course_id,
    c.course_name,
    c.max_capacity,
    COUNT(e.student_id) AS current_enrollment
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
WHERE c.course_id = 102
GROUP BY c.course_id, c.course_name, c.max_capacity
HAVING COUNT(e.student_id) < c.max_capacity;

-- Step 2: If result returned, proceed with insert
-- (Assume validation passed)
INSERT INTO Enrollments (enrollment_id, student_id, course_id)
VALUES (1004, 4, 102);
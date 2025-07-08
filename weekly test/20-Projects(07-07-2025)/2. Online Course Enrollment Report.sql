-- 🎓 Create Database and Tables
CREATE DATABASE IF NOT EXISTS EduPlatform;
USE EduPlatform;

-- Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL
);

-- Courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL
);

-- Enrollments table
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Grades table
CREATE TABLE Grades (
    grade_id INT PRIMARY KEY,
    enrollment_id INT,
    score DECIMAL(5,2) NOT NULL CHECK (score >= 0),
    FOREIGN KEY (enrollment_id) REFERENCES Enrollments(enrollment_id)
);

-- 📝 Insert Sample Data
INSERT INTO Students VALUES 
(1, 'Ramya'), (2, 'Arun'), (3, 'Priya'), (4, 'Kiran'), (5, 'Divya');

INSERT INTO Courses VALUES 
(101, 'SQL Basics'), (102, 'Python Programming'), (103, 'Data Structures');

INSERT INTO Enrollments VALUES 
(1001, 1, 101), (1002, 2, 101), (1003, 3, 101),
(1004, 1, 102), (1005, 4, 102), (1006, 5, 102),
(1007, 2, 103), (1008, 3, 103), (1009, 4, 103), (1010, 5, 103),
(1011, 1, 103), (1012, 3, 102);

INSERT INTO Grades VALUES 
(201, 1001, 85), (202, 1002, 78), (203, 1003, 92),
(204, 1004, 88), (205, 1005, 76), (206, 1006, 90),
(207, 1007, 70), (208, 1008, 95), (209, 1009, 60),
(210, 1010, 80), (211, 1011, 89), (212, 1012, 91);

-- 🔗 JOIN: Student and Course Data
SELECT s.student_name, c.course_name, g.score
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
JOIN Grades g ON e.enrollment_id = g.enrollment_id;

-- 📈 Subquery: Students Scoring Above Course Average
SELECT s.student_name, c.course_name, g.score
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
JOIN Grades g ON e.enrollment_id = g.enrollment_id
WHERE g.score > (
    SELECT AVG(g2.score)
    FROM Enrollments e2
    JOIN Grades g2 ON e2.enrollment_id = g2.enrollment_id
    WHERE e2.course_id = e.course_id
);

-- 📊 GROUP BY + HAVING: Courses with More Than 10 Enrollments
SELECT c.course_name, COUNT(*) AS total_enrollments
FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
HAVING COUNT(*) > 10;
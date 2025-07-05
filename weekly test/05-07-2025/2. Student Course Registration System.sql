--  Drop existing tables if they exist
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Courses;

--  Create Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    dob DATE
);

--  Create Courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    credits INT NOT NULL CHECK (credits > 0)
);

--  Create Enrollments table
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    UNIQUE (student_id, course_id) -- Prevent duplicate enrollments
);

--  Insert sample students
INSERT INTO Students (name, email, dob) VALUES
('Aarav Nair', 'aarav.nair@example.com', '2003-05-12'),
('Meera Joshi', 'meera.joshi@example.com', '2002-11-30'),
('Rohan Das', 'rohan.das@example.com', '2004-01-20');

-- Insert sample courses
INSERT INTO Courses (course_name, department, credits) VALUES
('Database Systems', 'CS', 4),
('Linear Algebra', 'Math', 3),
('Operating Systems', 'CS', 4),
('Microeconomics', 'Economics', 3);

--  Register students using a transaction
START TRANSACTION;

-- Step 1: Enroll Aarav in Database Systems
INSERT INTO Enrollments (student_id, course_id) VALUES (1, 1);

-- Step 2: Enroll Meera in Linear Algebra
INSERT INTO Enrollments (student_id, course_id) VALUES (2, 2);

-- Optional: Simulate failure (e.g., duplicate enrollment)
-- INSERT INTO Enrollments (student_id, course_id) VALUES (1, 1); -- Will fail

--  Commit if all successful
COMMIT;

--  JOIN: Show student-course mapping
SELECT s.name AS student_name, c.course_name, c.department
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_id = c.course_id;

--  Filtering examples
-- 1. Students enrolled in CS courses
SELECT DISTINCT s.name
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE c.department = 'CS';

-- 2. Courses with credits BETWEEN 3 AND 4
SELECT * FROM Courses
WHERE credits BETWEEN 3 AND 4;

-- 3. Students with email LIKE '%das%'
SELECT * FROM Students
WHERE email LIKE '%das%';

--  Aggregate: Count of students per course
SELECT c.course_name, COUNT(e.student_id) AS total_enrolled
FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.course_name;

-- 1. Create Tables

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100)
);

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100)
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade DECIMAL(5,2),  -- Assume passing grade is >= 50
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- 2. Insert Sample Data

-- Courses
INSERT INTO courses (course_id, course_name) VALUES
(1, 'Mathematics'),
(2, 'Physics'),
(3, 'Literature'),
(4, 'Philosophy');

-- Students
INSERT INTO students (student_id, student_name) VALUES
(101, 'Ananya'),
(102, 'Bharat'),
(103, 'Charu'),
(104, 'Dev');

-- Enrollments
INSERT INTO enrollments (enrollment_id, student_id, course_id, grade) VALUES
(1001, 101, 1, 78.5),
(1002, 102, 1, 65.0),
(1003, 103, 2, 88.0),
(1004, 104, 2, 91.0),
(1005, 101, 3, 45.0),
(1006, 102, 3, 55.0);

-- 3. Number of Students per Course
SELECT 
    c.course_name,
    COUNT(e.student_id) AS student_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- 4. Courses with No Enrollments
SELECT 
    c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;

-- 5. Courses Where All Students Passed (Assume passing grade is >= 50)
SELECT 
    c.course_name
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING MIN(e.grade) >= 50;
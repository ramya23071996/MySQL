-- 1. Create Tables
CREATE TABLE classes (
    class_id INT PRIMARY KEY,
    class_name VARCHAR(100)
);

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100)
);

CREATE TABLE grades (
    student_id INT,
    class_id INT,
    grade DECIMAL(5,2),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

-- 2. Insert Sample Data

-- Classes
INSERT INTO classes (class_id, class_name) VALUES
(1, 'Mathematics'),
(2, 'Science'),
(3, 'History');

-- Students
INSERT INTO students (student_id, student_name) VALUES
(201, 'Arjun'),
(202, 'Bhavna'),
(203, 'Chitra'),
(204, 'Deepak');

-- Grades
INSERT INTO grades (student_id, class_id, grade) VALUES
(201, 1, 85.5),
(201, 2, 78.0),
(202, 1, 92.0),
(202, 3, 88.5),
(203, 2, 60.0),
(203, 3, 72.5),
(204, 1, 55.0),
(204, 2, 49.5),
(204, 3, 65.0);

-- 3. Average Grade per Student
SELECT 
    s.student_name,
    AVG(g.grade) AS avg_grade
FROM students s
JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_name;

-- 4. Average Grade per Class
SELECT 
    c.class_name,
    AVG(g.grade) AS avg_grade
FROM classes c
JOIN grades g ON c.class_id = g.class_id
GROUP BY c.class_name;

-- 5. Classes with Average Grade Below a Threshold
SELECT 
    c.class_name,
    AVG(g.grade) AS avg_grade
FROM classes c
JOIN grades g ON c.class_id = g.class_id
GROUP BY c.class_name
HAVING avg_grade < 70;

-- 6. Student(s) with Highest and Lowest Grade
-- Highest Grade
SELECT 
    s.student_name,
    g.grade
FROM students s
JOIN grades g ON s.student_id = g.student_id
ORDER BY g.grade DESC
LIMIT 1;

-- Lowest Grade
SELECT 
    s.student_name,
    g.grade
FROM students s
JOIN grades g ON s.student_id = g.student_id
ORDER BY g.grade ASC
LIMIT 1;
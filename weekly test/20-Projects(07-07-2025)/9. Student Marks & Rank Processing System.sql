-- 🎓 Create Database and Tables
CREATE DATABASE IF NOT EXISTS SchoolDB;
USE SchoolDB;

-- Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL
);

-- Subjects table
CREATE TABLE Subjects (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL
);

-- Marks table
CREATE TABLE Marks (
    mark_id INT PRIMARY KEY,
    student_id INT,
    subject_id INT,
    score INT NOT NULL CHECK (score >= 0 AND score <= 100),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
);

-- 📝 Insert Sample Data
INSERT INTO Students VALUES 
(1, 'Ramya'), (2, 'Arun'), (3, 'Priya'), (4, 'Kiran');

INSERT INTO Subjects VALUES 
(101, 'Math'), (102, 'Science'), (103, 'English');

INSERT INTO Marks VALUES 
(1, 1, 101, 95), (2, 1, 102, 88), (3, 1, 103, 92),
(4, 2, 101, 78), (5, 2, 102, 85), (6, 2, 103, 80),
(7, 3, 101, 90), (8, 3, 102, 91), (9, 3, 103, 89),
(10, 4, 101, 60), (11, 4, 102, 70), (12, 4, 103, 65);

-- 📊 Total Marks per Student
SELECT 
    s.student_id,
    s.student_name,
    SUM(m.score) AS total_marks
FROM Students s
JOIN Marks m ON s.student_id = m.student_id
GROUP BY s.student_id, s.student_name;

-- 🏆 Ranking Students by Total Marks (using subquery)
SELECT 
    student_id,
    student_name,
    total_marks,
    RANK() OVER (ORDER BY total_marks DESC) AS rank_position
FROM (
    SELECT 
        s.student_id,
        s.student_name,
        SUM(m.score) AS total_marks
    FROM Students s
    JOIN Marks m ON s.student_id = m.student_id
    GROUP BY s.student_id, s.student_name
) AS totals;

-- 🎯 Assign Grades Using CASE
SELECT 
    s.student_name,
    sub.subject_name,
    m.score,
    CASE 
        WHEN m.score >= 90 THEN 'A'
        WHEN m.score >= 75 THEN 'B'
        WHEN m.score >= 60 THEN 'C'
        ELSE 'D'
    END AS grade
FROM Marks m
JOIN Students s ON m.student_id = s.student_id
JOIN Subjects sub ON m.subject_id = sub.subject_id
ORDER BY s.student_name, sub.subject_name;
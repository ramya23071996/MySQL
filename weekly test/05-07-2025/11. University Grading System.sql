-- Drop existing tables if they exist
DROP TABLE IF EXISTS Marks;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Subjects;

-- Create Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Create Subjects table
CREATE TABLE Subjects (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL CHECK (credits > 0)
);

-- Create Marks table
CREATE TABLE Marks (
    mark_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    marks INT NOT NULL CHECK (marks BETWEEN 0 AND 100),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id),
    UNIQUE (student_id, subject_id)
);

-- Insert sample students
INSERT INTO Students (name, email) VALUES
('Aarav Mehta', 'aarav@example.com'),
('Neha Sharma', 'neha@example.com'),
('Rohan Das', 'rohan@example.com');

-- Insert sample subjects
INSERT INTO Subjects (subject_name, credits) VALUES
('Mathematics', 4),
('Physics', 3),
('Computer Science', 4);

--  Insert marks
INSERT INTO Marks (student_id, subject_id, marks) VALUES
(1, 1, 85), (1, 2, 78), (1, 3, 92),
(2, 1, 88), (2, 2, 91), (2, 3, 84),
(3, 1, 70), (3, 2, 65), (3, 3, 75);

--  Use CASE to convert marks to grades
SELECT 
    s.name,
    sub.subject_name,
    m.marks,
    CASE 
        WHEN m.marks >= 90 THEN 'A+'
        WHEN m.marks >= 80 THEN 'A'
        WHEN m.marks >= 70 THEN 'B'
        WHEN m.marks >= 60 THEN 'C'
        ELSE 'F'
    END AS grade
FROM Marks m
JOIN Students s ON m.student_id = s.student_id
JOIN Subjects sub ON m.subject_id = sub.subject_id;

--  Use AVG() to calculate GPA per student
SELECT 
    s.name,
    ROUND(AVG(m.marks), 2) AS average_marks
FROM Marks m
JOIN Students s ON m.student_id = s.student_id
GROUP BY s.student_id;

--  JOIN for full report card
SELECT 
    s.name AS student_name,
    sub.subject_name,
    m.marks
FROM Marks m
JOIN Students s ON m.student_id = s.student_id
JOIN Subjects sub ON m.subject_id = sub.subject_id
ORDER BY s.name, sub.subject_name;

--  HAVING: Show top-performing students (GPA > 85)
SELECT 
    s.name,
    ROUND(AVG(m.marks), 2) AS gpa
FROM Marks m
JOIN Students s ON m.student_id = s.student_id
GROUP BY s.student_id
HAVING gpa > 85;

--  Subquery: Top scorer in each subject
SELECT 
    sub.subject_name,
    s.name AS top_scorer,
    m.marks
FROM Marks m
JOIN Students s ON m.student_id = s.student_id
JOIN Subjects sub ON m.subject_id = sub.subject_id
WHERE (m.subject_id, m.marks) IN (
    SELECT subject_id, MAX(marks)
    FROM Marks
    GROUP BY subject_id
);
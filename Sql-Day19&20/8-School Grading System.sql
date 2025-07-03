CREATE DATABASE SchoolGradingDB;
USE SchoolGradingDB;

-- Students table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(100)
);

-- Subjects table
CREATE TABLE Subjects (
    SubjectID INT PRIMARY KEY,
    SubjectName VARCHAR(100)
);

-- Grades table
CREATE TABLE Grades (
    GradeID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    SubjectID INT,
    Grade DECIMAL(5,2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

-- Students
INSERT INTO Students VALUES
(1, 'Aarav Mehta'),
(2, 'Diya Sharma'),
(3, 'Rohan Iyer');

-- Subjects
INSERT INTO Subjects VALUES
(101, 'Mathematics'),
(102, 'Science'),
(103, 'History');

-- Grades
INSERT INTO Grades (StudentID, SubjectID, Grade) VALUES
(1, 101, 92.5),
(1, 102, 88.0),
(1, 103, 76.0),
(2, 101, 95.0),
(2, 102, 67.5),
(2, 103, 82.0),
(3, 101, 58.0),
(3, 102, 72.0),
(3, 103, 49.0);

SELECT S.SubjectName, ST.Name AS TopStudent, G.Grade
FROM Grades G
JOIN Students ST ON G.StudentID = ST.StudentID
JOIN Subjects S ON G.SubjectID = S.SubjectID
WHERE (G.SubjectID, G.Grade) IN (
    SELECT SubjectID, MAX(Grade)
    FROM Grades
    GROUP BY SubjectID
);

SELECT ST.Name, SU.SubjectName, G.Grade
FROM Grades G
JOIN Students ST ON G.StudentID = ST.StudentID
JOIN Subjects SU ON G.SubjectID = SU.SubjectID
WHERE G.Grade < 60;
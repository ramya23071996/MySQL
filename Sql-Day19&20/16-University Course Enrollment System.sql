-- Create the database
CREATE DATABASE IF NOT EXISTS UniversityDB;
USE UniversityDB;

-- Drop tables if they already exist
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Students;

-- Create Students table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100)
);

-- Create Courses table
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    Title VARCHAR(100),
    Credits INT
);

-- Create Enrollments table
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Insert sample students
INSERT INTO Students VALUES
(1, 'Aarav Mehta', 'aarav@example.com'),
(2, 'Diya Sharma', 'diya@example.com'),
(3, 'Rohan Iyer', 'rohan@example.com');

-- Insert sample courses
INSERT INTO Courses VALUES
(101, 'Mathematics', 4),
(102, 'Physics', 3),
(103, 'Chemistry', 3),
(104, 'History', 2),
(105, 'Computer Science', 4);

-- Insert sample enrollments
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate) VALUES
(1, 101, '2025-07-01'),
(1, 102, '2025-07-01'),
(1, 105, '2025-07-01'),
(2, 101, '2025-07-02'),
(2, 103, '2025-07-02'),
(3, 102, '2025-07-03');

-- Query 1: Courses with no enrollments
SELECT C.CourseID, C.Title
FROM Courses C
WHERE C.CourseID NOT IN (
    SELECT DISTINCT CourseID FROM Enrollments
);

-- Query 2: Students enrolled in more than 2 courses
SELECT S.Name, COUNT(*) AS CourseCount
FROM Enrollments E
JOIN Students S ON E.StudentID = S.StudentID
GROUP BY E.StudentID
HAVING CourseCount > 2;
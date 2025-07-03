CREATE DATABASE AttendanceDB;
USE AttendanceDB;

-- Students table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(100)
);

-- Courses table
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    Title VARCHAR(100)
);

-- Attendance table
CREATE TABLE Attendance (
    AttendanceID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    CourseID INT,
    Date DATE,
    Status ENUM('Present', 'Absent'),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Students
INSERT INTO Students VALUES
(1, 'Aarav Mehta'),
(2, 'Diya Sharma'),
(3, 'Rohan Iyer');

-- Courses
INSERT INTO Courses VALUES
(101, 'Mathematics'),
(102, 'Physics');

-- Attendance Records
INSERT INTO Attendance (StudentID, CourseID, Date, Status) VALUES
(1, 101, '2025-07-01', 'Present'),
(1, 101, '2025-07-02', 'Present'),
(1, 101, '2025-07-03', 'Absent'),
(2, 101, '2025-07-01', 'Present'),
(2, 101, '2025-07-02', 'Present'),
(2, 101, '2025-07-03', 'Present'),
(3, 101, '2025-07-01', 'Absent'),
(3, 101, '2025-07-02', 'Absent'),
(3, 101, '2025-07-03', 'Present');

SELECT 
    S.Name,
    C.Title,
    ROUND(SUM(A.Status = 'Present') / COUNT(*) * 100, 2) AS AttendancePercentage
FROM Attendance A
JOIN Students S ON A.StudentID = S.StudentID
JOIN Courses C ON A.CourseID = C.CourseID
GROUP BY A.StudentID, A.CourseID
HAVING AttendancePercentage > 90;

SELECT S.Name, C.Title
FROM Attendance A
JOIN Students S ON A.StudentID = S.StudentID
JOIN Courses C ON A.CourseID = C.CourseID
WHERE A.Date = '2025-07-03' AND A.Status = 'Absent';
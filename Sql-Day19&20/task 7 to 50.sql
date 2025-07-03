-- 7. Create a new database called School
CREATE DATABASE School;

-- Use the School database
USE School;

-- 8. Create a table called Students
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Department VARCHAR(50)
);

-- 9. Create a table called Courses
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    Title VARCHAR(100),
    Credits INT
);

-- 10. Insert three records into the Students table
INSERT INTO Students (StudentID, Name, Age, Department)
VALUES
(1, 'Aarav Mehta', 20, 'Computer Science'),
(2, 'Diya Sharma', 19, 'Mechanical Engineering'),
(3, 'Rohan Iyer', 21, 'Electrical Engineering');

-- 11. Insert two records into the Courses table
INSERT INTO Courses (CourseID, Title, Credits)
VALUES
(101, 'Data Structures', 4),
(102, 'Thermodynamics', 3);

-- 12. Insert multiple records into the Students table using a single SQL statement
INSERT INTO Students (StudentID, Name, Age, Department)
VALUES
(4, 'Sneha Reddy', 22, 'Civil Engineering'),
(5, 'Karan Patel', 20, 'Information Technology'),
(6, 'Meera Nair', 18, 'Biotechnology');

-- 13.Write a SQL query to select all columns from the Students table.
SELECT * FROM Students;

-- 14.Write a query to select only the Name and Age columns from Students
SELECT Name, Age FROM Students;

-- 15.Write a query to select all records from Courses
SELECT * FROM Courses;

-- 16. Use SELECT DISTINCT to find unique departments from the Students table
SELECT DISTINCT Department FROM Students;

-- 17. Write a query to select all students who are older than 20.
SELECT * FROM Students WHERE Age > 20;

-- 18. Select all courses with more than 3 credits.
SELECT * FROM Courses WHERE Credits > 3;

-- 19. Retrieve students whose department is 'Computer Science'.
SELECT * FROM Students WHERE Department = 'Computer Science';

-- 20. Select students whose age is not equal to 18.
SELECT * FROM Students WHERE Age != 18;

-- 21. Use the LIKE operator to find students whose name starts with 'A'.
SELECT * FROM Students WHERE Name LIKE 'A%';

-- 22. Use the LIKE operator to find students whose name contains the letter 'n'.
SELECT * FROM Students WHERE Name LIKE '%n%';

-- 23. Find all students whose name is exactly four letters long.
SELECT * FROM Students WHERE Name LIKE '____';

-- 24. Retrieve students whose age is between 18 and 22 (inclusive).
SELECT * FROM Students WHERE Age BETWEEN 18 AND 22;

-- 25. Select all courses with CourseID in the list (101, 102, 105).
SELECT * FROM Courses WHERE CourseID IN (101, 102, 105);

-- 26. Find students who are NOT in the 'Physics' department
SELECT * FROM Students WHERE Department != 'Physics';

-- 27. Select students with NULL in the Department column.
SELECT * FROM Students WHERE Department IS NULL;

-- 28. Select students whose Department is NOT NULL
SELECT * FROM Students WHERE Department IS NOT NULL;	

-- 29. Students older than 18 AND in 'Mathematics'
SELECT * FROM Students
WHERE Age > 18 AND Department = 'Mathematics';

-- 30. Students in 'Biology' OR 'Chemistry'
SELECT * FROM Students
WHERE Department = 'Biology' OR Department = 'Chemistry';

-- 31. Students NOT in 'History' AND younger than 21
SELECT * FROM Students
WHERE Department != 'History' AND Age < 21;

-- 32. Students ordered by Name ASC
SELECT * FROM Students
ORDER BY Name ASC;

-- 33. Courses ordered by Credits DESC
SELECT * FROM Courses
ORDER BY Credits DESC;

-- 34. Students ordered by Department ASC, Age DESC
SELECT * FROM Students
ORDER BY Department ASC, Age DESC;

-- 35. First 5 students
SELECT * FROM Students
LIMIT 5;

-- 36. Top 3 courses with highest credits
SELECT * FROM Courses
ORDER BY Credits DESC
LIMIT 3;

-- 37. Add Email column to Students
ALTER TABLE Students
ADD Email VARCHAR(100);

-- 38. Update Email for a specific student
UPDATE Students
SET Email = 'aarav.mehta@example.com'
WHERE StudentID = 1;

-- 39. Delete students older than 25
DELETE FROM Students
WHERE Age > 25;

-- 40. Delete a course with specific CourseID
DELETE FROM Courses
WHERE CourseID = 105;

-- 41. Insert student without Department
INSERT INTO Students (StudentID, Name, Age)
VALUES (7, 'Nikhil Rao', 20);

-- 42. Find students without Department
SELECT * FROM Students
WHERE Department IS NULL;

-- 43. Change department for all students named 'Alex' to 'Engineering'
UPDATE Students
SET Department = 'Engineering'
WHERE Name = 'Alex';

-- 44. Increase all students’ ages by 1 year
UPDATE Students
SET Age = Age + 1;

-- 45. Students whose name ends with 'a'
SELECT * FROM Students
WHERE Name LIKE '%a';

-- 46. Students whose name contains 'ar'
SELECT * FROM Students
WHERE Name LIKE '%ar%';

-- 47. Names of students in 'Physics' or 'Mathematics', ordered by Age DESC
SELECT Name FROM Students
WHERE Department IN ('Physics', 'Mathematics')
ORDER BY Age DESC;

-- 48. Unique ages of students with a Department
SELECT DISTINCT Age FROM Students
WHERE Department IS NOT NULL;

-- 49. First 3 students in alphabetical order by Name
SELECT * FROM Students
ORDER BY Name ASC
LIMIT 3;

-- 50. Delete all students with NULL in Department
DELETE FROM Students
WHERE Department IS NULL;




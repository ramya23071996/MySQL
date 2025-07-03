CREATE DATABASE PayrollDB;
USE PayrollDB;

-- Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

-- Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    DepartmentID INT,
    JoinDate DATE,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Salaries table
CREATE TABLE Salaries (
    SalaryID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    BaseSalary DECIMAL(10,2),
    Bonus DECIMAL(10,2),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- Departments
INSERT INTO Departments VALUES
(1, 'Engineering'),
(2, 'Human Resources'),
(3, 'Finance');

-- Employees
INSERT INTO Employees VALUES
(101, 'Aarav Mehta', 1, '2022-01-10'),
(102, 'Diya Sharma', 1, '2021-03-15'),
(103, 'Rohan Iyer', 2, '2020-07-01'),
(104, 'Sneha Reddy', 3, '2023-02-20'),
(105, 'Karan Patel', 1, '2022-11-05'),
(106, 'Meera Nair', 2, '2021-08-30'),
(107, 'Nikhil Rao', 3, '2020-12-12'),
(108, 'Ananya Das', 1, '2023-01-25'),
(109, 'Vikram Singh', 2, '2022-06-18'),
(110, 'Isha Kapoor', 3, '2021-09-09');

-- Salaries
INSERT INTO Salaries (EmployeeID, BaseSalary, Bonus) VALUES
(101, 60000, 5000),
(102, 65000, 7000),
(103, 50000, 3000),
(104, 55000, 4000),
(105, 62000, 6000),
(106, 48000, 2000),
(107, 53000, 3500),
(108, 61000, 4500),
(109, 49000, 2500),
(110, 56000, 3000);

SELECT E.Name, D.DepartmentName, (S.BaseSalary + S.Bonus) AS TotalSalary
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
JOIN Salaries S ON E.EmployeeID = S.EmployeeID
WHERE D.DepartmentName = 'Engineering' AND (S.BaseSalary + S.Bonus) > 60000;

UPDATE Salaries
SET BaseSalary = BaseSalary * 1.10
WHERE EmployeeID IN (
    SELECT EmployeeID FROM Employees WHERE DepartmentID = 1
);
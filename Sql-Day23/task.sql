-- 1. Create Departments table
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) UNIQUE
);

INSERT INTO Departments (dept_id, dept_name) VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance');

-- 2. Create Employees table
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department INT,
    salary DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (department) REFERENCES Departments(dept_id)
);

INSERT INTO Employees (emp_id, name, department, salary) VALUES
(1, 'Alice', 1, 50000),
(2, 'Bob', 2, 60000),
(3, 'Charlie', 3, 45000),
(4, 'David', 2, 55000),
(5, 'Eve', 1, 47000);

-- 3. Insert with only emp_id and name
INSERT INTO Employees (emp_id, name, salary) VALUES (6, 'Frank', 0);

-- 4. Insert with columns in different order
INSERT INTO Employees (name, salary, emp_id, department) VALUES ('Grace', 52000, 7, 3);

-- 5. Multi-row insert
INSERT INTO Employees (emp_id, name, department, salary) VALUES
(8, 'Hannah', 1, 48000),
(9, 'Ian', 2, 51000);

-- 6. Insert without salary (should fail if NOT NULL)
-- INSERT INTO Employees (emp_id, name, department) VALUES (10, 'Jack', 2); -- Will fail

-- 7. Insert into non-existent department (should fail)
-- INSERT INTO Employees (emp_id, name, department, salary) VALUES (11, 'Kate', 99, 40000); -- Will fail

-- 8. Duplicate emp_id (should fail)
-- INSERT INTO Employees (emp_id, name, department, salary) VALUES (1, 'Leo', 1, 50000); -- Will fail

-- 9. Duplicate department name (should fail)
-- INSERT INTO Departments (dept_id, dept_name) VALUES (4, 'HR'); -- Will fail

-- 10. Create Attendance table
CREATE TABLE Attendance (
    att_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(10) DEFAULT 'Present',
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

INSERT INTO Attendance (emp_id) VALUES (1), (2), (3);

-- 11. Update salary for HR department
UPDATE Employees SET salary = salary + 5000 WHERE department = 1;

-- 12. Update department of emp_id = 2
UPDATE Employees SET department = 3 WHERE emp_id = 2;

-- 13. Update salary < 40000
UPDATE Employees SET salary = 45000 WHERE salary < 40000;

-- 14. Change name of emp_id = 3
UPDATE Employees SET name = 'Michael Scott' WHERE emp_id = 3;

-- 15. Increase IT department salaries by 10%
UPDATE Employees SET salary = salary * 1.10 WHERE department = 2;

-- 16. Set salary to NULL for Testing dept (assume dept_id = 4)
-- UPDATE Employees SET salary = NULL WHERE department = 4; -- Will fail if NOT NULL

-- 17. Update NULL departments to 'Admin' (assume dept_id = 5)
-- First insert Admin dept
INSERT INTO Departments (dept_id, dept_name) VALUES (5, 'Admin');
UPDATE Employees SET department = 5 WHERE department IS NULL;

-- 18. Update multiple columns
UPDATE Employees SET department = 2, salary = 60000 WHERE emp_id = 4;

-- 19. Update salaries above average
UPDATE Employees
SET salary = salary + 2000
WHERE salary > (SELECT AVG(salary) FROM Employees);

-- 20. Add bonus column and update
ALTER TABLE Employees ADD bonus DECIMAL(10,2);
UPDATE Employees SET bonus = salary * 0.05;

-- 21. Delete emp_id = 2
DELETE FROM Employees WHERE emp_id = 2;

-- 22. Delete all from Finance
DELETE FROM Employees WHERE department = 3;

-- 23. Delete salary < 30000
DELETE FROM Employees WHERE salary < 30000;

-- 24. Delete all rows
-- DELETE FROM Employees;

-- 25. Try deleting referenced department (should fail)
-- DELETE FROM Departments WHERE dept_id = 1; -- Will fail

-- 26. Add join_date column and delete before year
ALTER TABLE Employees ADD join_date DATE DEFAULT CURRENT_DATE;
UPDATE Employees SET join_date = '2020-01-01' WHERE emp_id = 1;
DELETE FROM Employees WHERE join_date < '2021-01-01';

-- 27. Delete all except HR
DELETE FROM Employees WHERE department NOT IN (1);

-- 28. Delete NULL department
DELETE FROM Employees WHERE department IS NULL;

-- 29. Delete and reinsert
DELETE FROM Employees WHERE emp_id = 5;
INSERT INTO Employees (emp_id, name, department, salary) VALUES (5, 'Eve', 1, 47000);

-- 30. Transaction rollback
START TRANSACTION;
DELETE FROM Employees WHERE emp_id = 1;
ROLLBACK;

-- 31. Already done in Task 1

-- 32. Already done in Task 2

-- 33. Add CHECK constraint
ALTER TABLE Employees ADD CONSTRAINT chk_salary CHECK (salary >= 3000);

-- 34. Already done in Task 2

-- 35. Insert NULL name (should fail)
-- INSERT INTO Employees (emp_id, name, department, salary) VALUES (12, NULL, 1, 40000); -- Will fail

-- 36. Salary below 3000 (should fail)
-- INSERT INTO Employees (emp_id, name, department, salary) VALUES (13, 'Zoe', 1, 2000); -- Will fail

-- 37. Duplicate dept_name (should fail)
-- INSERT INTO Departments (dept_id, dept_name) VALUES (6, 'HR'); -- Will fail

-- 38. Non-existent department
-- INSERT INTO Employees (emp_id, name, department, salary) VALUES (14, 'Nina', 99, 40000); -- Will fail

-- 39. Add constraint
ALTER TABLE Employees ADD CONSTRAINT emp_name_length CHECK (CHAR_LENGTH(name) >= 2);

-- 40. Drop constraint
-- For MySQL:
-- ALTER TABLE Employees DROP CHECK chk_salary;

-- 41. Insert and commit
START TRANSACTION;
INSERT INTO Employees (emp_id, name, department, salary) VALUES (15, 'Oscar', 1, 50000);
INSERT INTO Employees (emp_id, name, department, salary) VALUES (16, 'Pam', 2, 52000);
COMMIT;

-- 42. Update and rollback
START TRANSACTION;
UPDATE Employees SET salary = 70000 WHERE emp_id = 15;
ROLLBACK;

-- 43. Savepoint and rollback
START TRANSACTION;
INSERT INTO Employees (emp_id, name, department, salary) VALUES (17, 'Quinn', 3, 48000);
SAVEPOINT sp1;
UPDATE Employees SET salary = 49000 WHERE emp_id = 17;
ROLLBACK TO sp1;
COMMIT;

-- 44. Delete and commit
START TRANSACTION;
DELETE FROM Employees WHERE emp_id IN (15, 16);
COMMIT;

-- 45. Savepoints and rollback
START TRANSACTION;
UPDATE Employees SET salary = 60000 WHERE emp_id = 3;
SAVEPOINT sp1;
UPDATE Employees SET salary = 62000 WHERE emp_id = 3;
SAVEPOINT sp2;
ROLLBACK TO sp1;
COMMIT;

-- 46. Isolation test – requires two sessions

-- 47. Simulate error
START TRANSACTION;
INSERT INTO Employees (emp_id, name, department, salary) VALUES (18, 'Rita', 1, 50000);
-- INSERT INTO Employees (emp_id, name, department, salary) VALUES (1, 'Duplicate', 1, 50000); -- Will fail
ROLLBACK;

-- 48. Update all departments
START TRANSACTION;
UPDATE Departments SET dept_name = CONCAT(dept_name, '_Updated');
COMMIT;

-- 49. Partial failure
START TRANSACTION;
INSERT INTO Employees (emp_id, name, department, salary) VALUES (19, 'Steve', 1, 50000);
-- INSERT INTO Employees (emp_id, name, department, salary) VALUES (1, 'Duplicate', 1, 50000); -- Will fail
ROLLBACK;

-- 50. Transfer employee and log
CREATE TABLE TransferLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
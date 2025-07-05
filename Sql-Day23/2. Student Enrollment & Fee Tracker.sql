-- 🔁 Drop existing tables if they exist
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Courses;

-- 🏗️ Create Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    join_date DATE DEFAULT CURRENT_DATE
);

-- 🏗️ Create Courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    fee DECIMAL(10,2) NOT NULL CHECK (fee >= 0)
);

-- 🏗️ Create Enrollments table
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- 🏗️ Create Payments table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    fee_paid DECIMAL(10,2) NOT NULL CHECK (fee_paid >= 0),
    payment_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- 🧾 Insert sample students
INSERT INTO Students (name, email) VALUES
('Aarav Kumar', 'aarav@example.com'),
('Meera Sharma', 'meera@example.com'),
('Ravi Patel', 'ravi@example.com');

-- 🧾 Insert sample courses
INSERT INTO Courses (course_name, fee) VALUES
('Mathematics', 15000),
('Science', 18000),
('History', 12000);

-- 🧾 Enroll students in courses
INSERT INTO Enrollments (student_id, course_id) VALUES
(1, 1),
(1, 2),
(2, 2),
(3, 3);

-- 🧾 Record fee payments
INSERT INTO Payments (student_id, course_id, fee_paid) VALUES
(1, 1, 15000),
(1, 2, 18000),
(2, 2, 18000),
(3, 3, 12000);

-- ❌ Delete a dropped student (student_id = 3)
DELETE FROM Payments WHERE student_id = 3;
DELETE FROM Enrollments WHERE student_id = 3;
DELETE FROM Students WHERE student_id = 3;

-- 🔄 Transaction: Partial fee update with SAVEPOINT and ROLLBACK
START TRANSACTION;

-- ✅ Update first payment
UPDATE Payments SET fee_paid = 15000 WHERE student_id = 1 AND course_id = 1;
SAVEPOINT after_first_update;

-- ❌ Simulate an error (uncomment to test rollback)
-- UPDATE Payments SET fee_paid = -5000 WHERE student_id = 1 AND course_id = 2;

-- 🔁 Rollback if error occurs
-- ROLLBACK TO after_first_update;

-- ✅ Commit if all successful
COMMIT;
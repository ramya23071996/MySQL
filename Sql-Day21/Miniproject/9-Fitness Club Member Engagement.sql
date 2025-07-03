-- Drop tables if they already exist
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS classes;

-- 1. Create Tables

CREATE TABLE members (
    member_id INT PRIMARY KEY,
    member_name VARCHAR(100)
);

CREATE TABLE classes (
    class_id INT PRIMARY KEY,
    class_name VARCHAR(100)
);

CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY,
    member_id INT,
    class_id INT,
    attendance_date DATE,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

-- 2. Insert Sample Data

-- Members
INSERT INTO members (member_id, member_name) VALUES
(1, 'Aanya'),
(2, 'Bhavesh'),
(3, 'Chitra'),
(4, 'Dev');

-- Classes
INSERT INTO classes (class_id, class_name) VALUES
(101, 'Yoga'),
(102, 'Zumba'),
(103, 'Pilates');

-- Attendance Records
INSERT INTO attendance (attendance_id, member_id, class_id, attendance_date) VALUES
(1001, 1, 101, '2025-07-01'),
(1002, 1, 102, '2025-07-02'),
(1003, 2, 101, '2025-07-01'),
(1004, 2, 103, '2025-07-03'),
(1005, 3, 102, '2025-07-02'),
(1006, 3, 102, '2025-07-04');

-- 3. Count Class Attendance per Member
SELECT 
    m.member_name,
    COUNT(a.attendance_id) AS total_attendance
FROM members m
LEFT JOIN attendance a ON m.member_id = a.member_id
GROUP BY m.member_name;

-- 4. Members with No Attendance
SELECT 
    m.member_name
FROM members m
LEFT JOIN attendance a ON m.member_id = a.member_id
WHERE a.attendance_id IS NULL;

-- 5. Classes with Highest Average Attendance
-- (Assuming average attendance = total attendance / distinct days held)
SELECT 
    c.class_name,
    COUNT(a.attendance_id) / COUNT(DISTINCT a.attendance_date) AS avg_attendance_per_day
FROM classes c
JOIN attendance a ON c.class_id = a.class_id
GROUP BY c.class_id, c.class_name
ORDER BY avg_attendance_per_day DESC;
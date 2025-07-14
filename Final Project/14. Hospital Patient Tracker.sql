-- 1. Create Database
CREATE DATABASE hospital_tracker;
USE hospital_tracker;

-- 2. Patients Table
CREATE TABLE patients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    dob DATE
);

-- 3. Doctors Table
CREATE TABLE doctors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100)
);

-- 4. Visits Table (Prevent overlapping visits per doctor-time combo)
CREATE TABLE visits (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    visit_time DATETIME,
    FOREIGN KEY (patient_id) REFERENCES patients(id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id),
    UNIQUE (doctor_id, visit_time) -- Constraint to avoid overlap
);

-- 5. Insert Patients
INSERT INTO patients (name, dob) VALUES
('Ramya', '1994-05-20'),
('Arjun', '1992-08-15'),
('Sneha', '1996-12-03'),
('Kiran', '1990-04-28'),
('Meera', '1995-09-10');

-- 6. Insert Doctors
INSERT INTO doctors (name, specialization) VALUES
('Dr. Nair', 'Cardiology'),
('Dr. Roy', 'Dermatology'),
('Dr. Gupta', 'Orthopedics'),
('Dr. Verma', 'Neurology'),
('Dr. Das', 'Pediatrics');

-- 7. Insert Visits
INSERT INTO visits (patient_id, doctor_id, visit_time) VALUES
(1, 1, '2025-07-20 09:00:00'),
(2, 2, '2025-07-20 10:00:00'),
(3, 3, '2025-07-20 11:30:00'),
(4, 4, '2025-07-20 13:00:00'),
(5, 5, '2025-07-20 15:00:00'),
(1, 2, '2025-07-21 09:30:00'),
(2, 3, '2025-07-21 11:00:00'),
(3, 1, '2025-07-21 12:30:00'),
(4, 5, '2025-07-21 14:00:00'),
(5, 4, '2025-07-21 15:30:00');

-- 8. Query: Visits for a Specific Doctor
SELECT 
    d.name AS doctor,
    p.name AS patient,
    v.visit_time
FROM visits v
JOIN doctors d ON v.doctor_id = d.id
JOIN patients p ON v.patient_id = p.id
WHERE d.name = 'Dr. Nair'
ORDER BY v.visit_time;

-- 9. Query: Visits on a Specific Date
SELECT 
    d.name AS doctor,
    p.name AS patient,
    v.visit_time
FROM visits v
JOIN doctors d ON v.doctor_id = d.id
JOIN patients p ON v.patient_id = p.id
WHERE DATE(v.visit_time) = '2025-07-20'
ORDER BY v.visit_time;

-- 10. Query: Visit History for 'Ramya'
SELECT 
    d.name AS doctor,
    d.specialization,
    v.visit_time
FROM visits v
JOIN doctors d ON v.doctor_id = d.id
JOIN patients p ON v.patient_id = p.id
WHERE p.name = 'Ramya'
ORDER BY v.visit_time;
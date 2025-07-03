-- Drop tables if they already exist
DROP TABLE IF EXISTS visits;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS doctors;

-- 1. Create Tables

CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100)
);

CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100)
);

CREATE TABLE visits (
    visit_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    visit_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- 2. Insert Sample Data

-- Doctors
INSERT INTO doctors (doctor_id, doctor_name) VALUES
(1, 'Dr. Mehta'),
(2, 'Dr. Kapoor'),
(3, 'Dr. Iyer');

-- Patients
INSERT INTO patients (patient_id, patient_name) VALUES
(101, 'Ravi'),
(102, 'Sneha'),
(103, 'Ayaan'),
(104, 'Diya');

-- Visits
INSERT INTO visits (visit_id, patient_id, doctor_id, visit_date) VALUES
(1001, 101, 1, '2025-07-01'),
(1002, 102, 1, '2025-07-02'),
(1003, 101, 2, '2025-07-03'),
(1004, 103, 2, '2025-07-04');

-- 3. Count Visits per Doctor
SELECT 
    d.doctor_name,
    COUNT(v.visit_id) AS total_visits
FROM doctors d
LEFT JOIN visits v ON d.doctor_id = v.doctor_id
GROUP BY d.doctor_name;

-- 4. Count Visits per Patient
SELECT 
    p.patient_name,
    COUNT(v.visit_id) AS total_visits
FROM patients p
LEFT JOIN visits v ON p.patient_id = v.patient_id
GROUP BY p.patient_name;

-- 5. Patients with Only One Visit
SELECT 
    p.patient_name
FROM patients p
JOIN visits v ON p.patient_id = v.patient_id
GROUP BY p.patient_id, p.patient_name
HAVING COUNT(v.visit_id) = 1;

-- 6. Doctors with No Patient Visits
SELECT 
    d.doctor_name
FROM doctors d
LEFT JOIN visits v ON d.doctor_id = v.doctor_id
WHERE v.visit_id IS NULL;
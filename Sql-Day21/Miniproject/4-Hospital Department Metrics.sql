-- Drop tables if they already exist
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS departments;

-- 1. Create Tables

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100)
);

CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100)
);

CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- 2. Insert Sample Data

-- Departments
INSERT INTO departments (dept_id, dept_name) VALUES
(1, 'Cardiology'),
(2, 'Neurology'),
(3, 'Orthopedics');

-- Doctors
INSERT INTO doctors (doctor_id, doctor_name, dept_id) VALUES
(101, 'Dr. Ahuja', 1),
(102, 'Dr. Balan', 2),
(103, 'Dr. Chitra', 3),
(104, 'Dr. Dev', 1);

-- Patients
INSERT INTO patients (patient_id, patient_name) VALUES
(201, 'Ravi'),
(202, 'Sneha'),
(203, 'Manoj'),
(204, 'Priya'),
(205, 'Kiran');

-- Appointments
INSERT INTO appointments (appointment_id, patient_id, doctor_id, appointment_date) VALUES
(301, 201, 101, '2025-07-01'),
(302, 202, 101, '2025-07-02'),
(303, 203, 102, '2025-07-03'),
(304, 204, 103, '2025-07-04'),
(305, 205, 101, '2025-07-05'),
(306, 201, 104, '2025-07-06'),
(307, 202, 104, '2025-07-07');

-- 3. Count Patients per Department
SELECT 
    d.dept_name,
    COUNT(DISTINCT a.patient_id) AS patient_count
FROM appointments a
JOIN doctors doc ON a.doctor_id = doc.doctor_id
JOIN departments d ON doc.dept_id = d.dept_id
GROUP BY d.dept_name;

-- 4. Count Patients per Doctor
SELECT 
    doc.doctor_name,
    COUNT(DISTINCT a.patient_id) AS patient_count
FROM appointments a
JOIN doctors doc ON a.doctor_id = doc.doctor_id
GROUP BY doc.doctor_name;

-- 5. Doctors with the Most Appointments
SELECT 
    doc.doctor_name,
    COUNT(*) AS total_appointments
FROM appointments a
JOIN doctors doc ON a.doctor_id = doc.doctor_id
GROUP BY doc.doctor_name
ORDER BY total_appointments DESC
LIMIT 1;

-- 6. Departments Where Patient Count Exceeds 100
-- (Using dummy threshold for demo; adjust as needed)
SELECT 
    d.dept_name,
    COUNT(DISTINCT a.patient_id) AS patient_count
FROM appointments a
JOIN doctors doc ON a.doctor_id = doc.doctor_id
JOIN departments d ON doc.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING patient_count > 100;
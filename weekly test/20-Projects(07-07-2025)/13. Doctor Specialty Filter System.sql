-- 🏥 Create Database and Tables
CREATE DATABASE IF NOT EXISTS ClinicDB;
USE ClinicDB;

-- Doctors table
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(100) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE
);

-- Patients table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL
);

-- Appointments table
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    doctor_id INT,
    patient_id INT,
    appointment_date DATE NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- 📝 Insert Sample Data
INSERT INTO Doctors VALUES 
(1, 'Dr. Meena', 'Cardiology', TRUE),
(2, 'Dr. Ravi', 'Dermatology', TRUE),
(3, 'Dr. Anjali', 'Pediatric Neurology', TRUE);

INSERT INTO Patients VALUES 
(101, 'Ramya'), (102, 'Arun'), (103, 'Priya'), (104, 'Kiran');

INSERT INTO Appointments VALUES 
(1001, 1, 101, '2025-07-10'),
(1002, 1, 102, '2025-07-11'),
(1003, 2, 103, '2025-07-11'),
(1004, 3, 104, '2025-07-12'),
(1005, 1, 103, '2025-07-13');

-- 🔍 Filter Doctors by Specialty Using LIKE
SELECT * FROM Doctors
WHERE specialty LIKE '%Neuro%';

-- 📊 Count Patients per Doctor Using GROUP BY
SELECT 
    d.doctor_id,
    d.doctor_name,
    d.specialty,
    COUNT(a.patient_id) AS total_patients
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.doctor_name, d.specialty;

-- ⚠️ Find Overloaded Doctors (e.g., more than 2 patients)
SELECT 
    d.doctor_id,
    d.doctor_name,
    COUNT(a.patient_id) AS total_patients
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.doctor_name
HAVING COUNT(a.patient_id) > 2;

-- 🔁 Insert and Update Doctor Availability Using Transaction
START TRANSACTION;

-- Step 1: Insert new doctor
INSERT INTO Doctors (doctor_id, doctor_name, specialty, is_available)
VALUES (4, 'Dr. Nisha', 'Orthopedics', TRUE);

-- Step 2: Update availability of an existing doctor
UPDATE Doctors SET is_available = FALSE WHERE doctor_id = 2;

-- Optional: simulate error
-- UPDATE Doctors SET is_available = 'maybe' WHERE doctor_id = 1;

-- If all good
COMMIT;

-- If error occurs
-- ROLLBACK;
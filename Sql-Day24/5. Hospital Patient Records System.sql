-- ============================================
--  CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS HospitalRecords;
USE HospitalRecords;

-- ============================================
-- 1. CREATE NORMALIZED TABLES (3NF)
-- ============================================

-- Patients table
CREATE TABLE IF NOT EXISTS Patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100),
    date_of_birth DATE,
    gender VARCHAR(10)
);

-- Doctors table
CREATE TABLE IF NOT EXISTS Doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100),
    specialization VARCHAR(100)
);

-- Diagnoses table
CREATE TABLE IF NOT EXISTS Diagnoses (
    diagnosis_id INT PRIMARY KEY,
    diagnosis_name VARCHAR(200)
);

-- Visits table
CREATE TABLE IF NOT EXISTS Visits (
    visit_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    diagnosis_id INT,
    visit_date DATE,
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (diagnosis_id) REFERENCES Diagnoses(diagnosis_id)
);

-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

-- Patients
INSERT INTO Patients VALUES
(1, 'John Doe', '1985-04-12', 'Male'),
(2, 'Jane Smith', '1990-08-25', 'Female'),
(3, 'Alice Brown', '1975-02-10', 'Female'),
(4, 'Bob White', '1980-11-30', 'Male');

-- Doctors
INSERT INTO Doctors VALUES
(1, 'Dr. Kumar', 'Cardiology'),
(2, 'Dr. Mehta', 'Neurology'),
(3, 'Dr. Rao', 'Orthopedics');

-- Diagnoses
INSERT INTO Diagnoses VALUES
(1, 'Hypertension'),
(2, 'Migraine'),
(3, 'Fracture'),
(4, 'Diabetes');

-- Visits
INSERT INTO Visits VALUES
(1, 1, 1, 1, '2024-07-01', 'Routine checkup'),
(2, 2, 2, 2, '2024-07-02', 'Headache complaint'),
(3, 3, 3, 3, '2024-07-03', 'Leg injury'),
(4, 1, 1, 4, '2024-07-04', 'Follow-up for diabetes'),
(5, 4, 2, 2, '2024-07-05', 'Recurring migraines'),
(6, 2, 1, 1, '2024-07-06', 'Blood pressure monitoring'),
(7, 3, 3, 3, '2024-07-07', 'Cast removal'),
(8, 1, 1, 1, '2024-07-08', 'BP check'),
(9, 4, 2, 2, '2024-07-09', 'Neurological exam'),
(10, 2, 1, 4, '2024-07-10', 'Diabetes consultation');

-- ============================================
-- 3. CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX idx_patient_name ON Patients(patient_name);
CREATE INDEX idx_doctor_id ON Visits(doctor_id);
CREATE INDEX idx_visit_date ON Visits(visit_date);

-- ============================================
-- 4. OPTIMIZE PATIENT HISTORY QUERIES
-- ============================================

-- Patient visit history with JOIN
EXPLAIN
SELECT p.patient_name, d.doctor_name, dg.diagnosis_name, v.visit_date
FROM Visits v
JOIN Patients p ON v.patient_id = p.patient_id
JOIN Doctors d ON v.doctor_id = d.doctor_id
JOIN Diagnoses dg ON v.diagnosis_id = dg.diagnosis_id
WHERE p.patient_name = 'John Doe';

-- ============================================
-- 5. DENORMALIZED FLAT TABLE FOR REPORTING
-- ============================================

CREATE TABLE IF NOT EXISTS DoctorVisitReport (
    visit_id INT PRIMARY KEY,
    doctor_name VARCHAR(100),
    patient_name VARCHAR(100),
    diagnosis_name VARCHAR(200),
    visit_date DATE
);

-- Insert denormalized data
INSERT INTO DoctorVisitReport
SELECT 
    v.visit_id,
    d.doctor_name,
    p.patient_name,
    dg.diagnosis_name,
    v.visit_date
FROM Visits v
JOIN Doctors d ON v.doctor_id = d.doctor_id
JOIN Patients p ON v.patient_id = p.patient_id
JOIN Diagnoses dg ON v.diagnosis_id = dg.diagnosis_id;

-- Doctor-wise report
SELECT * FROM DoctorVisitReport WHERE doctor_name = 'Dr. Kumar';

-- ============================================
-- 6. TOP 10 RECENT VISITS USING LIMIT
-- ============================================

SELECT * FROM DoctorVisitReport
ORDER BY visit_date DESC
LIMIT 10;
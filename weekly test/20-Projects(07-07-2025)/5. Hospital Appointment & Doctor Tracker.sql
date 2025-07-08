-- 🏥 Create Database and Tables
CREATE DATABASE IF NOT EXISTS HospitalDB;
USE HospitalDB;

-- Doctors table
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100)
);

-- Patients table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    contact_number VARCHAR(15)
);

-- Appointments table
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    doctor_id INT,
    patient_id INT,
    appointment_date DATE CHECK (appointment_date >= CURDATE()),
    status VARCHAR(20) DEFAULT 'Scheduled',
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- 📝 Insert Sample Data
INSERT INTO Doctors VALUES 
(1, 'Dr. Meena', 'Cardiology'),
(2, 'Dr. Ravi', 'Dermatology'),
(3, 'Dr. Anjali', 'Pediatrics');

INSERT INTO Patients VALUES 
(101, 'Ramya S.', '9876543210'),
(102, 'Arun K.', '9123456780'),
(103, 'Priya R.', '9988776655'),
(104, 'Ramesh V.', '9001122334');

INSERT INTO Appointments VALUES 
(1001, 1, 101, '2025-07-08', 'Scheduled'),
(1002, 2, 102, '2025-07-08', 'Scheduled'),
(1003, 1, 103, '2025-07-09', 'Scheduled'),
(1004, 3, 104, '2025-07-09', 'Scheduled'),
(1005, 1, 102, '2025-07-10', 'Scheduled');

-- 📅 JOIN: Doctor Schedules
SELECT a.appointment_id, d.doctor_name, d.specialization, p.patient_name, a.appointment_date, a.status
FROM Appointments a
JOIN Doctors d ON a.doctor_id = d.doctor_id
JOIN Patients p ON a.patient_id = p.patient_id
ORDER BY a.appointment_date;

-- 🔍 Search Patients by Name (LIKE)
SELECT * FROM Patients
WHERE patient_name LIKE '%Ramya%';

-- 📊 Doctors with Most Patients
SELECT d.doctor_name, COUNT(a.patient_id) AS total_patients
FROM Appointments a
JOIN Doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_name
ORDER BY total_patients DESC;

-- 🔁 Reschedule an Appointment (UPDATE)
UPDATE Appointments
SET appointment_date = '2025-07-11'
WHERE appointment_id = 1002;

-- ❌ Cancel an Appointment (DELETE)
DELETE FROM Appointments
WHERE appointment_id = 1005;
--  Drop existing tables if they exist
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS Patients;
DROP TABLE IF EXISTS Doctors;

--  Create Doctors table
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL
);

--  Create Patients table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15)
);

--  Create Appointments table
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_id INT NOT NULL,
    patient_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Upcoming',
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

--  Insert sample doctors
INSERT INTO Doctors (name, specialization, email) VALUES
('Dr. Aarti Sharma', 'Cardiology', 'aarti.sharma@hospital.com'),
('Dr. Vikram Rao', 'Neurology', 'vikram.rao@hospital.com');

--  Insert sample patients
INSERT INTO Patients (name, email, phone) VALUES
('Ravi Menon', 'ravi.menon@example.com', '9876543210'),
('Sneha Pillai', 'sneha.pillai@example.com', '9123456789');

--  Insert appointment records
INSERT INTO Appointments (doctor_id, patient_id, appointment_date, status) VALUES
(1, 1, '2025-07-20', 'Upcoming'),
(2, 2, '2025-07-10', 'Completed'),
(1, 2, '2025-07-15', 'Cancelled');

--  JOIN: Connect patients with doctors
SELECT 
    a.appointment_id,
    p.name AS patient_name,
    d.name AS doctor_name,
    d.specialization,
    a.appointment_date,
    a.status
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id;

--  Filter appointments using WHERE, LIKE, BETWEEN
-- 1. Appointments for July 2025
SELECT * FROM Appointments
WHERE appointment_date BETWEEN '2025-07-01' AND '2025-07-31';

-- 2. Patients with email containing 'menon'
SELECT * FROM Patients
WHERE email LIKE '%menon%';

--  Use CASE to label appointment status
SELECT 
    appointment_id,
    appointment_date,
    CASE 
        WHEN status = 'Upcoming' THEN '🟢 Upcoming'
        WHEN status = 'Completed' THEN '✅ Completed'
        WHEN status = 'Cancelled' THEN '❌ Cancelled'
        ELSE 'Unknown'
    END AS status_label
FROM Appointments;

--  Bulk update appointment statuses using transaction
START TRANSACTION;

-- Step 1: Mark all past appointments as Completed
UPDATE Appointments
SET status = 'Completed'
WHERE appointment_date < CURDATE() AND status = 'Upcoming';

-- Step 2: Cancel appointments on a specific date
UPDATE Appointments
SET status = 'Cancelled'
WHERE appointment_date = '2025-07-15';

--  Commit changes
COMMIT;
-- Drop existing tables if they exist
DROP TABLE IF EXISTS Prescriptions;
DROP TABLE IF EXISTS Visits;
DROP TABLE IF EXISTS Patients;
DROP TABLE IF EXISTS Doctors;

--  Create Patients table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15)
);

--  Create Doctors table
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100)
);

--  Create Visits table
CREATE TABLE Visits (
    visit_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    visit_date DATE NOT NULL,
    follow_up_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Create Prescriptions table
CREATE TABLE Prescriptions (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    visit_id INT NOT NULL,
    medicine_name VARCHAR(100) NOT NULL,
    dosage VARCHAR(50),
    duration_days INT,
    FOREIGN KEY (visit_id) REFERENCES Visits(visit_id)
);

--  Insert sample patients
INSERT INTO Patients (name, email, phone) VALUES
('Aarav Mehta', 'aarav@example.com', '9876543210'),
('Neha Sharma', 'neha@example.com', '9123456789'),
('Rohan Das', 'rohan@example.com', '9988776655');

--  Insert sample doctors
INSERT INTO Doctors (name, specialization) VALUES
('Dr. Aarti Sharma', 'Cardiology'),
('Dr. Vikram Rao', 'General Medicine');

--  Insert sample visits
INSERT INTO Visits (patient_id, doctor_id, visit_date, follow_up_date) VALUES
(1, 1, '2025-08-01', '2025-08-15'),
(2, 2, '2025-08-02', NULL),
(3, 2, '2025-08-03', NULL);

--  Insert multiple prescriptions using transaction
START TRANSACTION;

INSERT INTO Prescriptions (visit_id, medicine_name, dosage, duration_days) VALUES
(1, 'Aspirin', '75mg', 10),
(1, 'Atorvastatin', '10mg', 30);

COMMIT;

--  JOIN: Full visit and prescription history
SELECT 
    p.name AS patient_name,
    d.name AS doctor_name,
    v.visit_date,
    pr.medicine_name,
    pr.dosage,
    pr.duration_days
FROM Visits v
JOIN Patients p ON v.patient_id = p.patient_id
JOIN Doctors d ON v.doctor_id = d.doctor_id
LEFT JOIN Prescriptions pr ON v.visit_id = pr.visit_id
ORDER BY v.visit_date DESC;

--  GROUP BY: Count of visits per doctor
SELECT 
    d.name AS doctor_name,
    COUNT(v.visit_id) AS total_visits
FROM Visits v
JOIN Doctors d ON v.doctor_id = d.doctor_id
GROUP BY d.name;

--  IS NULL: Patients without follow-up
SELECT DISTINCT p.name
FROM Patients p
JOIN Visits v ON p.patient_id = v.patient_id
WHERE v.follow_up_date IS NULL;
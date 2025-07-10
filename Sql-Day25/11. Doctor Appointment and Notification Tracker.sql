-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS HealthcareDB;
USE HealthcareDB;

-- Step 2: Create tables

CREATE TABLE IF NOT EXISTS Doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_name VARCHAR(100),
    specialization VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_id INT,
    patient_id INT,
    appointment_date DATE,
    appointment_time TIME,
    status VARCHAR(20) DEFAULT 'Scheduled',
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

CREATE TABLE IF NOT EXISTS Notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_id INT,
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS MedicalHistory (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    diagnosis TEXT,
    treatment TEXT,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- Step 3: Create views

-- View for patients to see doctor schedules
CREATE OR REPLACE VIEW DoctorScheduleView AS
SELECT 
    a.appointment_id,
    d.doctor_name,
    d.specialization,
    a.appointment_date,
    a.appointment_time,
    a.status
FROM Appointments a
JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE a.status = 'Scheduled';

-- Secure view for medical history (no patient ID exposed)
CREATE OR REPLACE VIEW SecureMedicalHistoryView AS
SELECT 
    p.patient_name,
    m.diagnosis,
    m.treatment
FROM MedicalHistory m
JOIN Patients p ON m.patient_id = p.patient_id;

-- Step 4: Create function to get next available slot
DELIMITER //
CREATE FUNCTION GetNextAvailableSlot(doc_id INT) RETURNS DATETIME
DETERMINISTIC
BEGIN
    DECLARE next_slot DATETIME;
    SELECT MIN(CONCAT(appointment_date, ' ', appointment_time)) INTO next_slot
    FROM Appointments
    WHERE doctor_id = doc_id AND status = 'Scheduled' AND appointment_date >= CURDATE();
    RETURN next_slot;
END;
//
DELIMITER ;

-- Step 5: Create stored procedure to book appointments
DELIMITER //
CREATE PROCEDURE BookAppointment(
    IN doc_id INT,
    IN pat_id INT,
    IN app_date DATE,
    IN app_time TIME
)
BEGIN
    INSERT INTO Appointments(doctor_id, patient_id, appointment_date, appointment_time)
    VALUES (doc_id, pat_id, app_date, app_time);
END;
//
DELIMITER ;

-- Step 6: Create trigger to notify doctor after booking
DELIMITER //
CREATE TRIGGER NotifyDoctorAfterBooking
AFTER INSERT ON Appointments
FOR EACH ROW
BEGIN
    INSERT INTO Notifications(doctor_id, message)
    VALUES (
        NEW.doctor_id,
        CONCAT('New appointment booked on ', NEW.appointment_date, ' at ', NEW.appointment_time)
    );
END;
//
DELIMITER ;

-- Step 7: Insert sample doctors
INSERT INTO Doctors (doctor_name, specialization) VALUES
('Dr. Ramya', 'Cardiology'), ('Dr. Karthik', 'Dermatology'),
('Dr. Diya', 'Pediatrics'), ('Dr. Rohan', 'Orthopedics'), ('Dr. Meera', 'Neurology');

-- Step 8: Insert 50 patients
INSERT INTO Patients (patient_name, email)
SELECT CONCAT('Patient_', LPAD(n, 2, '0')), CONCAT('patient', n, '@mail.com')
FROM (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
    UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
    UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15
    UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20
    UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24 UNION ALL SELECT 25
    UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28 UNION ALL SELECT 29 UNION ALL SELECT 30
    UNION ALL SELECT 31 UNION ALL SELECT 32 UNION ALL SELECT 33 UNION ALL SELECT 34 UNION ALL SELECT 35
    UNION ALL SELECT 36 UNION ALL SELECT 37 UNION ALL SELECT 38 UNION ALL SELECT 39 UNION ALL SELECT 40
    UNION ALL SELECT 41 UNION ALL SELECT 42 UNION ALL SELECT 43 UNION ALL SELECT 44 UNION ALL SELECT 45
    UNION ALL SELECT 46 UNION ALL SELECT 47 UNION ALL SELECT 48 UNION ALL SELECT 49 UNION ALL SELECT 50
) AS numbers;

-- Step 9: Insert 50 randomized appointments
INSERT INTO Appointments (doctor_id, patient_id, appointment_date, appointment_time)
SELECT 
    FLOOR(1 + (RAND() * 5)),  -- doctor_id between 1 and 5
    patient_id,
    CURDATE() + INTERVAL FLOOR(RAND() * 10) DAY,
    MAKETIME(FLOOR(9 + (RAND() * 8)), 0, 0)  -- time between 9:00 and 16:00
FROM Patients;
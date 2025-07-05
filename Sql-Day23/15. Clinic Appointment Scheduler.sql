-- 🔁 Drop existing tables if they exist
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS Patients;
DROP TABLE IF EXISTS Doctors;

-- 🏥 Create Doctors table
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL
);

-- 👤 Create Patients table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15)
);

-- 📅 Create Appointments table
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_id INT NOT NULL,
    patient_id INT NOT NULL,
    appointment_datetime DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'Scheduled',
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    UNIQUE (doctor_id, appointment_datetime) -- Prevent double-booking a doctor
);

-- 🧑‍⚕️ Insert sample doctors
INSERT INTO Doctors (name, specialization, email) VALUES
('Dr. Aarti Sharma', 'Dermatology', 'aarti.sharma@clinic.com'),
('Dr. Vikram Rao', 'Orthopedics', 'vikram.rao@clinic.com');

-- 🧑‍💼 Insert sample patients
INSERT INTO Patients (name, email, phone) VALUES
('Neel Joshi', 'neel.joshi@example.com', '9876543210'),
('Tanya Kapoor', 'tanya.kapoor@example.com', '9123456789');

-- 🔄 Batch-schedule appointments using a transaction
START TRANSACTION;

-- Step 1: Schedule appointment for Neel with Dr. Aarti
INSERT INTO Appointments (doctor_id, patient_id, appointment_datetime)
VALUES (1, 1, '2025-07-15 10:00:00');

-- Step 2: Schedule appointment for Tanya with Dr. Vikram
INSERT INTO Appointments (doctor_id, patient_id, appointment_datetime)
VALUES (2, 2, '2025-07-15 11:00:00');

-- Optional: Simulate conflict (uncomment to test rollback)
-- INSERT INTO Appointments (doctor_id, patient_id, appointment_datetime)
-- VALUES (1, 2, '2025-07-15 10:00:00'); -- Conflict with Dr. Aarti's 10:00 slot

-- ✅ Commit if all successful
COMMIT;

-- ✏️ Update appointment status
UPDATE Appointments
SET status = 'Cancelled'
WHERE appointment_id = 1;

-- ❌ Delete old appointments (e.g., before today)
DELETE FROM Appointments
WHERE appointment_datetime < NOW();
-- 🔁 Drop existing tables if they exist
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS Patients;
DROP TABLE IF EXISTS Doctors;

-- 🏗️ Create Doctors table
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL
);

-- 🏗️ Create Patients table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    date_of_birth DATE,
    admission_date DATE DEFAULT CURRENT_DATE
);

-- 🏗️ Create Appointments table
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    treatment_status VARCHAR(50) DEFAULT 'Scheduled',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- 🧾 Insert sample doctors
INSERT INTO Doctors (name, specialization, email) VALUES
('Dr. Asha Mehta', 'Cardiology', 'asha.mehta@hospital.com'),
('Dr. Rajiv Nair', 'Neurology', 'rajiv.nair@hospital.com'),
('Dr. Priya Desai', 'Pediatrics', 'priya.desai@hospital.com');

-- 🧾 Insert sample patients
INSERT INTO Patients (name, email, date_of_birth) VALUES
('Rohan Verma', 'rohan.verma@example.com', '1990-05-12'),
('Sneha Kapoor', 'sneha.kapoor@example.com', '1985-11-23'),
('Amit Joshi', 'amit.joshi@example.com', '2000-02-17');

-- 🧾 Insert sample appointments
INSERT INTO Appointments (patient_id, doctor_id, appointment_date) VALUES
(1, 1, '2025-07-06'),
(2, 2, '2025-07-07'),
(3, 3, '2025-07-08');

-- ✏️ Update treatment status
UPDATE Appointments
SET treatment_status = 'Under Treatment'
WHERE appointment_id = 1;

UPDATE Appointments
SET treatment_status = 'Recovered'
WHERE appointment_id = 2;

-- ❌ Delete past records after discharge
DELETE FROM Appointments
WHERE treatment_status = 'Recovered';

-- Optionally delete patients with no active appointments
DELETE FROM Patients
WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM Appointments);

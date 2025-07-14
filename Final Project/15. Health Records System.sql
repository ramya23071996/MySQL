-- 1. Create Database
CREATE DATABASE health_records;
USE health_records;

-- 2. Patients Table
CREATE TABLE patients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    dob DATE
);

-- 3. Medications Table
CREATE TABLE medications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 4. Prescriptions Table
CREATE TABLE prescriptions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(id)
);

-- 5. Prescription Details Table
CREATE TABLE prescription_details (
    prescription_id INT,
    medication_id INT,
    dosage VARCHAR(100),
    PRIMARY KEY (prescription_id, medication_id),
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(id),
    FOREIGN KEY (medication_id) REFERENCES medications(id)
);

-- 6. Insert Sample Patients
INSERT INTO patients (name, dob) VALUES
('Ramya', '1994-05-20'),
('Arjun', '1992-08-15'),
('Sneha', '1996-12-03'),
('Kiran', '1990-04-28'),
('Meera', '1995-09-10');

-- 7. Insert Sample Medications
INSERT INTO medications (name) VALUES
('Paracetamol'),
('Amoxicillin'),
('Metformin'),
('Aspirin'),
('Cetirizine'),
('Ibuprofen'),
('Vitamin D'),
('Lisinopril'),
('Atorvastatin'),
('Omeprazole');

-- 8. Insert Sample Prescriptions
INSERT INTO prescriptions (patient_id, date) VALUES
(1, '2025-07-15'),
(2, '2025-07-16'),
(3, '2025-07-17'),
(4, '2025-07-18'),
(5, '2025-07-19');

-- 9. Insert Prescription Details
INSERT INTO prescription_details (prescription_id, medication_id, dosage) VALUES
(1, 1, '500mg twice daily'),
(1, 3, '1000mg once daily'),
(2, 2, '250mg thrice daily'),
(2, 4, '75mg once daily'),
(3, 5, '10mg at night'),
(3, 6, '400mg every 6 hours'),
(4, 7, '1000 IU daily'),
(4, 9, '20mg daily'),
(5, 8, '10mg daily'),
(5, 10, '20mg before meals');

-- 10. Query: Prescriptions for a Specific Patient
SELECT 
    p.name AS patient,
    pr.date,
    m.name AS medication,
    pd.dosage
FROM prescriptions pr
JOIN prescription_details pd ON pr.id = pd.prescription_id
JOIN medications m ON pd.medication_id = m.id
JOIN patients p ON pr.patient_id = p.id
WHERE p.name = 'Ramya';

-- 11. Query: Prescriptions on a Specific Date
SELECT 
    p.name AS patient,
    m.name AS medication,
    pd.dosage
FROM prescriptions pr
JOIN prescription_details pd ON pr.id = pd.prescription_id
JOIN medications m ON pd.medication_id = m.id
JOIN patients p ON pr.patient_id = p.id
WHERE pr.date = '2025-07-15';
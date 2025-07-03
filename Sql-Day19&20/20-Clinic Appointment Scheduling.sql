-- Create the database
CREATE DATABASE IF NOT EXISTS ClinicDB;
USE ClinicDB;

-- Drop tables if they already exist
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS Patients;
DROP TABLE IF EXISTS Doctors;

-- Create Patients table
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100)
);

-- Create Doctors table
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    Name VARCHAR(100),
    Specialty VARCHAR(100)
);

-- Create Appointments table
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATE,
    Status ENUM('Scheduled', 'Completed', 'Missed'),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Insert sample patients
INSERT INTO Patients VALUES
(1, 'Aarav Mehta', 'aarav@example.com'),
(2, 'Diya Sharma', 'diya@example.com'),
(3, 'Rohan Iyer', 'rohan@example.com');

-- Insert sample doctors
INSERT INTO Doctors VALUES
(101, 'Dr. Nikhil Rao', 'Cardiology'),
(102, 'Dr. Meera Nair', 'Dermatology'),
(103, 'Dr. Karan Patel', 'Orthopedics');

-- Insert sample appointments
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Status) VALUES
(1, 101, '2025-07-01', 'Completed'),
(2, 101, '2025-07-02', 'Missed'),
(3, 101, '2025-07-03', 'Completed'),
(1, 102, '2025-07-04', 'Scheduled'),
(2, 102, '2025-07-05', 'Missed'),
(3, 103, '2025-07-06', 'Completed'),
(1, 101, '2025-07-07', 'Completed'),
(2, 101, '2025-07-08', 'Completed');

-- Query 1: Doctors with most appointments in a week (e.g., 2025-07-01 to 2025-07-07)
SELECT D.Name AS DoctorName, COUNT(*) AS AppointmentCount
FROM Appointments A
JOIN Doctors D ON A.DoctorID = D.DoctorID
WHERE A.AppointmentDate BETWEEN '2025-07-01' AND '2025-07-07'
GROUP BY A.DoctorID
ORDER BY AppointmentCount DESC;

-- Query 2: Patients with missed appointments
SELECT P.Name AS PatientName, A.AppointmentDate, D.Name AS DoctorName
FROM Appointments A
JOIN Patients P ON A.PatientID = P.PatientID
JOIN Doctors D ON A.DoctorID = D.DoctorID
WHERE A.Status = 'Missed';
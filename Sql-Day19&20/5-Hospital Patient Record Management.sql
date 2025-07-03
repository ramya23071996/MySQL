CREATE DATABASE HospitalDB1;
USE HospitalDB1;

-- Patients table
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Gender VARCHAR(10)
);

-- Doctors table
CREATE TABLE Doctors1 (
    DoctorID INT PRIMARY KEY,
    Name VARCHAR(100),
    Specialty VARCHAR(100)
);

-- Appointments table
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATE,
    Reason VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors1(DoctorID)
);

-- Patients
INSERT INTO Patients VALUES
(1, 'Aarav Mehta', 30, 'Male'),
(2, 'Diya Sharma', 25, 'Female'),
(3, 'Rohan Iyer', 40, 'Male'),
(4, 'Sneha Reddy', 35, 'Female');

-- Doctors
INSERT INTO Doctors1 VALUES
(101, 'Dr. Nikhil Rao', 'Cardiology'),
(102, 'Dr. Meera Nair', 'Dermatology');

-- Appointments
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Reason) VALUES
(1, 101, '2025-07-01', 'Routine Checkup'),
(2, 102, '2025-07-02', 'Skin Rash'),
(3, 101, '2025-07-03', 'Chest Pain');

SELECT P.Name AS PatientName, A.AppointmentDate, A.Reason
FROM Appointments A
JOIN Patients P ON A.PatientID = P.PatientID
JOIN Doctors1 D ON A.DoctorID = D.DoctorID
WHERE D.Name = 'Dr. Nikhil Rao'
  AND A.AppointmentDate BETWEEN '2025-07-01' AND '2025-07-05';
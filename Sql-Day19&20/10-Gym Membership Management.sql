CREATE DATABASE GymDB;
USE GymDB;

-- Membership types (e.g., Monthly, Quarterly, Annual)
CREATE TABLE MembershipTypes (
    MembershipTypeID INT PRIMARY KEY,
    TypeName VARCHAR(50),
    DurationInDays INT,
    Price DECIMAL(10,2)
);

-- Members table
CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    Name VARCHAR(100),
    JoinDate DATE,
    MembershipTypeID INT,
    FOREIGN KEY (MembershipTypeID) REFERENCES MembershipTypes(MembershipTypeID)
);

-- Payments table
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    MemberID INT,
    PaymentDate DATE,
    Amount DECIMAL(10,2),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

-- Membership types
INSERT INTO MembershipTypes VALUES
(1, 'Monthly', 30, 50.00),
(2, 'Quarterly', 90, 135.00),
(3, 'Annual', 365, 500.00);

-- Members
INSERT INTO Members VALUES
(1, 'Aarav Mehta', '2025-01-01', 1),
(2, 'Diya Sharma', '2025-03-15', 2),
(3, 'Rohan Iyer', '2024-07-01', 3),
(4, 'Sneha Reddy', '2025-06-01', 1);

-- Payments
INSERT INTO Payments (MemberID, PaymentDate, Amount) VALUES
(1, '2025-06-01', 50.00),
(2, '2025-04-01', 135.00),
(3, '2024-07-01', 500.00),
(4, '2025-06-01', 50.00);

SELECT M.Name, MT.TypeName, MAX(P.PaymentDate) AS LastPayment,
       DATE_ADD(MAX(P.PaymentDate), INTERVAL MT.DurationInDays DAY) AS ExpiryDate
FROM Members M
JOIN MembershipTypes MT ON M.MembershipTypeID = MT.MembershipTypeID
JOIN Payments P ON M.MemberID = P.MemberID
GROUP BY M.MemberID
HAVING ExpiryDate < CURDATE();

SELECT M.Name, MAX(P.PaymentDate) AS LastPayment
FROM Members M
JOIN Payments P ON M.MemberID = P.MemberID
GROUP BY M.MemberID
HAVING LastPayment < DATE_SUB(CURDATE(), INTERVAL 1 MONTH);
-- 1️⃣ Drop existing tables if needed
DROP TABLE IF EXISTS Claims;
DROP TABLE IF EXISTS Documents;
DROP TABLE IF EXISTS Policies;

-- 2️⃣ Create Tables

CREATE TABLE Policies (
    PolicyID INT PRIMARY KEY,
    PolicyHolderName VARCHAR(100),
    PolicyType VARCHAR(50),
    StartDate DATE,
    EndDate DATE
);

CREATE TABLE Documents (
    DocumentID INT PRIMARY KEY,
    ClaimID INT,
    DocumentType VARCHAR(50),
    IsVerified BIT, -- 1 = Verified, 0 = Not Verified
    FOREIGN KEY (ClaimID) REFERENCES Claims(ClaimID)
);

CREATE TABLE Claims (
    ClaimID INT PRIMARY KEY,
    PolicyID INT,
    ClaimAmount DECIMAL(10, 2) CHECK (ClaimAmount <= 100000), -- ✅ CHECK constraint
    ClaimDate DATE,
    FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID)
);

-- 3️⃣ Insert Sample Data

INSERT INTO Policies VALUES
(1, 'Ramya', 'Health', '2023-01-01', '2026-01-01'),
(2, 'Arjun', 'Auto', '2022-06-01', '2025-06-01');

INSERT INTO Claims VALUES
(101, 1, 50000, '2025-07-01'),
(102, 1, 120000, '2025-07-02'), -- This will fail due to CHECK constraint
(103, 2, 30000, '2025-07-03');

INSERT INTO Documents VALUES
(201, 101, 'Medical Report', 1),
(202, 101, 'ID Proof', 1),
(203, 103, 'Accident Report', 0), -- Not verified
(204, 103, 'ID Proof', NULL);     -- Missing verification

-- 4️⃣ Find Claims with Missing or Unverified Documents

SELECT 
    c.ClaimID,
    c.ClaimAmount,
    d.DocumentType,
    d.IsVerified
FROM Claims c
LEFT JOIN Documents d ON c.ClaimID = d.ClaimID
WHERE d.IsVerified IS NULL OR d.IsVerified = 0;

-- 5️⃣ Display Full Claim Info with JOINs

SELECT 
    c.ClaimID,
    p.PolicyHolderName,
    p.PolicyType,
    c.ClaimAmount,
    c.ClaimDate,
    d.DocumentType,
    d.IsVerified
FROM Claims c
JOIN Policies p ON c.PolicyID = p.PolicyID
LEFT JOIN Documents d ON c.ClaimID = d.ClaimID;

-- 6️⃣ Subquery: Average Claim Amount per Policy

SELECT 
    PolicyID,
    (SELECT AVG(ClaimAmount) 
     FROM Claims c2 
     WHERE c2.PolicyID = c1.PolicyID) AS AvgClaimAmount
FROM Claims c1
GROUP BY PolicyID;
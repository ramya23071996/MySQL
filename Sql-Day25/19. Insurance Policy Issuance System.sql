-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS InsuranceDB;
USE InsuranceDB;

-- Step 2: Create tables

CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Policies (
    policy_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    policy_type VARCHAR(50),
    start_date DATE,
    end_date DATE,
    premium_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'Active', -- Active, Expired, Cancelled
    terms TEXT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE IF NOT EXISTS PolicyAudit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    policy_id INT,
    old_terms TEXT,
    new_terms TEXT,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 3: Create views

-- View: Customer policy status
CREATE OR REPLACE VIEW CustomerPolicyStatus AS
SELECT 
    c.customer_id,
    c.customer_name,
    p.policy_id,
    p.policy_type,
    p.start_date,
    p.end_date,
    p.status
FROM Customers c
JOIN Policies p ON c.customer_id = p.customer_id;

-- View: Customer-limited policy info
CREATE OR REPLACE VIEW CustomerView AS
SELECT 
    policy_id,
    policy_type,
    start_date,
    end_date,
    status
FROM Policies;

-- View: Agent-level full policy info
CREATE OR REPLACE VIEW AgentPolicyView AS
SELECT 
    p.policy_id,
    c.customer_name,
    p.policy_type,
    p.start_date,
    p.end_date,
    p.premium_amount,
    p.status,
    p.terms
FROM Policies p
JOIN Customers c ON p.customer_id = c.customer_id;

-- Step 4: Create function to count active policies per customer
DELIMITER //
CREATE FUNCTION CountActivePolicies(cust_id INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM Policies
    WHERE customer_id = cust_id AND status = 'Active';
    RETURN total;
END;
//
DELIMITER ;

-- Step 5: Create stored procedure to issue a new policy
DELIMITER //
CREATE PROCEDURE IssuePolicy(
    IN cust_id INT,
    IN p_type VARCHAR(50),
    IN s_date DATE,
    IN e_date DATE,
    IN premium DECIMAL(10,2),
    IN p_terms TEXT
)
BEGIN
    INSERT INTO Policies(customer_id, policy_type, start_date, end_date, premium_amount, terms)
    VALUES (cust_id, p_type, s_date, e_date, premium, p_terms);
END;
//
DELIMITER ;

-- Step 6: Create trigger to log policy term changes
DELIMITER //
CREATE TRIGGER LogPolicyTermChange
AFTER UPDATE ON Policies
FOR EACH ROW
BEGIN
    IF OLD.terms <> NEW.terms THEN
        INSERT INTO PolicyAudit(policy_id, old_terms, new_terms)
        VALUES (NEW.policy_id, OLD.terms, NEW.terms);
    END IF;
END;
//
DELIMITER ;

-- Step 7: Insert sample data

-- Customers
INSERT INTO Customers (customer_name, email) VALUES
('Aarav', 'aarav@example.com'),
('Diya', 'diya@example.com'),
('Rohan', 'rohan@example.com');

-- Policies
CALL IssuePolicy(1, 'Health', '2025-08-01', '2026-08-01', 12000.00, 'Covers hospitalization and surgery');
CALL IssuePolicy(2, 'Life', '2025-07-15', '2045-07-15', 25000.00, 'Term life insurance with maturity benefit');
CALL IssuePolicy(3, 'Vehicle', '2025-09-01', '2026-09-01', 8000.00, 'Covers accidental damage and theft');
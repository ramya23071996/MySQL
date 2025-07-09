-- ============================================
-- 0. CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS InsuranceSystem;
USE InsuranceSystem;

-- ============================================
-- 1. CREATE NORMALIZED TABLES (3NF)
-- ============================================

-- Agents table
CREATE TABLE IF NOT EXISTS Agents (
    agent_id INT PRIMARY KEY,
    agent_name VARCHAR(100),
    contact_info VARCHAR(100)
);

-- Clients table
CREATE TABLE IF NOT EXISTS Clients (
    client_id INT PRIMARY KEY,
    client_name VARCHAR(100),
    email VARCHAR(100)
);

-- Policies table
CREATE TABLE IF NOT EXISTS Policies (
    policy_id INT PRIMARY KEY,
    client_id INT,
    agent_id INT,
    policy_type VARCHAR(50), -- e.g., Life, Health, Auto
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    FOREIGN KEY (agent_id) REFERENCES Agents(agent_id)
);

-- Claims table
CREATE TABLE IF NOT EXISTS Claims (
    claim_id INT PRIMARY KEY,
    policy_id INT,
    claim_date DATE,
    claim_amount DECIMAL(12,2),
    claim_status VARCHAR(50), -- e.g., Approved, Rejected, Under Review
    FOREIGN KEY (policy_id) REFERENCES Policies(policy_id)
);

-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

-- Agents
INSERT INTO Agents VALUES
(1, 'Ravi Kumar', 'ravi@insure.com'),
(2, 'Meena Sharma', 'meena@insure.com');

-- Clients
INSERT INTO Clients VALUES
(1, 'Alice', 'alice@example.com'),
(2, 'Bob', 'bob@example.com');

-- Policies
INSERT INTO Policies VALUES
(101, 1, 1, 'Health', '2023-01-01', '2024-12-31'),
(102, 2, 2, 'Auto', '2023-06-01', '2024-05-31');

-- Claims
INSERT INTO Claims VALUES
(1001, 101, '2024-07-01', 15000.00, 'Approved'),
(1002, 101, '2024-07-10', 5000.00, 'Under Review'),
(1003, 102, '2024-07-05', 20000.00, 'Rejected'),
(1004, 102, '2024-07-12', 8000.00, 'Under Review');

-- ============================================
-- 3. CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX idx_claim_status ON Claims(claim_status);
CREATE INDEX idx_policy_type ON Policies(policy_type);
CREATE INDEX idx_claim_date ON Claims(claim_date);

-- ============================================
-- 4. OPTIMIZE QUERIES WITH JOIN + EXPLAIN
-- ============================================

EXPLAIN
SELECT c.client_name, p.policy_type, cl.claim_date, cl.claim_status
FROM Claims cl
JOIN Policies p ON cl.policy_id = p.policy_id
JOIN Clients c ON p.client_id = c.client_id
WHERE cl.claim_status = 'Under Review';

-- ============================================
-- 5. DENORMALIZED VIEW FOR CLAIMS PER AGENT
-- ============================================

CREATE OR REPLACE VIEW AgentClaimReport AS
SELECT 
    a.agent_name,
    c.client_name,
    p.policy_type,
    cl.claim_id,
    cl.claim_date,
    cl.claim_amount,
    cl.claim_status
FROM Claims cl
JOIN Policies p ON cl.policy_id = p.policy_id
JOIN Clients c ON p.client_id = c.client_id
JOIN Agents a ON p.agent_id = a.agent_id;

-- View usage example
SELECT * FROM AgentClaimReport WHERE agent_name = 'Ravi Kumar';

-- ============================================
-- 6. LIMIT FOR CLAIMS UNDER REVIEW
-- ============================================

SELECT * FROM AgentClaimReport
WHERE claim_status = 'Under Review'
ORDER BY claim_date DESC
LIMIT 5;
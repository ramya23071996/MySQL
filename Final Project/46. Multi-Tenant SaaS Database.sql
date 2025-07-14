-- 1. Create Database
CREATE DATABASE saas_platform;
USE saas_platform;

-- 2. Tenants Table
CREATE TABLE tenants (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Users Table (linked to tenant)
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    tenant_id INT,
    FOREIGN KEY (tenant_id) REFERENCES tenants(id)
);

-- 4. Data Table (partitionable by tenant_id)
CREATE TABLE data (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tenant_id INT,
    content TEXT NOT NULL,
    FOREIGN KEY (tenant_id) REFERENCES tenants(id)
);

-- Sample Data Insert
-- Tenants
INSERT INTO tenants (name) VALUES
('Alpha Corp'), ('Beta LLC'), ('Gamma Solutions');

-- Users
INSERT INTO users (name, tenant_id) VALUES
('Ramya', 1),
('Arjun', 1),
('Sneha', 2),
('Kiran', 3),
('Meera', 2);

-- Data Entries
INSERT INTO data (tenant_id, content) VALUES
(1, 'Alpha customer orders'),
(1, 'Alpha usage metrics'),
(2, 'Beta campaign results'),
(3, 'Gamma ticket logs'),
(2, 'Beta team notes');

-- View Data by Tenant (Partitioned Query)
SELECT 
    d.id,
    t.name AS tenant,
    d.content
FROM data d
JOIN tenants t ON d.tenant_id = t.id
WHERE d.tenant_id = 2; -- Beta LLC

-- Users Within a Tenant
SELECT 
    u.name AS user,
    t.name AS tenant
FROM users u
JOIN tenants t ON u.tenant_id = t.id
ORDER BY t.name, u.name;

-- Data Isolation Check: Entries Without Tenant Mapping
SELECT * 
FROM data
WHERE tenant_id NOT IN (SELECT id FROM tenants);


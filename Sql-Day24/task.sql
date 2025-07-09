-- SECTION A: INDEXING IN SQL (Tasks 1–15)

-- Task 1: Create Employees table
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT,
    salary DECIMAL(10,2)
);

-- Task 2: Insert 15 employee records
INSERT INTO Employees VALUES
(1, 'John', 101, 50000), (2, 'Alice', 102, 60000), (3, 'Bob', 101, 55000),
(4, 'David', 103, 70000), (5, 'Eva', 102, 62000), (6, 'Frank', 101, 48000),
(7, 'Grace', 103, 75000), (8, 'Helen', 102, 53000), (9, 'Ian', 101, 51000),
(10, 'Jane', 103, 68000), (11, 'Kyle', 102, 59000), (12, 'Liam', 101, 47000),
(13, 'Mona', 103, 72000), (14, 'Nina', 102, 61000), (15, 'Oscar', 101, 49500);

-- Task 3: Create index on emp_name
CREATE INDEX idx_emp_name ON Employees(emp_name);

-- Task 4–5: Query and EXPLAIN
EXPLAIN SELECT * FROM Employees WHERE emp_name = 'John';

-- Task 6: Compound index
CREATE INDEX idx_dept_salary ON Employees(dept_id, salary);
SELECT * FROM Employees WHERE dept_id = 101 AND salary > 50000;

-- Task 7: Drop index
DROP INDEX idx_emp_name ON Employees;

-- Task 8–10: Create Departments table and indexes
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100)
);
CREATE INDEX idx_dept_name ON Departments(dept_name);

-- Task 11–12: JOIN and EXPLAIN
SELECT e.emp_name, d.dept_name
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id;
EXPLAIN SELECT e.emp_name, d.dept_name
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id;

-- Task 13: ORDER BY test
SELECT * FROM Employees ORDER BY emp_name;

-- Task 14: Insert 1000+ dummy records (example for loop in stored procedure or script)
-- Task 15: Avoid indexing high-update or rarely queried columns

-- SECTION B: QUERY OPTIMIZATION (Tasks 16–25)

-- Task 16: EXPLAIN full scan and optimize
EXPLAIN SELECT * FROM Employees WHERE salary > 60000;
CREATE INDEX idx_salary ON Employees(salary);

-- Task 17: Optimize SELECT *
SELECT emp_name, salary FROM Employees WHERE salary > 60000;

-- Task 18–19: Create Orders table and analyze
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE
);
INSERT INTO Orders VALUES
(1, 101, '2024-07-01'), (2, 102, '2024-07-03'), (3, 103, '2024-07-05'),
(4, 101, '2024-07-07'), (5, 104, '2024-07-09'), (6, 105, '2024-07-11'),
(7, 106, '2024-07-13'), (8, 107, '2024-07-15'), (9, 108, '2024-07-17'),
(10, 109, '2024-07-19'), (11, 110, '2024-07-21'), (12, 111, '2024-07-23'),
(13, 112, '2024-07-25'), (14, 113, '2024-07-27'), (15, 114, '2024-07-29'),
(16, 115, '2024-07-31'), (17, 116, '2024-08-01'), (18, 117, '2024-08-02'),
(19, 118, '2024-08-03'), (20, 119, '2024-08-04');
EXPLAIN SELECT * FROM Orders;

-- Task 20–21: Index and filter by date
CREATE INDEX idx_order_date ON Orders(order_date);
EXPLAIN SELECT * FROM Orders WHERE order_date BETWEEN CURDATE() - INTERVAL 7 DAY AND CURDATE();

-- Task 22: Subquery vs JOIN
SELECT * FROM Orders WHERE customer_id IN (SELECT emp_id FROM Employees WHERE salary > 60000);
SELECT o.* FROM Orders o JOIN Employees e ON o.customer_id = e.emp_id WHERE e.salary > 60000;

-- Task 23–24: Optimize complex query and create view
CREATE VIEW RecentHighOrders AS
SELECT o.order_id, o.order_date, e.emp_name
FROM Orders o
JOIN Employees e ON o.customer_id = e.emp_id
WHERE e.salary > 60000 AND o.order_date >= CURDATE() - INTERVAL 30 DAY;

-- Task 25: LIMIT performance
SELECT * FROM Orders LIMIT 5;

-- SECTION C: LIMIT USAGE (Tasks 26–30)

-- Task 26–30: LIMIT and pagination
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);
INSERT INTO Customers VALUES
(101, 'Ram'), (102, 'Sita'), (103, 'Laxman'), (104, 'Bharat'), (105, 'Hanuman'),
(106, 'Krishna'), (107, 'Radha'), (108, 'Arjun'), (109, 'Karna'), (110, 'Draupadi');

SELECT * FROM Customers LIMIT 5;
SELECT * FROM Customers ORDER BY customer_id DESC LIMIT 10;
SELECT * FROM Customers WHERE customer_name LIKE 'R%' ORDER BY customer_id LIMIT 5;
SELECT * FROM Customers LIMIT 5;
SELECT * FROM Customers LIMIT 10 OFFSET 10;

-- SECTION D: CLUSTERED VS NON-CLUSTERED (Tasks 31–35)

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);
CREATE INDEX idx_product_name ON Products(product_name);
INSERT INTO Products VALUES
(1, 'Laptop', 55000), (2, 'Tablet', 30000), (3, 'Smartphone', 25000),
(4, 'Monitor', 15000), (5, 'Keyboard', 2000), (6, 'Mouse', 1000),
(7, 'Printer', 8000), (8, 'Scanner', 7000), (9, 'Speaker', 3000), (10, 'Webcam', 2500);

SELECT * FROM Products WHERE product_name LIKE '%lap%';
EXPLAIN SELECT * FROM Products WHERE product_name LIKE '%lap%';
DROP INDEX idx_product_name ON Products;

-- SECTION E: NORMALIZATION (Tasks 36–40)

-- Task 36–40: Normalize SalesData
-- Unnormalized
CREATE TABLE SalesData (
    order_id INT,
    customer_name VARCHAR(100),
    product1 VARCHAR(100),
    product2 VARCHAR(100),
    product3 VARCHAR(100)
);

-- 1NF
CREATE TABLE OrderItems (
    order_id INT,
    product_name VARCHAR(100)
);

-- 2NF
CREATE TABLE ProductsNormalized (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100)
);

-- 3NF
CREATE TABLE CustomersNormalized (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);
CREATE TABLE OrdersNormalized (
    order_id INT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES CustomersNormalized(customer_id)
);

-- SECTION F: DENORMALIZATION (Tasks 41–45)

CREATE TABLE DenormalizedOrders (
    order_id INT,
    customer_name VARCHAR(100),
    product_name VARCHAR(100),
    quantity INT,
    order_date DATE
);
INSERT INTO DenormalizedOrders VALUES
(1, 'Ram', 'Laptop', 1, '2024-07-01'),
(2, 'Sita', 'Tablet', 2, '2024-07-02'),
(3, 'Ram', 'Mouse', 1, '2024-07-03');

SELECT * FROM DenormalizedOrders;

-- SECTION G: REAL-WORLD PERFORMANCE (Tasks 46–50)

-- Task 46–47: JOIN without and with index
EXPLAIN SELECT * FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id;
CREATE INDEX idx_cust_id_customers ON Customers(customer_id);
CREATE INDEX idx_cust_id_orders ON Orders(customer_id);
EXPLAIN SELECT * FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id;

-- Task 48: Subquery vs JOIN
SELECT * FROM Orders WHERE customer_id IN (SELECT customer_id FROM Customers WHERE customer_name LIKE 'R%');
SELECT o.* FROM Orders o JOIN Customers c ON o.customer_id = c.customer_id WHERE c.customer_name LIKE 'R%';

-- Task 49: GROUP BY with index
CREATE INDEX idx

SELECT c.customer_name, o.order_date
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY
ORDER BY o.order_date DESC
LIMIT 10;
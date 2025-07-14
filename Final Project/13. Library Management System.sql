-- 1. Create Library Database
CREATE DATABASE library_system;
USE library_system;

-- 2. Books Table
CREATE TABLE books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100) NOT NULL
);

-- 3. Members Table
CREATE TABLE members (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 4. Borrows Table
CREATE TABLE borrows (
    id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    book_id INT,
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY (member_id) REFERENCES members(id),
    FOREIGN KEY (book_id) REFERENCES books(id)
);

-- 5. Sample Books
INSERT INTO books (title, author) VALUES
('The SQL Handbook', 'Ajay Mehta'),
('Data Structures', 'Geetha Rao'),
('Machine Learning 101', 'Neeraj Das'),
('Design Patterns', 'Kavitha Prasad'),
('Clean Code', 'R. Martin'),
('Web Essentials', 'Sneha Sharma'),
('Algorithms Made Easy', 'Prakash Jain'),
('Python in Depth', 'Ramya Iyer'),
('System Design Basics', 'Vikram Singh'),
('AI for All', 'Anjali Patil');

-- 6. Sample Members
INSERT INTO members (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 7. Sample Borrow Records
INSERT INTO borrows (member_id, book_id, borrow_date, return_date) VALUES
(1, 1, '2025-07-01', '2025-07-10'),
(2, 2, '2025-07-02', '2025-07-12'),
(3, 3, '2025-07-03', '2025-07-09'),
(4, 4, '2025-07-05', '2025-07-17'),
(5, 5, '2025-07-06', NULL),
(1, 6, '2025-07-08', NULL),
(2, 7, '2025-07-09', '2025-07-13'),
(3, 8, '2025-07-10', '2025-07-18'),
(4, 9, '2025-07-11', NULL),
(5, 10, '2025-07-12', '2025-07-21');

-- 8. Query: Borrow History with Member and Book Info
SELECT 
    m.name AS member,
    b.title AS book,
    br.borrow_date,
    br.return_date
FROM borrows br
JOIN members m ON br.member_id = m.id
JOIN books b ON br.book_id = b.id
ORDER BY br.borrow_date;

-- 9. Query: Fine Calculation (Assuming 7-day limit, ₹10/day fine)
SELECT 
    m.name AS member,
    b.title AS book,
    br.borrow_date,
    br.return_date,
    CASE 
        WHEN br.return_date IS NULL THEN 'Not Returned'
        WHEN DATEDIFF(br.return_date, br.borrow_date) > 7 THEN 
            CONCAT('₹', (DATEDIFF(br.return_date, br.borrow_date) - 7) * 10)
        ELSE '₹0'
    END AS fine
FROM borrows br
JOIN members m ON br.member_id = m.id
JOIN books b ON br.book_id = b.id;

-- 10. Query: Currently Borrowed Books
SELECT 
    m.name AS member,
    b.title AS book,
    br.borrow_date
FROM borrows br
JOIN members m ON br.member_id = m.id
JOIN books b ON br.book_id = b.id
WHERE br.return_date IS NULL;
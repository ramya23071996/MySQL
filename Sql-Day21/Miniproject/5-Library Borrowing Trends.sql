
-- 1. Create Tables

CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title VARCHAR(150),
    author VARCHAR(100)
);

CREATE TABLE members (
    member_id INT PRIMARY KEY,
    member_name VARCHAR(100)
);

CREATE TABLE loans (
    loan_id INT PRIMARY KEY,
    book_id INT,
    member_id INT,
    loan_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- 2. Insert Sample Data

-- Books
INSERT INTO books (book_id, title, author) VALUES
(1, 'The Alchemist', 'Paulo Coelho'),
(2, '1984', 'George Orwell'),
(3, 'To Kill a Mockingbird', 'Harper Lee'),
(4, 'Sapiens', 'Yuval Noah Harari');

-- Members
INSERT INTO members (member_id, member_name) VALUES
(101, 'Aarav'),
(102, 'Bhavya'),
(103, 'Chandan'),
(104, 'Diya');

-- Loans
INSERT INTO loans (loan_id, book_id, member_id, loan_date) VALUES
(1001, 1, 101, '2025-07-01'),
(1002, 2, 101, '2025-07-02'),
(1003, 1, 102, '2025-07-03'),
(1004, 3, 103, '2025-07-04'),
(1005, 1, 103, '2025-07-05');

-- 3. Total Loans per Book
SELECT 
    b.title,
    COUNT(*) AS total_loans
FROM loans l
JOIN books b ON l.book_id = b.book_id
GROUP BY b.title;

-- 4. Total Loans per Member
SELECT 
    m.member_name,
    COUNT(*) AS total_loans
FROM loans l
JOIN members m ON l.member_id = m.member_id
GROUP BY m.member_name;

-- 5. Books Borrowed More Than N Times (e.g., N = 2)
SELECT 
    b.title,
    COUNT(*) AS total_loans
FROM loans l
JOIN books b ON l.book_id = b.book_id
GROUP BY b.title
HAVING total_loans > 2;

-- 6. Members Who Have Never Borrowed a Book
SELECT 
    m.member_name
FROM members m
LEFT JOIN loans l ON m.member_id = l.member_id
WHERE l.loan_id IS NULL;
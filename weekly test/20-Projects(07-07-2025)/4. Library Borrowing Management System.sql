-- 📚 Create Database and Tables
CREATE DATABASE IF NOT EXISTS LibraryDB;
USE LibraryDB;

-- Books table
CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100),
    available BOOLEAN DEFAULT TRUE
);

-- Members table
CREATE TABLE Members (
    member_id INT PRIMARY KEY,
    member_name VARCHAR(100) NOT NULL
);

-- BorrowRecords table
CREATE TABLE BorrowRecords (
    record_id INT PRIMARY KEY,
    book_id INT,
    member_id INT,
    borrow_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- 📥 Insert Sample Data
INSERT INTO Books VALUES 
(1, 'The Alchemist', 'Paulo Coelho', TRUE),
(2, '1984', 'George Orwell', TRUE),
(3, 'Clean Code', 'Robert C. Martin', TRUE);

INSERT INTO Members VALUES 
(101, 'Ramya'), (102, 'Arun'), (103, 'Priya');

-- 📅 Filter Borrow Records Between Dates
-- (Assume some borrow records already exist)
SELECT * FROM BorrowRecords
WHERE borrow_date BETWEEN '2025-07-01' AND '2025-07-07';

-- ⏰ Find Overdue Books (not returned yet)
SELECT br.record_id, b.title, m.member_name, br.borrow_date
FROM BorrowRecords br
JOIN Books b ON br.book_id = b.book_id
JOIN Members m ON br.member_id = m.member_id
WHERE br.return_date IS NULL;

-- 🔁 Borrow Book with Transaction and Rollback
-- Example: Member 101 wants to borrow Book 2

START TRANSACTION;

-- Check availability
SELECT available FROM Books WHERE book_id = 2;

-- If available, insert borrow record and update availability
INSERT INTO BorrowRecords (record_id, book_id, member_id, borrow_date)
VALUES (1001, 2, 101, CURDATE());

UPDATE Books SET available = FALSE WHERE book_id = 2;

-- Simulate error (optional)
UPDATE Books SET available = 'maybe' WHERE book_id = 2;

-- If all good
COMMIT;

-- If error occurs
ROLLBACK;
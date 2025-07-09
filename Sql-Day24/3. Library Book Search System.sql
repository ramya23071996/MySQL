-- ============================================
-- 0. CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS LibrarySearch;
USE LibrarySearch;

-- ============================================
-- 1. CREATE NORMALIZED TABLES (3NF)
-- ============================================

-- Authors table
CREATE TABLE IF NOT EXISTS Authors (
    author_id INT PRIMARY KEY,
    author_name VARCHAR(100)
);

-- Genres table
CREATE TABLE IF NOT EXISTS Genres (
    genre_id INT PRIMARY KEY,
    genre_name VARCHAR(100)
);

-- Books table
CREATE TABLE IF NOT EXISTS Books (
    book_id INT PRIMARY KEY,
    book_title VARCHAR(200),
    author_id INT,
    genre_id INT,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id),
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id)
);

-- BorrowHistory table
CREATE TABLE IF NOT EXISTS BorrowHistory (
    borrow_id INT PRIMARY KEY,
    book_id INT,
    borrow_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

-- Authors
INSERT INTO Authors VALUES
(1, 'J.K. Rowling'), (2, 'George Orwell'), (3, 'Jane Austen'), (4, 'Mark Twain');

-- Genres
INSERT INTO Genres VALUES
(1, 'Fantasy'), (2, 'Dystopian'), (3, 'Romance'), (4, 'Adventure');

-- Books
INSERT INTO Books VALUES
(101, 'Harry Potter and the Sorcerer\'s Stone', 1, 1),
(102, '1984', 2, 2),
(103, 'Pride and Prejudice', 3, 3),
(104, 'Adventures of Huckleberry Finn', 4, 4),
(105, 'Harry Potter and the Chamber of Secrets', 1, 1);

-- BorrowHistory
INSERT INTO BorrowHistory VALUES
(1, 101, '2024-07-01'),
(2, 102, '2024-07-02'),
(3, 103, '2024-07-03'),
(4, 101, '2024-07-04'),
(5, 104, '2024-07-05'),
(6, 105, '2024-07-06'),
(7, 101, '2024-07-07'),
(8, 102, '2024-07-08'),
(9, 105, '2024-07-09'),
(10, 101, '2024-07-10');

-- ============================================
-- 3. CREATE INDEXES FOR OPTIMIZATION
-- ============================================

CREATE INDEX idx_book_title ON Books(book_title);
CREATE INDEX idx_author_name ON Authors(author_name);
CREATE INDEX idx_borrow_date ON BorrowHistory(borrow_date);

-- ============================================
-- 4. JOIN + EXPLAIN FOR PERFORMANCE ANALYSIS
-- ============================================

-- Join Books with Authors and BorrowHistory
EXPLAIN
SELECT b.book_title, a.author_name, bh.borrow_date
FROM Books b
JOIN Authors a ON b.author_id = a.author_id
JOIN BorrowHistory bh ON b.book_id = bh.book_id
WHERE bh.borrow_date >= CURDATE() - INTERVAL 30 DAY;

-- ============================================
-- 5. DENORMALIZED REPORTING TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS BookReport (
    book_id INT PRIMARY KEY,
    book_title VARCHAR(200),
    author_name VARCHAR(100),
    last_borrowed DATE
);

-- Insert latest borrow info
INSERT INTO BookReport
SELECT b.book_id, b.book_title, a.author_name,
       MAX(bh.borrow_date) AS last_borrowed
FROM Books b
JOIN Authors a ON b.author_id = a.author_id
JOIN BorrowHistory bh ON b.book_id = bh.book_id
GROUP BY b.book_id, b.book_title, a.author_name;

-- View report
SELECT * FROM BookReport;

-- ============================================
-- 6. TOP BORROWED BOOKS USING LIMIT
-- ============================================

-- Count borrows and list top 3
SELECT b.book_title, COUNT(*) AS borrow_count
FROM BorrowHistory bh
JOIN Books b ON bh.book_id = b.book_id
GROUP BY b.book_title
ORDER BY borrow_count DESC
LIMIT 3;
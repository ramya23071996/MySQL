--  Drop existing tables if they exist
DROP TABLE IF EXISTS BorrowRecords;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS Books;

--  Create Books table
CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100) NOT NULL,
    total_copies INT NOT NULL CHECK (total_copies >= 0)
);

--  Create Members table
CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    join_date DATE DEFAULT CURRENT_DATE
);

--  Create BorrowRecords table
CREATE TABLE BorrowRecords (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    borrow_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    CHECK (due_date >= borrow_date)
);

--  Insert sample books
INSERT INTO Books (title, author, total_copies) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 5),
('1984', 'George Orwell', 4),
('To Kill a Mockingbird', 'Harper Lee', 3);

--  Insert sample members
INSERT INTO Members (name, email) VALUES
('Aarav Mehta', 'aarav.mehta@example.com'),
('Neha Sharma', 'neha.sharma@example.com');

--  Insert borrow records
INSERT INTO BorrowRecords (book_id, member_id, borrow_date, due_date, return_date)
VALUES 
(1, 1, '2025-07-01', '2025-07-15', NULL),
(2, 1, '2025-07-02', '2025-07-16', '2025-07-10'),
(1, 2, '2025-07-05', '2025-07-20', NULL);

--  Update return status
UPDATE BorrowRecords
SET return_date = '2025-07-14'
WHERE record_id = 1;

--  JOIN: Show which member has which book
SELECT m.name AS member_name, b.title AS book_title, br.borrow_date, br.return_date
FROM BorrowRecords br
JOIN Members m ON br.member_id = m.member_id
JOIN Books b ON br.book_id = b.book_id;

--  Use CASE WHEN to label book status
SELECT 
    b.book_id,
    b.title,
    CASE 
        WHEN b.book_id IN (
            SELECT book_id FROM BorrowRecords WHERE return_date IS NULL
        ) THEN 'Borrowed'
        ELSE 'Available'
    END AS status
FROM Books b;

--  Aggregate: Count of books borrowed by each member
SELECT m.name, COUNT(br.record_id) AS total_borrowed
FROM Members m
JOIN BorrowRecords br ON m.member_id = br.member_id
GROUP BY m.name;

--  Subquery: Most borrowed book
SELECT title
FROM Books
WHERE book_id = (
    SELECT book_id
    FROM BorrowRecords
    GROUP BY book_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);
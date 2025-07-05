-- 🔁 Drop existing tables if they exist
DROP TABLE IF EXISTS BorrowRecords;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS Books;

-- 🏗️ Create Books table
CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    is_available BOOLEAN DEFAULT TRUE
);

-- 🏗️ Create Members table
CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    join_date DATE DEFAULT CURRENT_DATE
);

-- 🏗️ Create BorrowRecords table
CREATE TABLE BorrowRecords (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    borrow_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    CHECK (return_date IS NULL OR borrow_date <= return_date)
);

-- 📘 Insert sample books
INSERT INTO Books (title, author, isbn) VALUES
('The Alchemist', 'Paulo Coelho', '9780061122415'),
('1984', 'George Orwell', '9780451524935'),
('To Kill a Mockingbird', 'Harper Lee', '9780060935467');

-- 👤 Insert sample members
INSERT INTO Members (name, email) VALUES
('Ishaan Roy', 'ishaan.roy@example.com'),
('Neha Bhatia', 'neha.bhatia@example.com');

-- 🔄 Borrow multiple books using a transaction
START TRANSACTION;

-- Step 1: Insert borrow records
INSERT INTO BorrowRecords (member_id, book_id, borrow_date)
VALUES (1, 1, '2025-07-05');

INSERT INTO BorrowRecords (member_id, book_id, borrow_date)
VALUES (1, 2, '2025-07-05');

-- Step 2: Update book availability
UPDATE Books SET is_available = FALSE WHERE book_id IN (1, 2);

-- Optional: Simulate failure (e.g., duplicate borrow)
-- INSERT INTO BorrowRecords (member_id, book_id, borrow_date)
-- VALUES (1, 1, '2025-07-05'); -- Will fail if already borrowed

-- ✅ Commit if all successful
COMMIT;

-- ✏️ Update book availability on return
UPDATE BorrowRecords
SET return_date = '2025-07-10'
WHERE record_id = 1;

UPDATE Books
SET is_available = TRUE
WHERE book_id = 1;

-- ❌ Delete outdated borrow records (e.g., returned before 2024)
DELETE FROM BorrowRecords
WHERE return_date IS NOT NULL AND return_date < '2024-01-01';
CREATE DATABASE LibraryDB;
USE LibraryDB;

-- Authors table
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    Name VARCHAR(100)
);

-- Books table
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(150),
    AuthorID INT,
    Available BOOLEAN,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- Members table
CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    Name VARCHAR(100),
    JoinDate DATE
);

-- Loans table
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY,
    BookID INT,
    MemberID INT,
    LoanDate DATE,
    DueDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

-- Authors
INSERT INTO Authors VALUES
(1, 'George Orwell'),
(2, 'J.K. Rowling'),
(3, 'Jane Austen');

-- Books
INSERT INTO Books VALUES
(101, '1984', 1, TRUE),
(102, 'Animal Farm', 1, FALSE),
(103, 'Harry Potter and the Sorcerer''s Stone', 2, FALSE),
(104, 'Pride and Prejudice', 3, TRUE),
(105, 'Emma', 3, TRUE);

-- Members
INSERT INTO Members VALUES
(1, 'Alice Johnson', '2023-01-15'),
(2, 'Bob Smith', '2023-02-10'),
(3, 'Clara Lee', '2023-03-05');

-- Loans
INSERT INTO Loans VALUES
(1, 102, 1, '2023-06-01', '2023-06-15', NULL),
(2, 103, 2, '2023-05-20', '2023-06-05', '2023-06-10');


SELECT B.Title, M.Name AS Borrower
FROM Books B
JOIN Loans L ON B.BookID = L.BookID
JOIN Members M ON L.MemberID = M.MemberID
WHERE L.ReturnDate IS NULL;

SELECT B.Title, M.Name AS Borrower, L.DueDate
FROM Books B
JOIN Loans L ON B.BookID = L.BookID
JOIN Members M ON L.MemberID = M.MemberID
WHERE L.ReturnDate IS NULL AND L.DueDate < CURDATE();

SELECT M.Name, COUNT(*) AS TotalLoans
FROM Members M
JOIN Loans L ON M.MemberID = L.MemberID
GROUP BY M.MemberID
ORDER BY TotalLoans DESC;
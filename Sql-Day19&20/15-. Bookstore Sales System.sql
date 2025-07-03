-- Create the database
CREATE DATABASE IF NOT EXISTS BookstoreDB;
USE BookstoreDB;

-- Drop tables if they already exist
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Customers;

-- Create Books table
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(150),
    Author VARCHAR(100),
    Price DECIMAL(10,2)
);

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100)
);

-- Create Sales table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY AUTO_INCREMENT,
    BookID INT,
    CustomerID INT,
    SaleDate DATE,
    Quantity INT,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert sample books
INSERT INTO Books VALUES
(1, '1984', 'George Orwell', 15.99),
(2, 'To Kill a Mockingbird', 'Harper Lee', 12.50),
(3, 'The Great Gatsby', 'F. Scott Fitzgerald', 10.00),
(4, 'Pride and Prejudice', 'Jane Austen', 9.99),
(5, 'The Alchemist', 'Paulo Coelho', 14.00);

-- Insert sample customers
INSERT INTO Customers VALUES
(101, 'Aarav Mehta', 'aarav@example.com'),
(102, 'Diya Sharma', 'diya@example.com'),
(103, 'Rohan Iyer', 'rohan@example.com');

-- Insert sample sales transactions
INSERT INTO Sales (BookID, CustomerID, SaleDate, Quantity) VALUES
(1, 101, '2025-07-01', 1),
(2, 101, '2025-07-02', 2),
(3, 102, '2025-07-03', 1),
(4, 103, '2025-07-04', 1),
(5, 101, '2025-07-05', 1),
(1, 102, '2025-07-06', 2),
(2, 103, '2025-07-07', 1),
(3, 101, '2025-07-08', 1),
(4, 101, '2025-07-09', 1);

-- Query 1: Best-selling books (by total quantity sold)
SELECT B.Title, SUM(S.Quantity) AS TotalSold
FROM Sales S
JOIN Books B ON S.BookID = B.BookID
GROUP BY S.BookID
ORDER BY TotalSold DESC;

-- Query 2: Customers who purchased more than 3 books
SELECT C.Name, SUM(S.Quantity) AS TotalBooksPurchased
FROM Sales S
JOIN Customers C ON S.CustomerID = C.CustomerID
GROUP BY S.CustomerID
HAVING TotalBooksPurchased > 3;
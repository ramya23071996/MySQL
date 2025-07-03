CREATE DATABASE MovieRentalDB;
USE MovieRentalDB;

-- Movies table
CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    Title VARCHAR(100),
    Genre VARCHAR(50),
    ReleaseYear INT
);

-- Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100)
);

-- Rentals table
CREATE TABLE Rentals (
    RentalID INT PRIMARY KEY AUTO_INCREMENT,
    MovieID INT,
    CustomerID INT,
    RentalDate DATE,
    DueDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Movies
INSERT INTO Movies VALUES
(1, 'Inception', 'Sci-Fi', 2010),
(2, 'The Godfather', 'Crime', 1972),
(3, 'Finding Nemo', 'Animation', 2003),
(4, 'The Dark Knight', 'Action', 2008),
(5, 'Pride and Prejudice', 'Romance', 2005);

-- Customers
INSERT INTO Customers VALUES
(101, 'Aarav Mehta', 'aarav@example.com'),
(102, 'Diya Sharma', 'diya@example.com'),
(103, 'Rohan Iyer', 'rohan@example.com');

-- Rentals
INSERT INTO Rentals (MovieID, CustomerID, RentalDate, DueDate, ReturnDate) VALUES
(1, 101, '2025-06-20', '2025-06-27', '2025-06-26'),
(2, 102, '2025-06-25', '2025-07-02', NULL),
(3, 103, '2025-06-22', '2025-06-29', '2025-06-28'),
(1, 102, '2025-07-01', '2025-07-08', NULL),
(4, 101, '2025-06-30', '2025-07-07', '2025-07-06'),
(1, 103, '2025-07-02', '2025-07-09', NULL);

SELECT C.Name, M.Title, R.DueDate
FROM Rentals R
JOIN Customers C ON R.CustomerID = C.CustomerID
JOIN Movies M ON R.MovieID = M.MovieID
WHERE R.ReturnDate IS NULL AND R.DueDate < CURDATE();

SELECT DISTINCT C.Name
FROM Rentals R
JOIN Customers C ON R.CustomerID = C.CustomerID
JOIN Movies M ON R.MovieID = M.MovieID
WHERE M.Genre = 'Sci-Fi';

SELECT M.Title, COUNT(*) AS RentalCount
FROM Rentals R
JOIN Movies M ON R.MovieID = M.MovieID
GROUP BY R.MovieID
ORDER BY RentalCount DESC
LIMIT 3;

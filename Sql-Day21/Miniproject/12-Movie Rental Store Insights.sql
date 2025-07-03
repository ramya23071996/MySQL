-- Drop tables if they already exist
DROP TABLE IF EXISTS rentals;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS movies;

-- 1. Create Tables

CREATE TABLE movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(100),
    genre VARCHAR(50)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

CREATE TABLE rentals (
    rental_id INT PRIMARY KEY,
    movie_id INT,
    customer_id INT,
    rental_date DATE,
    return_date DATE,
    due_date DATE,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 2. Insert Sample Data

-- Movies
INSERT INTO movies (movie_id, title, genre) VALUES
(1, 'Inception', 'Sci-Fi'),
(2, 'The Godfather', 'Crime'),
(3, 'Finding Nemo', 'Animation'),
(4, 'The Matrix', 'Action'),
(5, 'Amélie', 'Romance');

-- Customers
INSERT INTO customers (customer_id, customer_name) VALUES
(101, 'Ravi'),
(102, 'Sneha'),
(103, 'Ayaan');

-- Rentals
INSERT INTO rentals (rental_id, movie_id, customer_id, rental_date, return_date, due_date) VALUES
(1001, 1, 101, '2025-07-01', '2025-07-05', '2025-07-04'),
(1002, 2, 101, '2025-07-02', '2025-07-06', '2025-07-05'),
(1003, 3, 102, '2025-07-03', NULL, '2025-07-07'),
(1004, 1, 103, '2025-07-04', '2025-07-06', '2025-07-05');

-- 3. Most and Least Rented Movies
-- Most Rented
SELECT 
    m.title,
    COUNT(r.rental_id) AS rental_count
FROM movies m
JOIN rentals r ON m.movie_id = r.movie_id
GROUP BY m.title
ORDER BY rental_count DESC
LIMIT 1;

-- Least Rented
SELECT 
    m.title,
    COUNT(r.rental_id) AS rental_count
FROM movies m
LEFT JOIN rentals r ON m.movie_id = r.movie_id
GROUP BY m.title
ORDER BY rental_count ASC
LIMIT 1;

-- 4. Customers with Overdue Rentals (return_date is NULL and due_date < today)
SELECT 
    c.customer_name,
    r.movie_id,
    m.title,
    r.due_date
FROM rentals r
JOIN customers c ON r.customer_id = c.customer_id
JOIN movies m ON r.movie_id = m.movie_id
WHERE r.return_date IS NULL AND r.due_date < CURDATE();

-- 5. Movies Never Rented
SELECT 
    m.title
FROM movies m
LEFT JOIN rentals r ON m.movie_id = r.movie_id
WHERE r.rental_id IS NULL;
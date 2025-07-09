-- ============================================
-- 0. CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS MovieBooking;
USE MovieBooking;

-- ============================================
-- 1. CREATE NORMALIZED TABLES (3NF)
-- ============================================

-- Users table
CREATE TABLE IF NOT EXISTS Users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100),
    email VARCHAR(100)
);

-- Movies table
CREATE TABLE IF NOT EXISTS Movies (
    movie_id INT PRIMARY KEY,
    movie_name VARCHAR(100),
    genre VARCHAR(50),
    duration_minutes INT
);

-- Halls table
CREATE TABLE IF NOT EXISTS Halls (
    hall_id INT PRIMARY KEY,
    hall_name VARCHAR(100),
    capacity INT
);

-- Shows table
CREATE TABLE IF NOT EXISTS Shows (
    show_id INT PRIMARY KEY,
    movie_id INT,
    hall_id INT,
    show_time DATETIME,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (hall_id) REFERENCES Halls(hall_id)
);

-- Bookings table
CREATE TABLE IF NOT EXISTS Bookings (
    booking_id INT PRIMARY KEY,
    user_id INT,
    show_id INT,
    seat_number VARCHAR(10),
    booking_time DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (show_id) REFERENCES Shows(show_id)
);

-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

-- Users
INSERT INTO Users VALUES
(1, 'Alice', 'alice@example.com'),
(2, 'Bob', 'bob@example.com');

-- Movies
INSERT INTO Movies VALUES
(101, 'Inception', 'Sci-Fi', 148),
(102, 'Interstellar', 'Sci-Fi', 169),
(103, 'The Dark Knight', 'Action', 152);

-- Halls
INSERT INTO Halls VALUES
(1, 'Hall A', 100),
(2, 'Hall B', 80);

-- Shows
INSERT INTO Shows VALUES
(201, 101, 1, '2024-07-10 18:00:00'),
(202, 102, 2, '2024-07-10 20:00:00'),
(203, 103, 1, '2024-07-11 17:00:00'),
(204, 101, 2, '2024-07-11 21:00:00');

-- Bookings
INSERT INTO Bookings VALUES
(1, 1, 201, 'A1', '2024-07-01 10:00:00'),
(2, 2, 202, 'B5', '2024-07-01 11:00:00'),
(3, 1, 203, 'A2', '2024-07-02 09:00:00');

-- ============================================
-- 3. CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX idx_movie_name ON Movies(movie_name);
CREATE INDEX idx_show_time ON Shows(show_time);
CREATE INDEX idx_hall_id ON Shows(hall_id);

-- ============================================
-- 4. EXPLAIN TO OPTIMIZE JOIN QUERIES
-- ============================================

EXPLAIN
SELECT m.movie_name, h.hall_name, s.show_time
FROM Shows s
JOIN Movies m ON s.movie_id = m.movie_id
JOIN Halls h ON s.hall_id = h.hall_id
WHERE m.movie_name = 'Inception';

-- ============================================
-- 5. DENORMALIZED VIEW FOR MOVIE-WISE SHOW DASHBOARD
-- ============================================

CREATE OR REPLACE VIEW MovieShowDashboard AS
SELECT 
    m.movie_name,
    h.hall_name,
    s.show_time,
    h.capacity,
    COUNT(b.booking_id) AS booked_seats,
    (h.capacity - COUNT(b.booking_id)) AS available_seats
FROM Shows s
JOIN Movies m ON s.movie_id = m.movie_id
JOIN Halls h ON s.hall_id = h.hall_id
LEFT JOIN Bookings b ON s.show_id = b.show_id
GROUP BY s.show_id, m.movie_name, h.hall_name, s.show_time, h.capacity;

-- View usage example
SELECT * FROM MovieShowDashboard WHERE movie_name = 'Inception';

-- ============================================
-- 6. PAGINATE AVAILABLE SHOWS USING LIMIT
-- ============================================

SELECT * FROM MovieShowDashboard
WHERE available_seats > 0
ORDER BY show_time ASC
LIMIT 5;
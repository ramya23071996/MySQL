--  Drop existing tables if they exist
DROP TABLE IF EXISTS Tickets;
DROP TABLE IF EXISTS Shows;
DROP TABLE IF EXISTS Movies;
DROP TABLE IF EXISTS Customers;

-- Create Movies table
CREATE TABLE Movies (
    movie_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    duration_minutes INT CHECK (duration_minutes > 0)
);

--  Create Shows table
CREATE TABLE Shows (
    show_id INT PRIMARY KEY AUTO_INCREMENT,
    movie_id INT NOT NULL,
    show_time DATETIME NOT NULL,
    total_seats INT NOT NULL CHECK (total_seats > 0),
    seats_available INT NOT NULL CHECK (seats_available >= 0),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);

--  Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

--  Create Tickets table
CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    show_id INT NOT NULL,
    seat_number INT NOT NULL,
    booking_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (show_id) REFERENCES Shows(show_id),
    UNIQUE (show_id, seat_number) -- Prevent double booking
);

--  Insert sample movies
INSERT INTO Movies (title, genre, duration_minutes) VALUES
('Inception', 'Sci-Fi', 148),
('The Dark Knight', 'Action', 152),
('Interstellar', 'Sci-Fi', 169);

--  Insert sample shows
INSERT INTO Shows (movie_id, show_time, total_seats, seats_available) VALUES
(1, '2025-08-01 18:00:00', 100, 100),
(2, '2025-08-01 21:00:00', 80, 80),
(3, '2025-08-02 17:00:00', 120, 120);

--  Insert sample customers
INSERT INTO Customers (name, email) VALUES
('Aarav Mehta', 'aarav@example.com'),
('Neha Sharma', 'neha@example.com');

--  Book a ticket with rollback on overbooking
START TRANSACTION;

-- Step 1: Check seat availability
SELECT seats_available INTO @available FROM Shows WHERE show_id = 1;

-- Step 2: Proceed only if seats are available
IF @available > 0 THEN
  -- Step 3: Insert ticket
  INSERT INTO Tickets (customer_id, show_id, seat_number) VALUES (1, 1, 10);
  
  -- Step 4: Update seat count
  UPDATE Shows SET seats_available = seats_available - 1 WHERE show_id = 1;
  
  COMMIT;
ELSE
  ROLLBACK;
END IF;

-- JOIN: Full booking info
SELECT 
    t.ticket_id,
    c.name AS customer_name,
    m.title AS movie_title,
    s.show_time,
    t.seat_number
FROM Tickets t
JOIN Customers c ON t.customer_id = c.customer_id
JOIN Shows s ON t.show_id = s.show_id
JOIN Movies m ON s.movie_id = m.movie_id;

-- GROUP BY: Most watched movie
SELECT 
    m.title,
    COUNT(t.ticket_id) AS tickets_sold
FROM Tickets t
JOIN Shows s ON t.show_id = s.show_id
JOIN Movies m ON s.movie_id = m.movie_id
GROUP BY m.title
ORDER BY tickets_sold DESC;

-- UPDATE: Change seat number
UPDATE Tickets
SET seat_number = 15
WHERE ticket_id = 1;

--  DELETE: Cancel a ticket and free the seat
START TRANSACTION;

-- Step 1: Get show_id from ticket
SELECT show_id INTO @show FROM Tickets WHERE ticket_id = 1;

-- Step 2: Delete ticket
DELETE FROM Tickets WHERE ticket_id = 1;

-- Step 3: Update seat availability
UPDATE Shows SET seats_available = seats_available + 1 WHERE show_id = @show;

COMMIT;
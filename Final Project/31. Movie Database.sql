-- 1. Create Movie Database
CREATE DATABASE movie_catalog;
USE movie_catalog;

-- 2. Genres Table
CREATE TABLE genres (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Movies Table
CREATE TABLE movies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    release_year INT,
    genre_id INT,
    FOREIGN KEY (genre_id) REFERENCES genres(id)
);

-- 4. Ratings Table
CREATE TABLE ratings (
    user_id INT,
    movie_id INT,
    score DECIMAL(3,1), -- e.g., 8.5
    PRIMARY KEY (user_id, movie_id),
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);

-- 5. Sample Genres
INSERT INTO genres (name) VALUES
('Action'), ('Drama'), ('Comedy'), ('Sci-Fi'), ('Romance');

-- 6. Sample Movies
INSERT INTO movies (title, release_year, genre_id) VALUES
('Inception', 2010, 4),
('The Dark Knight', 2008, 1),
('The Pursuit of Happyness', 2006, 2),
('Interstellar', 2014, 4),
('Crazy Rich Asians', 2018, 5),
('Forrest Gump', 1994, 2),
('Guardians of the Galaxy', 2014, 1),
('Inside Out', 2015, 3),
('Titanic', 1997, 5),
('The Hangover', 2009, 3);

-- 7. Sample Ratings
INSERT INTO ratings (user_id, movie_id, score) VALUES
(1, 1, 9.0), (2, 1, 8.5), (3, 1, 9.5),
(1, 2, 9.2), (3, 2, 9.0),
(2, 3, 8.0), (4, 3, 8.5),
(1, 4, 9.8), (2, 4, 9.0), (5, 4, 8.8),
(3, 5, 8.0), (5, 5, 8.5),
(1, 6, 9.0), (4, 6, 9.2),
(2, 7, 8.8), (3, 7, 9.0),
(5, 8, 9.5),
(1, 9, 9.1),
(2, 10, 8.0), (4, 10, 7.8);

-- 8. Query: Average Rating per Movie
SELECT 
    m.title,
    ROUND(AVG(r.score), 2) AS avg_rating
FROM movies m
JOIN ratings r ON m.id = r.movie_id
GROUP BY m.title
ORDER BY avg_rating DESC;

-- 9. Query: Movies with Genre Info and Rating Count
SELECT 
    m.title,
    g.name AS genre,
    COUNT(r.user_id) AS total_ratings
FROM movies m
JOIN genres g ON m.genre_id = g.id
LEFT JOIN ratings r ON m.id = r.movie_id
GROUP BY m.title, g.name
ORDER BY total_ratings DESC;

-- 10. Query: Top 5 Highest-Rated Movies (with at least 2 ratings)
SELECT 
    m.title,
    ROUND(AVG(r.score), 2) AS avg_rating
FROM ratings r
JOIN movies m ON r.movie_id = m.id
GROUP BY m.id, m.title
HAVING COUNT(r.user_id) >= 2
ORDER BY avg_rating DESC
LIMIT 5;
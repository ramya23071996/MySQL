-- Create the database
CREATE DATABASE IF NOT EXISTS MusicDB;
USE MusicDB;

-- Drop tables if they already exist
DROP TABLE IF EXISTS PlaylistSongs;
DROP TABLE IF EXISTS Playlists;
DROP TABLE IF EXISTS Songs;
DROP TABLE IF EXISTS Users;

-- Create Users table
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    UserName VARCHAR(100),
    Email VARCHAR(100)
);

-- Create Songs table
CREATE TABLE Songs (
    SongID INT PRIMARY KEY,
    Title VARCHAR(100),
    Artist VARCHAR(100),
    PlayCount INT DEFAULT 0
);

-- Create Playlists table
CREATE TABLE Playlists (
    PlaylistID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    PlaylistName VARCHAR(100),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Create PlaylistSongs table (many-to-many)
CREATE TABLE PlaylistSongs (
    PlaylistID INT,
    SongID INT,
    PRIMARY KEY (PlaylistID, SongID),
    FOREIGN KEY (PlaylistID) REFERENCES Playlists(PlaylistID),
    FOREIGN KEY (SongID) REFERENCES Songs(SongID)
);

-- Insert sample users
INSERT INTO Users VALUES
(1, 'Aarav Mehta', 'aarav@example.com'),
(2, 'Diya Sharma', 'diya@example.com'),
(3, 'Rohan Iyer', 'rohan@example.com');

-- Insert sample songs
INSERT INTO Songs (SongID, Title, Artist, PlayCount) VALUES
(101, 'Shape of You', 'Ed Sheeran', 150),
(102, 'Blinding Lights', 'The Weeknd', 200),
(103, 'Levitating', 'Dua Lipa', 180),
(104, 'Perfect', 'Ed Sheeran', 220),
(105, 'Peaches', 'Justin Bieber', 90);

-- Insert sample playlists
INSERT INTO Playlists (UserID, PlaylistName) VALUES
(1, 'Morning Vibes'),
(1, 'Workout Mix'),
(2, 'Chill Hits'),
(3, 'Top Tracks'),
(3, 'Evening Relax'),
(3, 'Party Mode');

-- Insert songs into playlists
INSERT INTO PlaylistSongs VALUES
(1, 101),
(1, 102),
(2, 103),
(2, 104),
(3, 105),
(4, 101),
(4, 104),
(5, 102),
(5, 103),
(6, 105),
(6, 101);

-- Query 1: Most played songs (top 3)
SELECT Title, Artist, PlayCount
FROM Songs
ORDER BY PlayCount DESC
LIMIT 3;

-- Query 2: Users with more than 2 playlists
SELECT U.UserName, COUNT(P.PlaylistID) AS PlaylistCount
FROM Users U
JOIN Playlists P ON U.UserID = P.UserID
GROUP BY U.UserID
HAVING PlaylistCount > 2;
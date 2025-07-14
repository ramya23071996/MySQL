-- 1. Create Tournament Database
CREATE DATABASE sports_tournament;
USE sports_tournament;

-- 2. Teams Table
CREATE TABLE teams (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Matches Table
CREATE TABLE matches (
    id INT PRIMARY KEY AUTO_INCREMENT,
    team1_id INT,
    team2_id INT,
    match_date DATE,
    FOREIGN KEY (team1_id) REFERENCES teams(id),
    FOREIGN KEY (team2_id) REFERENCES teams(id)
);

-- 4. Scores Table
CREATE TABLE scores (
    match_id INT,
    team_id INT,
    score INT,
    PRIMARY KEY (match_id, team_id),
    FOREIGN KEY (match_id) REFERENCES matches(id),
    FOREIGN KEY (team_id) REFERENCES teams(id)
);

-- 5. Sample Teams
INSERT INTO teams (name) VALUES
('Falcons'), ('Tigers'), ('Wolves'), ('Eagles'), ('Sharks');

-- 6. Sample Matches
INSERT INTO matches (team1_id, team2_id, match_date) VALUES
(1, 2, '2025-07-15'),
(3, 4, '2025-07-16'),
(2, 5, '2025-07-17'),
(1, 3, '2025-07-18'),
(4, 5, '2025-07-19');

-- 7. Sample Scores
-- match_id, team_id, score
INSERT INTO scores VALUES
(1, 1, 3), (1, 2, 1),
(2, 3, 2), (2, 4, 2),
(3, 2, 1), (3, 5, 4),
(4, 1, 2), (4, 3, 0),
(5, 4, 1), (5, 5, 3);

-- 8. Query: Win/Loss/Draw Stats per Team
SELECT 
    t.name AS team,
    SUM(CASE 
        WHEN s.score > opp.score THEN 1
        ELSE 0 END) AS wins,
    SUM(CASE 
        WHEN s.score < opp.score THEN 1
        ELSE 0 END) AS losses,
    SUM(CASE 
        WHEN s.score = opp.score THEN 1
        ELSE 0 END) AS draws
FROM scores s
JOIN scores opp 
    ON s.match_id = opp.match_id 
    AND s.team_id <> opp.team_id
JOIN teams t ON s.team_id = t.id
GROUP BY t.name;

-- 9. Query: Leaderboard by Points
-- Win = 3 pts, Draw = 1 pt, Loss = 0
SELECT 
    t.name AS team,
    SUM(CASE 
        WHEN s.score > opp.score THEN 3
        WHEN s.score = opp.score THEN 1
        ELSE 0 END) AS points
FROM scores s
JOIN scores opp 
    ON s.match_id = opp.match_id AND s.team_id <> opp.team_id
JOIN teams t ON s.team_id = t.id
GROUP BY t.name
ORDER BY points DESC;

-- 10. Query: Match Results Overview
SELECT 
    m.match_date,
    t1.name AS team1,
    s1.score AS score1,
    t2.name AS team2,
    s2.score AS score2
FROM matches m
JOIN scores s1 ON m.id = s1.match_id AND m.team1_id = s1.team_id
JOIN scores s2 ON m.id = s2.match_id AND m.team2_id = s2.team_id
JOIN teams t1 ON s1.team_id = t1.id
JOIN teams t2 ON s2.team_id = t2.id
ORDER BY m.match_date;
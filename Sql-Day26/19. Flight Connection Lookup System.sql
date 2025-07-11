-- Step 1: Create Flights Table
CREATE TABLE Flights (
    flight_id INT PRIMARY KEY,
    departure_airport VARCHAR(10),
    arrival_airport VARCHAR(10)
);

-- Step 2: Insert Sample Flight Data
INSERT INTO Flights VALUES
(1, 'DEL', 'BOM'),
(2, 'BOM', 'BLR'),
(3, 'BLR', 'HYD'),
(4, 'DEL', 'MAA'),
(5, 'MAA', 'BLR'),
(6, 'BLR', 'DEL'),  -- reverse route to test loops
(7, 'HYD', 'GOI'),
(8, 'GOI', 'COK'),
(9, 'COK', 'BLR');

-- Step 3: Recursive CTE to Build Flight Paths
WITH RECURSIVE FlightPaths AS (
    -- Anchor: Start with direct flights
    SELECT 
        departure_airport,
        arrival_airport,
        departure_airport || ' → ' || arrival_airport AS route_path,
        ARRAY[departure_airport, arrival_airport] AS visited_airports,
        1 AS depth
    FROM Flights

    UNION ALL

    -- Recursive step: Join Flights with current paths
    SELECT 
        fp.departure_airport,
        f.arrival_airport,
        fp.route_path || ' → ' || f.arrival_airport,
        visited_airports || f.arrival_airport,
        fp.depth + 1
    FROM FlightPaths fp
    JOIN Flights f ON fp.arrival_airport = f.departure_airport
    WHERE fp.depth < 3
      AND NOT f.arrival_airport = ANY(fp.visited_airports)
)

-- Step 4: Final Output – Valid Paths up to 3 Connections, No Loops
SELECT 
    departure_airport,
    arrival_airport,
    depth,
    route_path
FROM FlightPaths
ORDER BY departure_airport, depth, route_path;
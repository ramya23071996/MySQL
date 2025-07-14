-- 1. Create Database
CREATE DATABASE food_delivery;
USE food_delivery;

-- 2. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Restaurants Table
CREATE TABLE restaurants (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 4. Delivery Agents Table
CREATE TABLE delivery_agents (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 5. Orders Table
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT,
    user_id INT,
    placed_at DATETIME,
    delivered_at DATETIME,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 6. Deliveries Table (assigns agent to each order)
CREATE TABLE deliveries (
    order_id INT PRIMARY KEY,
    agent_id INT,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (agent_id) REFERENCES delivery_agents(id)
);

-- 7. Sample Data

-- Users
INSERT INTO users (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- Restaurants
INSERT INTO restaurants (name) VALUES
('Biryani Express'), ('Green Bowl'), ('Tandoori Nights'), ('Veggie Delight'), ('Pizza Haven');

-- Delivery Agents
INSERT INTO delivery_agents (name) VALUES
('Ajay'), ('Ritika'), ('Manoj'), ('Neha');

-- Orders
INSERT INTO orders (restaurant_id, user_id, placed_at, delivered_at) VALUES
(1, 1, '2025-07-20 12:00:00', '2025-07-20 12:35:00'),
(2, 2, '2025-07-20 12:15:00', '2025-07-20 12:50:00'),
(3, 3, '2025-07-20 13:00:00', NULL),
(4, 4, '2025-07-20 13:30:00', '2025-07-20 14:05:00'),
(5, 5, '2025-07-20 14:00:00', '2025-07-20 14:35:00'),
(1, 2, '2025-07-20 15:00:00', NULL),
(3, 5, '2025-07-20 15:15:00', '2025-07-20 15:55:00');

-- Deliveries
INSERT INTO deliveries (order_id, agent_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 1), (6, 2), (7, 3);

-- 8. Query: Average Delivery Time (Completed Deliveries Only)
SELECT 
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, placed_at, delivered_at)), 2) AS avg_delivery_minutes
FROM orders
WHERE delivered_at IS NOT NULL;

-- 9. Query: Workload Per Delivery Agent
SELECT 
    da.name AS agent,
    COUNT(d.order_id) AS active_orders
FROM deliveries d
JOIN delivery_agents da ON d.agent_id = da.id
JOIN orders o ON d.order_id = o.id
WHERE o.delivered_at IS NULL
GROUP BY da.name;

-- 10. Query: Delivery History for Agent 'Ajay'
SELECT 
    o.id AS order_id,
    r.name AS restaurant,
    u.name AS customer,
    o.placed_at,
    o.delivered_at
FROM deliveries d
JOIN orders o ON d.order_id = o.id
JOIN restaurants r ON o.restaurant_id = r.id
JOIN users u ON o.user_id = u.id
JOIN delivery_agents da ON d.agent_id = da.id
WHERE da.name = 'Ajay'
ORDER BY o.placed_at;
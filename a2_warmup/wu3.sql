-- Warmup Query 3

-- You must not change the next 2 lines or the table or type definition.
SET SEARCH_PATH TO AirTravelWarmup;
DROP TABLE IF EXISTS wu3 CASCADE;

DROP TYPE IF EXISTS size_type CASCADE;
CREATE TYPE AirTravelWarmup.size_type AS ENUM (
    'large', 'medium', 'small'
);

CREATE TABLE wu3 (
    airline_code CHAR(2),
    size size_type NOT NULL,
    num_planes int NOT NULL
);

-- Do this for each of the views that define your intermediate steps.
-- (But give them better names!) The IF EXISTS avoids generating an error
-- the first time this file is imported.
-- If you do not define any views, you can delete the lines about views.
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here:
CREATE VIEW intermediate_step AS 
SELECT 
    p.airline AS airline_code,
    CASE
        WHEN COUNT(DISTINCT s.class) = 3 AND MAX(s.row) >= 45 THEN 'large'
        WHEN COUNT(DISTINCT s.class) >= 2 AND MAX(s.row) >= 30 THEN 'medium'
        ELSE 'small'
    END AS size
FROM Plane p
JOIN Seat s ON p.tail_number = s.plane
GROUP BY p.airline, p.tail_number;


-- Your query that answers the question goes below the "insert into" line:
INSERT INTO wu3
SELECT airline_code, size::size_type, COUNT(*) AS num_planes
FROM intermediate_step
GROUP BY airline_code, size;


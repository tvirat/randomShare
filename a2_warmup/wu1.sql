-- Warmup Query 1

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO AirTravelWarmup;
DROP TABLE IF EXISTS wu1 CASCADE;

CREATE TABLE wu1 (
    last_name VARCHAR(200) NOT NULL,
    p1_first_name VARCHAR(200) NOT NULL,
    p2_first_name VARCHAR(200) NOT NULL
);

-- Do this for each of the views that define your intermediate steps.
-- (But give them better names!) The IF EXISTS avoids generating an error
-- the first time this file is imported.
-- If you do not define any views, you can delete the lines about views.
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here:
CREATE VIEW intermediate_step AS
SELECT 
    p1.last_name AS last_name, 
    p1.first_name AS p1_first_name, 
    p2.first_name AS p2_first_name
FROM Booking b1
JOIN Passenger p1 ON b1.passenger = p1.pid
JOIN Booking b2 ON b1.flight = b2.flight AND b1.bid < b2.bid
JOIN Passenger p2 ON b2.passenger = p2.pid
WHERE p1.last_name = p2.last_name
AND ABS(EXTRACT(EPOCH FROM (b1.date_time - b2.date_time))) <= 3600;

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO wu1
SELECT * FROM intermediate_step;

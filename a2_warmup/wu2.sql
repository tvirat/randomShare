-- Warmup Query 2

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO AirTravelWarmup;
DROP TABLE IF EXISTS wu2 CASCADE;

CREATE TABLE wu2 (
    country_name VARCHAR(200) NOT NULL,
    operational_airports INT NOT NULL
);

-- Do this for each of the views that define your intermediate steps.
-- (But give them better names!) The IF EXISTS avoids generating an error
-- the first time this file is imported.
-- If you do not define any views, you can delete the lines about views.
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here:
CREATE VIEW countries_with_airports AS
SELECT ci.country AS country_name
FROM Airport a
JOIN City ci ON a.city = ci.cid
GROUP BY ci.country
HAVING COUNT(a.code) >= 2;

CREATE VIEW op_airports_per_country AS
SELECT ci.country AS country_name, COUNT(DISTINCT a.code) AS operational_airports
FROM Airport a
JOIN City ci ON a.city = ci.cid
WHERE a.code IN (
    SELECT source FROM Flight f JOIN Route r ON f.route = r.flight_num
    UNION
    SELECT destination FROM Flight f JOIN Route r ON f.route = r.flight_num
)
GROUP BY ci.country;

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO wu2
SELECT cwa.country_name, COALESCE(oapc.operational_airports, 0)
FROM countries_with_airports cwa
LEFT JOIN op_airports_per_country oapc
ON cwa.country_name = oapc.country_name;

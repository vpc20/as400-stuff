-- recursive common table expressions and recursive views
WITH destinations (origin, departure, arrival, flight_count) AS
       (SELECT flo.departure, flo.departure, flo.arrival, 1
        FROM flights flo
        WHERE flo.departure = 'Chicago'
        UNION ALL
        SELECT dest.origin, flr.departure, flr.arrival, dest.flight_count + 1
        FROM destinations dest,
             flights flr
        WHERE dest.arrival = flr.departure)
SELECT origin, departure, arrival, flight_count
FROM destinations;

-- You can write the previous recursive common table expression as a recursive view like this:
CREATE VIEW destinations (origin, departure, arrival, flight_count) AS
SELECT departure, departure, arrival, 1
FROM flights
WHERE departure = 'Chicago'
UNION ALL
SELECT dest.origin, fl.departure, fl.arrival, dest.flight_count + 1
FROM destinations dest,
     flights fl
WHERE dest.arrival = fl.departure;

SELECT *
FROM destinations;
DROP VIEW destinations;
-------------------------------------------------------------------------------

-- Two starting cities using recursive common table expressions
WITH destinations (departure, arrival, connections, cost) AS
       (SELECT a.departure, a.arrival, 0, price
        FROM flights a
        WHERE a.departure = 'Chicago'
           OR a.departure = 'New York'
        UNION ALL
        SELECT r.departure,
               b.arrival,
               r.connections + 1,
               r.cost + b.price
        FROM destinations r,
             flights b
        WHERE r.arrival = b.departure)
SELECT departure, arrival, connections, cost
FROM destinations;


-- Two tables used for recursion using recursive common table expressions
WITH destinations (departure, arrival, connections, flights, trains, cost) AS
       (SELECT f.departure, f.arrival, 0, 1, 0, price
        FROM flights f
        WHERE f.departure = 'Chicago'
        UNION ALL
        SELECT t.departure, t.arrival, 0, 0, 1, price
        FROM trains t
        WHERE t.departure = 'Chicago'
        UNION ALL
        SELECT r.departure, b.arrival, r.connections + 1, r.flights + 1, r.trains, r.cost + b.price
        FROM destinations r,
             flights b
        WHERE r.arrival = b.departure
        UNION ALL
        SELECT r.departure, c.arrival, r.connections + 1, r.flights, r.trains + 1, r.cost + c.price
        FROM destinations r,
             trains c
        WHERE r.arrival = c.departure)
SELECT departure, arrival, connections, flights, trains, cost
FROM destinations;

-- DEPTH FIRST and BREADTH FIRST options for recursive common table expressions
WITH destinations (origin, departure, arrival, connections, cost) AS
       (SELECT f.departure, f.departure, f.arrival, 0, price
        FROM flights f
        WHERE f.departure = 'Chicago'
        UNION ALL
        SELECT r.origin, b.departure, b.arrival, r.connections + 1, r.cost + b.price
        FROM destinations r,
             flights b
        WHERE r.arrival = b.departure)
  SEARCH DEPTH FIRST BY arrival
SET ordcol
SELECT *
FROM destinations
ORDER BY ordcol;


WITH destinations (origin, departure, arrival, connections, cost) AS
       (SELECT f.departure, f.departure, f.arrival, 0, price
        FROM flights f
        WHERE f.departure = 'Chicago'
        UNION ALL
        SELECT r.origin, b.departure, b.arrival, r.connections + 1, r.cost + b.price
        FROM destinations r,
             flights b
        WHERE r.arrival = b.departure)
  SEARCH DEPTH FIRST BY arrival
SET ordcol
SELECT *
FROM destinations
ORDER BY ordcol;


-- Cyclic data using recursive common table expressions
INSERT INTO flights
VALUES ('Cairo', 'Paris', 'Euro Air', '1134', 440);

WITH destinations (departure, arrival, connections, cost, itinerary) AS
       (SELECT f.departure,
               f.arrival,
               1,
               price,
               CAST(TRIM(f.departure) || '->' || TRIM(f.arrival) AS VARCHAR(2000))
        FROM flights f
        WHERE f.departure = 'New York'
        UNION ALL
        SELECT r.departure,
               b.arrival,
               r.connections + 1,
               r.cost + b.price,
               CAST(TRIM(r.itinerary) || '->' || TRIM(b.arrival) AS VARCHAR(2000))
        FROM destinations r,
             flights b
        WHERE r.arrival = b.departure)
  CYCLE arrival
SET cyclic_data TO '1' DEFAULT '0'
SELECT departure, arrival, itinerary, cyclic_data
FROM destinations;

SELECT *
FROM flights
WHERE departure = 'Cairo'
  AND arrival = 'Paris';

-- delete test data for cyclic recursion
DELETE
FROM flights
WHERE departure = 'Cairo'
  AND arrival = 'Paris';
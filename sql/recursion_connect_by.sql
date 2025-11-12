SET current schema vcprzkh1;

CREATE TABLE vpcrzkh1.flights
(
  departure     CHAR(20),
  arrival       CHAR(20),
  carrier       CHAR(15),
  flight_number CHAR(5),
  price         INT
);

INSERT INTO vpcrzkh1.flights
VALUES ('New York', 'Paris', 'Atlantic', '234', 400);
INSERT INTO vpcrzkh1.flights
VALUES ('Chicago', 'Miami', 'NA Air', '2334', 300);
INSERT INTO vpcrzkh1.flights
VALUES ('New York', 'London', 'Atlantic', '5473', 350);
INSERT INTO vpcrzkh1.flights
VALUES ('London', 'Athens', 'Mediterranean', '247', 340);
INSERT INTO vpcrzkh1.flights
VALUES ('Athens', 'Nicosia', 'Mediterranean', '2356', 280);
INSERT INTO vpcrzkh1.flights
VALUES ('Paris', 'Madrid', 'Euro Air', '3256', 380);
INSERT INTO vpcrzkh1.flights
VALUES ('Paris', 'Cairo', 'Euro Air', '63', 480);
INSERT INTO vpcrzkh1.flights
VALUES ('Chicago', 'Frankfurt', 'Atlantic', '37', 480);
INSERT INTO vpcrzkh1.flights
VALUES ('Frankfurt', 'Moscow', 'Asia Air', '2337', 580);
INSERT INTO vpcrzkh1.flights
VALUES ('Frankfurt', 'Beijing', 'Asia Air', '77', 480);
INSERT INTO vpcrzkh1.flights
VALUES ('Moscow', 'Tokyo', 'Asia Air', '437', 680);
INSERT INTO vpcrzkh1.flights
VALUES ('Frankfurt', 'Vienna', 'Euro Air', '59', 200);
INSERT INTO vpcrzkh1.flights
VALUES ('Paris', 'Rome', 'Euro Air', '534', 340);
INSERT INTO vpcrzkh1.flights
VALUES ('Miami', 'Lima', 'SA Air', '5234', 530);
INSERT INTO vpcrzkh1.flights
VALUES ('New York', 'Los Angeles', 'NA Air', '84', 330);
INSERT INTO vpcrzkh1.flights
VALUES ('Los Angeles', 'Tokyo', 'Pacific Air', '824', 530);
INSERT INTO vpcrzkh1.flights
VALUES ('Tokyo', 'Hawaii', 'Asia Air', '94', 330);
INSERT INTO vpcrzkh1.flights
VALUES ('Washington', 'Toronto', 'NA Air', '104', 250);


CREATE TABLE vpcrzkh1.trains
(
  departure CHAR(20),
  arrival   CHAR(20),
  railline  CHAR(15),
  train     CHAR(5),
  price     INT
);

INSERT INTO trains
VALUES ('Chicago', 'Washington', 'UsTrack', '323', 90);
INSERT INTO trains
VALUES ('Madrid', 'Barcelona', 'EuroTrack', '5234', 60);
INSERT INTO trains
VALUES ('Washington', 'Boston', 'UsTrack', '232', 50);


CREATE TABLE flightstats
(
  flight#         CHAR(5),
  on_time_percent DECIMAL(5, 2),
  cancel_percent  DECIMAL(5, 2)
);

INSERT INTO flightstats
VALUES ('234', 85.0, 0.20);
INSERT INTO flightstats
VALUES ('2334', 92.0, 0.10);
INSERT INTO flightstats
VALUES ('5473', 86.2, 0.10);
INSERT INTO flightstats
VALUES ('247', 91.0, 0.10);
INSERT INTO flightstats
VALUES ('2356', 91.0, 0.10);
INSERT INTO flightstats
VALUES ('3256', 92.0, 0.10);
INSERT INTO flightstats
VALUES ('63', 90.5, 0.10);
INSERT INTO flightstats
VALUES ('37', 87.0, 0.20);
INSERT INTO flightstats
VALUES ('2337', 80.0, 0.20);
INSERT INTO flightstats
VALUES ('77', 86.0, 0.10);
INSERT INTO flightstats
VALUES ('437', 81.0, 0.10);
INSERT INTO flightstats
VALUES ('59', 85.0, 01.0);
INSERT INTO flightstats
VALUES ('534', 87.0, 01.0);
INSERT INTO flightstats
VALUES ('5234', 88.0, 0.20);
INSERT INTO flightstats
VALUES ('84', 88.0, 0.1);
INSERT INTO flightstats
VALUES ('824', 93.0, 0.10);
INSERT INTO flightstats
VALUES ('94', 92.0, 0.10);
INSERT INTO flightstats
VALUES ('104', 93.0, 0.10);


SELECT CONNECT_BY_ROOT departure AS origin, departure, arrival, level AS flight_count
FROM flights
START WITH departure = 'Chicago'
CONNECT BY PRIOR arrival = departure;

-- show all the recursive flights
SELECT CONNECT_BY_ROOT departure AS origin, departure, arrival, level AS flight_count
FROM flights
CONNECT BY PRIOR arrival = departure
ORDER BY origin, flight_count;


SELECT CONNECT_BY_ROOT departure AS departure, arrival, level - 1 connections
FROM (SELECT departure, arrival
      FROM flights
      UNION
      SELECT departure, arrival
      FROM trains) t
START WITH departure = 'Chicago'
CONNECT BY PRIOR arrival = departure;


SELECT CONNECT_BY_ROOT departure AS origin,
       departure,
       arrival,
       level                        level,
       price                        ticket_price
FROM flights
START WITH departure = 'New York'
CONNECT BY PRIOR arrival = departure
ORDER SIBLINGS BY price ASC;

-- add record which causes cyclic recursion
INSERT INTO flights
VALUES ('Cairo', 'Paris', 'Atlantic', '1134', 440);

-- delete after testing to prevent infinite recursion
DELETE
FROM flights
WHERE departure = 'Cairo'
  AND arrival = 'Paris';

-- show cycle indicator
-- use nocycle option to prevent infinite recursion
SELECT CONNECT_BY_ROOT departure AS              origin,
       arrival,
       SYS_CONNECT_BY_PATH(TRIM(arrival), ' : ') itinerary,
       connect_by_iscycle                        cyclic
FROM flights
START WITH departure = 'New York'
CONNECT BY NOCYCLE PRIOR arrival = departure;

-- show only the cyclic data
SELECT CONNECT_BY_ROOT departure AS              origin,
       arrival,
       SYS_CONNECT_BY_PATH(TRIM(arrival), ' : ') itinerary,
       connect_by_iscycle                        cyclic
FROM flights
WHERE connect_by_iscycle = 1
START WITH departure = 'New York'
CONNECT BY NOCYCLE PRIOR arrival = departure;

-- show leaf indicator - leaf rows are rows in which there are no further recursion
SELECT CONNECT_BY_ROOT departure AS              origin,
       arrival,
       SYS_CONNECT_BY_PATH(TRIM(arrival), ' : ') itinerary,
       connect_by_isleaf                         leaf
FROM flights
START WITH departure = 'New York'
CONNECT BY PRIOR arrival = departure;

-- show only leaf rows
SELECT CONNECT_BY_ROOT departure AS              origin,
       arrival,
       SYS_CONNECT_BY_PATH(TRIM(arrival), ' : ') itinerary,
       connect_by_isleaf                         leaf
FROM flights
WHERE connect_by_isleaf = 1
START WITH departure = 'New York'
CONNECT BY PRIOR arrival = departure;

-- Example: Join predicates and where clause selection with CONNECT BY
SELECT CONNECT_BY_ROOT fl.departure AS origin,
       fl.departure,
       fl.arrival,
       fl.flight_number,
       fls.on_time_percent          AS ontime
FROM flights fl
INNER JOIN flightstats fls
           ON fl.flight_number = fls.flight#
WHERE fls.on_time_percent > 90
START WITH fl.departure = 'New York'
CONNECT BY PRIOR fl.arrival = fl.departure;

-- no resulting rows since all flights are checked for greater than 90% on-time stats
SELECT CONNECT_BY_ROOT departure AS origin,
       departure,
       arrival,
       flight_number,
       on_time_percent
                                 AS ontime
FROM (SELECT departure, arrival, flight_number, on_time_percent
      FROM flights,
           flightstats
      WHERE flight_number = flight#
        AND on_time_percent > 90) t1
START WITH departure = 'New York'
CONNECT BY PRIOR arrival = departure;



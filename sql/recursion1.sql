set current schema vcprzkh1;

CREATE TABLE vpcrzkh1.flights (
      departure CHAR(20),
      arrival CHAR(20),
      carrier CHAR(15),
      flight_number CHAR(5),
      price INT
    );
 
INSERT INTO vpcrzkh1.FLIGHTS VALUES('New York', 'Paris', 'Atlantic', '234', 400);
INSERT INTO vpcrzkh1.FLIGHTS VALUES('Chicago', 'Miami', 'NA Air', '2334', 300);
INSERT INTO vpcrzkh1.FLIGHTS VALUES('New York', 'London', 'Atlantic', '5473', 350);
INSERT INTO vpcrzkh1.FLIGHTS VALUES('London', 'Athens' , 'Mediterranean', '247', 340);
INSERT INTO vpcrzkh1.FLIGHTS VALUES('Athens', 'Nicosia' , 'Mediterranean', '2356', 280); 
INSERT INTO vpcrzkh1.FLIGHTS VALUES('Paris', 'Madrid' , 'Euro Air', '3256', 380);
INSERT INTO vpcrzkh1.FLIGHTS VALUES('Paris', 'Cairo' , 'Euro Air', '63', 480);
INSERT INTO vpcrzkh1.FLIGHTS VALUES('Chicago', 'Frankfurt', 'Atlantic', '37', 480);
INSERT INTO vpcrzkh1.FLIGHTS VALUES('Frankfurt', 'Moscow', 'Asia Air', '2337', 580);
INSERT INTO vpcrzkh1.FLIGHTS VALUES('Frankfurt', 'Beijing', 'Asia Air', '77', 480); 
INSERT INTO vpcrzkh1.FLIGHTS VALUES('Moscow', 'Tokyo', 'Asia Air', '437', 680);
INSERT INTO vpcrzkh1.FLIGHTS VALUES('Frankfurt', 'Vienna', 'Euro Air', '59', 200);
INSERT INTO vpcrzkh1.FLIGHTS VALUES('Paris', 'Rome', 'Euro Air', '534', 340);
INSERT INTO vpcrzkh1.FLIGHTS VALUES('Miami', 'Lima', 'SA Air', '5234', 530);
INSERT INTO vpcrzkh1.FLIGHTS VALUES('New York', 'Los Angeles', 'NA Air', '84', 330);
INSERT INTO vpcrzkh1.FLIGHTS VALUES('Los Angeles', 'Tokyo', 'Pacific Air', '824', 530);
INSERT INTO vpcrzkh1.FLIGHTS VALUES('Tokyo', 'Hawaii', 'Asia Air', '94', 330);
INSERT INTO vpcrzkh1.FLIGHTS VALUES('Washington', 'Toronto', 'NA Air', '104', 250);

SELECT CONNECT_BY_ROOT departure AS origin, departure, arrival, level AS flight_count
  FROM vpcrzkh1.flights
  START WITH departure = 'Chicago'
  CONNECT BY PRIOR arrival = departure;

SELECT CONNECT_BY_ROOT departure AS origin, departure, arrival, level AS flight_count
  FROM vpcrzkh1.flights
  CONNECT BY PRIOR arrival = departure
  ORDER BY origin, flight_count;

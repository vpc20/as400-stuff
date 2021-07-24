DROP TABLE vpcrzkh1.datatypes;

create table vpcrzkh1.datatypes (
         int1 integer not null with default,
         smallint1 smallint not null with default,
         bigint1 bigint not null with default,
         float1 float not null with default,
         decfloat1 decfloat not null with default,
         numeric1 numeric not null with default,
         decimal1 decimal not null with default,
         char1 char not null with default,
         varchar1 varchar(128) not null with default,
         lvarchar1 long varchar not null with default,
         binary1 binary not null with default,
         varbinary1 varbinary(128) not null with default,
         date1 date not null with default,
         time1 time not null with default,
         timestamp1 timestamp not null with default,
         graphic1 graphic not null with default,
         vargraph1 vargraphic(128) not null with default,
         real1 real not null with default,
         double1 double not null with default,
         clob1 clob not null with default,
         blob1 blob not null with default,
         dbclob1 dbclob not null with default,
         rowid1 rowid not null
      );
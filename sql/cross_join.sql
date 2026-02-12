-- Using a Cross Join (No Link)
-- If the tables have no relationship and you just want every possible combination 
-- (or they both only have one row), you use a CROSS JOIN.

SELECT table1.col1, table2.col2
FROM table1
CROSS JOIN table2;
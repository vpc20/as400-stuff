WITH DeptSales AS (
    -- Define the summary once
    SELECT Department, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY Department
)
-- Reference the SAME CTE twice with different aliases
SELECT 
    d.Department, 
    d.TotalSales AS DeptTotal, 
    c.TotalSales AS CorpTotal,
    (d.TotalSales - c.TotalSales) AS Difference
FROM DeptSales d
JOIN DeptSales c ON c.Department = 'Corporate'
WHERE d.Department <> 'Corporate';

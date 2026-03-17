WITH RECURSIVE OrgChart AS (
    -- 1. THE ANCHOR: Find the CEO (who has no manager)
    SELECT EmpID, Name, ManagerID, 1 AS Level
    FROM Employees
    WHERE ManagerID IS NULL

    UNION ALL

    -- 2. THE RECURSIVE MEMBER: Join the CTE back to the table
    -- Find everyone who reports to the people found in the previous step
    SELECT e.EmpID, e.Name, e.ManagerID, oc.Level + 1
    FROM Employees e
    INNER JOIN OrgChart oc ON e.ManagerID = oc.EmpID
)
SELECT * FROM OrgChart ORDER BY Level;
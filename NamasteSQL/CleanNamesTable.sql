-- Approach1 - Using PARSENAME, REPLACE, LOWER, UPPER, LEFT, and RIGHT
WITH cte_names AS (
  SELECT
     LOWER(PARSENAME(REPLACE(name,' ','.'),2)) AS fname
    ,LOWER(PARSENAME(REPLACE(name,' ','.'),1)) AS lname
  FROM NamasteSQL.Names
)

SELECT 
   UPPER(LEFT(fname,1))+RIGHT(fname,LEN(fname)-1) AS first_name
  ,UPPER(LEFT(lname,1))+RIGHT(lname,LEN(lname)-1) AS last_name
FROM cte_names;

-- Approach2 - Using CHARINDEX, SUBSTRING, LOWER, UPPER, LEFT, and RIGHT
WITH cte_names AS (
  SELECT
     LOWER(SUBSTRING(name, 1, CHARINDEX(' ', name)-1)) AS fname
    ,LOWER(SUBSTRING(name, CHARINDEX(' ', name)+1, LEN(name) - CHARINDEX(' ', name))) AS lname
FROM NamasteSQL.Names)

SELECT 
   UPPER(LEFT(fname,1))+RIGHT(fname,LEN(fname)-1) AS first_name
  ,UPPER(LEFT(lname,1))+RIGHT(lname,LEN(lname)-1) AS last_name
FROM cte_names;
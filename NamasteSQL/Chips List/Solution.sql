-- Split the Chips column into multiple rows by delimiter & CROSS APPLY with Main Table
WITH CTE_Chips AS (
SELECT T.Chips, C.Ordinal, TRIM(C.Value) AS Chips_List
FROM Chips_tbl T
CROSS APPLY STRING_SPLIT(Chips,',',1) C
),
-- Split the Amount column into multiple rows by delimiter & CROSS APPLY with Main Table
CTE_Amt AS (
SELECT T.Chips, A.Ordinal, A.Value AS Amt
FROM Chips_tbl T
CROSS APPLY STRING_SPLIT(Amount,',',1) A)

-- JOIN both the CTEs on Main Table Chips Column & Ordinal/Index of each chips to identify the price
SELECT C.Chips_List, A.Amt FROM 
CTE_Chips C INNER JOIN CTE_Amt A
ON C.Chips = A.Chips AND C.Ordinal = A.Ordinal;
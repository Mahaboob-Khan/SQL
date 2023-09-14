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
CROSS APPLY STRING_SPLIT(Amount,',',1) A
)
-- JOIN both the CTEs on Main Table Chips Column & Ordinal/Index of each chips to identify the price
SELECT Chips.Chips_List, Amt.Amt 
FROM CTE_Chips Chips 
INNER JOIN CTE_Amt Amt
	ON Chips.Chips = Amt.Chips 
	AND Chips.Ordinal = Amt.Ordinal;
-- Using Recursive CTE
	-- Structure: Base Query UNION ALL recursive query with condition
	-- Create a base query with existing columns & length of skill_name
	-- Create another query to pull the data recursively from above query until the condition is true
	-- UNION ALL to combine the results of both the queries
WITH cte_repeat AS (
	SELECT skill_id, skill_name, LEN(skill_name) AS Num 
	FROM Skills_data
	UNION ALL
	SELECT skill_id, skill_name, Num - 1 
	FROM cte_repeat
	WHERE Num > 1
)
SELECT skill_id, skill_name
FROM cte_repeat
ORDER BY skill_id;
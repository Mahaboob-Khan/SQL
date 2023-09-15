-- Assigning the row number for each record, and row number order by date for partitions (with & without flag value NULL)
-- Perform rnum1 - rnum2 to get the different value assigned to each group of NULL records and add new row number to get running number
WITH cte_data AS (
	SELECT 
		 id
		,date
		,flag
		,ROW_NUMBER() OVER(ORDER BY date, id) AS rnum1
		,ROW_NUMBER() OVER(PARTITION BY id, (CASE WHEN flag IS NULL THEN 1 ELSE 0 END) ORDER BY date) AS rnum2
	FROM log_tbl
)

SELECT 
	 id
	,date
	,flag
	,CASE
		WHEN flag IS NULL THEN
  			ROW_NUMBER() OVER(PARTITION BY id, rnum1-rnum2 ORDER BY id, date)
		ELSE NULL
	 END AS running_num
FROM cte_data
ORDER BY id, date;
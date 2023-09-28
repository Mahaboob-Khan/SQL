-- Applying COUNT DISTINCT in identifying the unique customers
--			COUNT in identifying the total transactions
--			MIN & MIX in identifying the first & last transaction time
--			DATEDIFF to calculate the difference between first & last transaction time
SELECT 
   COUNT(DISTINCT name) AS unique_names
  ,COUNT(trans_id) AS trans
  ,DATEDIFF(MINUTE, MIN(date_time), MAX(date_time)) AS diff_in_mins
FROM NamasteSQL.Transaction_tbl
WHERE CAST(date_time AS DATE) = '2023-01-02';
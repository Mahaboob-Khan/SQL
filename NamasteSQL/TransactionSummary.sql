-- Using GROUP BY, CASE WHEN along with SUM aggregation
SELECT
   FORMAT(trans_date, 'yyyy-MM') AS year_month
  ,country
  ,COUNT(Id) AS trans_count
  ,SUM(CASE WHEN LOWER(state)='approved' THEN 1 ELSE 0 END) AS approved_count
  ,SUM(CASE WHEN LOWER(state)='declined' THEN 1 ELSE 0 END) AS declined_count
  ,SUM(amount) AS trans_total_amount
  ,SUM(CASE WHEN LOWER(state)='approved' THEN amount ELSE 0 END) AS approved_total_amount 
FROM NamasteSQL.transactions_tbl 
GROUP BY FORMAT(trans_date, 'yyyy-MM'), country
ORDER BY year_month, trans_total_amount DESC;
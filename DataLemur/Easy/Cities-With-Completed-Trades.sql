/*
Cities With Completed Trades [Robinhood SQL Interview Question]
===============================================================
Learning from the problem:
	1. Applying the JOIN between Trades & Users table to find the Completed trades
	2. Applying the GROUP BY() & COUNT() aggregation to find the no of completed Trades by each city
	3. Applying the ORDER BY cluase to sort the results by descending order of completed trades
	4. Applying the LIMIT to limit the resultset

Order of Execution:
	=> FROM & INNER JOIN => WHERE => GROUP BY() => SELECT => ORDER BY => LIMIT
*/
SELECT
   u.city
  ,COUNT(t.order_id) AS total_orders
FROM
  trades t
INNER JOIN
  users u
ON t.user_id = u.user_id
WHERE
  t.status = 'Completed'
GROUP BY
  u.city
ORDER BY
  total_orders DESC
LIMIT 3;
/*
Compressed Mean [Alibaba SQL Interview Question]
================================================
Learnings from the problem
	1. Calculating the mean value using mathematical expression & rouding the decimal point to one digit
	2. Numerator is multiplied with 1.0 to get the decimal result instead of integer
	
Order of Execution:
	=> FROM => SELECT
*/
SELECT
  ROUND(
	1.0 * SUM(item_count * order_occurrences) / SUM(order_occurrences)
	,1
	) AS mean
FROM
  items_per_order;